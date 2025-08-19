/**
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE', which is part of Hpmoon repository.
 *
 * This work has been funded by:
 *
 * Spanish 'Ministerio de Economía y Competitividad' under grants number TIN2012-32039 and TIN2015-67020-P.\n
 * Spanish 'Ministerio de Ciencia, Innovación y Universidades' under grant number PGC2018-098813-B-C31.\n
 * European Regional Development Fund (ERDF).
 *
 * @file main.cpp
 * @author Juan José Escobar Pérez
 * @date 08/07/2015
 * @brief A parallel and distributed multi-objective genetic algorithm to EEG classification
 * @copyright Hpmoon (c) 2015 EFFICOMP
 */

/********************************* Includes ********************************/

#include "bd.h"
#include "ag.h"
#include "evaluation.h"

// Logging
#include <fstream>
#include <ctime>
#include "log_config.h"
/**
 * @brief Main program
 * @param argc The number of arguments of the program
 * @param argv Arguments of the program
 */

int main(const int argc, const char **argv)
{
	std::time_t now = std::time(nullptr);

#if LOG_ENABLED
	std::cout << "Process [main]: Execution started: " << std::ctime(&now) << std::endl;
	std::cout << "Process [main]: Arguments: ";
	for (int i = 0; i < argc; ++i)
		std::cout << argv[i] << " ";
	std::cout << std::endl;

	std::cout << "Process [main]: Initializing MPI environment..." << std::endl;
#endif
	MPI::Init_thread(MPI_THREAD_MULTIPLE);

#if LOG_ENABLED
	std::cout << "Process [main]: Reading configuration..." << std::endl;
#endif
	Config conf(argc, argv);

#if LOG_ENABLED
	std::cout << "Process " << conf.mpiRank << " [main]: MPI Rank: " << conf.mpiRank << ", MPI Size: " << conf.mpiSize << std::endl;
#endif

	Individual *subpops;
	int *selInstances;
	srand((uint)time(NULL) + conf.mpiRank);

	// Master prints configuration parameters
	if (conf.mpiRank == 0)
	{
#if LOG_ENABLED
		std::cout << "Process " << conf.mpiRank << " [main]: Configuration parameters:" << std::endl;
		std::cout << "Process " << conf.mpiRank << " [main]:   nSubpopulations:      " << conf.nSubpopulations << std::endl;
		std::cout << "Process " << conf.mpiRank << " [main]:   subpopulationSize:    " << conf.subpopulationSize << std::endl;
		std::cout << "Process " << conf.mpiRank << " [main]:   nGlobalMigrations:    " << conf.nGlobalMigrations << std::endl;
		std::cout << "Process " << conf.mpiRank << " [main]:   nGenerations:         " << conf.nGenerations << std::endl;
		std::cout << "Process " << conf.mpiRank << " [main]:   maxFeatures:          " << conf.maxFeatures << std::endl;
		std::cout << "Process " << conf.mpiRank << " [main]:   dataFileName:         " << conf.dataFileName << std::endl;
		std::cout << "Process " << conf.mpiRank << " [main]:   plotFileName:         " << conf.plotFileName << std::endl;
		std::cout << "Process " << conf.mpiRank << " [main]:   imageFileName:        " << conf.imageFileName << std::endl;
		std::cout << "Process " << conf.mpiRank << " [main]:   trNInstances:         " << conf.trNInstances << std::endl;
		std::cout << "Process " << conf.mpiRank << " [main]:   trDataBaseFileName:   " << conf.trDataBaseFileName << std::endl;
		std::cout << "Process " << conf.mpiRank << " [main]:   trNormalize:          " << conf.trNormalize << std::endl;
		std::cout << "Process " << conf.mpiRank << " [main]:   tourSize:             " << conf.tourSize << std::endl;
		std::cout << "Process " << conf.mpiRank << " [main]:   nDevices:             " << conf.nDevices << std::endl;
		std::cout << "Process " << conf.mpiRank << " [main]:   ompThreads:           " << conf.ompThreads << std::endl;
#endif
	}

	// Master with workers
	if (conf.mpiRank == 0 && conf.mpiSize > 1)
	{
#if LOG_ENABLED
		std::cout << "Process " << conf.mpiRank << " [main]: Initializing subpopulations..." << std::endl;
#endif
		subpops = createSubpopulations(&conf);
#if LOG_ENABLED
		std::cout << "Process " << conf.mpiRank << " [main]: Subpopulations initialized." << std::endl;
#endif

		selInstances = getCentroids(&conf);
#if LOG_ENABLED
		std::cout << "Process " << conf.mpiRank << " [main]: Centroids obtained." << std::endl;
		std::cout << "Process " << conf.mpiRank << " [main]: Broadcasting initial centroids to workers..." << std::endl;
#endif
		MPI::COMM_WORLD.Bcast(selInstances, conf.K, MPI::INT, 0);

#if LOG_ENABLED
		std::cout << "Process " << conf.mpiRank << " [main]: Starting genetic algorithm..." << std::endl;
#endif
		agIslands(subpops, NULL, NULL, NULL, &conf);
	}
	else
	{
#if LOG_ENABLED
		std::cout << "Process " << conf.mpiRank << " [main]: Running..." << std::endl;
#endif

		const float *const trDataBase = getDataBase(&conf);
		const float *const transposedTrDataBase = transposeDataBase(trDataBase, &conf);

		// Master works alone
		if (conf.mpiSize == 1)
		{
#if LOG_ENABLED
			std::cout << "Process " << conf.mpiRank << " [main]: Single process mode detected. Creating subpopulations and centroids..." << std::endl;
#endif
			subpops = createSubpopulations(&conf);
			selInstances = getCentroids(&conf);
		}
		// Workers receive subpopulations and centroids from master
		else
		{
#if LOG_ENABLED
			std::cout << "Process " << conf.mpiRank << " [main]: Receiving initial centroids from master..." << std::endl;
#endif
			selInstances = new int[conf.K];
			MPI::COMM_WORLD.Bcast(selInstances, conf.K, MPI::INT, 0);
		}

#if LOG_ENABLED
		std::cout << "Process " << conf.mpiRank << " [main]: Creating devices..." << std::endl;
#endif
		CLDevice *devices = createDevices(trDataBase, selInstances, transposedTrDataBase, &conf);

#if LOG_ENABLED
		std::cout << "Process " << conf.mpiRank << " [main]: Starting genetic algorithm..." << std::endl;
#endif
		agIslands(subpops, devices, trDataBase, selInstances, &conf);

#if LOG_ENABLED
		std::cout << "Process " << conf.mpiRank << " [main]: Deleting devices..." << std::endl;
#endif
		delete[] devices;

#if LOG_ENABLED
		std::cout << "Process " << conf.mpiRank << " [main]: Deleting training database..." << std::endl;
#endif
		delete[] trDataBase;

#if LOG_ENABLED
		std::cout << "Process " << conf.mpiRank << " [main]: Deleting transposed training database..." << std::endl;
#endif
		delete[] transposedTrDataBase;
	}

	if (conf.mpiRank == 0)
	{
#if LOG_ENABLED
		std::cout << "Process " << conf.mpiRank << " [main]: Deleting subpopulations..." << std::endl;
#endif
		delete[] subpops;

#if LOG_ENABLED
		std::cout << "Process " << conf.mpiRank << " [main]: Deleting selected instances..." << std::endl;
#endif
		delete[] selInstances;
	}

#if LOG_ENABLED
	std::cout << "Process " << conf.mpiRank << " [main]: Finalizing MPI environment..." << std::endl;
#endif
	MPI::Finalize();
}
