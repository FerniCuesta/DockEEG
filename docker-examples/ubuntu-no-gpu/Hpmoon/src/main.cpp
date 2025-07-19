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

/**
 * @brief Main program
 * @param argc The number of arguments of the program
 * @param argv Arguments of the program
 */
int main(const int argc, const char **argv)
{
	std::time_t now = std::time(nullptr);

	std::cout << "Process [main]: Execution started: " << std::ctime(&now) << std::endl;
	std::cout << "Process [main]: Arguments: ";
	for (int i = 0; i < argc; ++i)
		std::cout << argv[i] << " ";
	std::cout << std::endl;

	std::cout << "Process [main]: Initializing MPI environment..." << std::endl;
	MPI::Init_thread(MPI_THREAD_MULTIPLE);

	std::cout << "Process [main]: Reading configuration..." << std::endl;
	Config conf(argc, argv);

	std::cout << "Process " << conf.mpiRank << " [main]: MPI Rank: " << conf.mpiRank << ", MPI Size: " << conf.mpiSize << std::endl;

	Individual *subpops;
	int *selInstances;
	srand((uint)time(NULL) + conf.mpiRank);

	if (conf.mpiRank == 0)
	{
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
	}

	if (conf.mpiRank == 0 && conf.mpiSize > 1)
	{
		std::cout << "Process " << conf.mpiRank << " [main]: Initializing subpopulations..." << std::endl;
		subpops = createSubpopulations(&conf);
		std::cout << "Process " << conf.mpiRank << " [main]: Subpopulations initialized." << std::endl;

		selInstances = getCentroids(&conf);
		std::cout << "Process " << conf.mpiRank << " [main]: Centroids obtained." << std::endl;

		std::cout << "Process " << conf.mpiRank << " [main]: Broadcasting initial centroids to workers..." << std::endl;
		MPI::COMM_WORLD.Bcast(selInstances, conf.K, MPI::INT, 0);

		std::cout << "Process " << conf.mpiRank << " [main]: Starting genetic algorithm..." << std::endl;
		agIslands(subpops, NULL, NULL, NULL, &conf);
	}
	else
	{
		std::cout << "Process " << conf.mpiRank << " [main]: Running..." << std::endl;

		const float *const trDataBase = getDataBase(&conf);
		const float *const transposedTrDataBase = transposeDataBase(trDataBase, &conf);

		if (conf.mpiSize == 1)
		{
			std::cout << "Process " << conf.mpiRank << " [main]: Single process mode detected. Creating subpopulations and centroids..." << std::endl;
			subpops = createSubpopulations(&conf);
			selInstances = getCentroids(&conf);
		}
		else
		{
			std::cout << "Process " << conf.mpiRank << " [main]: Receiving initial centroids from master..." << std::endl;
			selInstances = new int[conf.K];
			MPI::COMM_WORLD.Bcast(selInstances, conf.K, MPI::INT, 0);
		}

		std::cout << "Process " << conf.mpiRank << " [main]: Creating devices..." << std::endl;
		CLDevice *devices = createDevices(trDataBase, selInstances, transposedTrDataBase, &conf);

		std::cout << "Process " << conf.mpiRank << " [main]: Starting genetic algorithm..." << std::endl;
		agIslands(subpops, devices, trDataBase, selInstances, &conf);

		std::cout << "Process " << conf.mpiRank << " [main]: Deleting devices..." << std::endl;
		delete[] devices;

		std::cout << "Process " << conf.mpiRank << " [main]: Deleting training database..." << std::endl;
		delete[] trDataBase;

		std::cout << "Process " << conf.mpiRank << " [main]: Deleting transposed training database..." << std::endl;
		delete[] transposedTrDataBase;
	}

	std::cout << "Process " << conf.mpiRank << " [main]: Deleting subpopulations..." << std::endl;
	delete[] subpops;

	std::cout << "Process " << conf.mpiRank << " [main]: Deleting selected instances..." << std::endl;
	delete[] selInstances;

	std::cout << "Process " << conf.mpiRank << " [main]: Finalizing MPI environment..." << std::endl;
	MPI::Finalize();
}
