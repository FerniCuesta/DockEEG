# Hpmoon

Hpmoon is a parallel and distributed multi-objective genetic algorithm to EEG classification. The evolutionary procedure corresponds to an island-based model whose subpopulations are distributed among the nodes of a cluster. The application is able to parallelize the evaluation of the individuals using all the CPU-GPU devices simultaneously, which provides up to 4 levels of parallelism.

## Requirements

Hpmoon requires a GCC compiler and OpenCL 1.2 compliant CPU-GPU devices. It also depends on the following APIs and libraries:

* [OpenMPI](https://www.open-mpi.org/doc/current/).
* [AMD APP SDK v2.9.1](http://developer.amd.com/wordpress/media/2012/10/AMD_APP_SDK_Release_Notes_Developer2.pdf) or later.
* [Doxygen](https://www.doxygen.nl/index.html) if you want to generate documentation.

## Documentation

Hpmoon is fully documented in its [Github Pages](https://efficomp.github.io/Hpmoon/). In addition, the `Makefile` file contains a rule to generate [Doxygen](https://www.doxygen.nl/index.html) documentation in the `docs/html` folder.

## Usage

The `docs` folder contains the file `user_guide.pdf` with the instructions necessary to use the program. You can also display help by running the program with the `-h` option.

## Publications

#### Journals

1. J.J. Escobar, J. Ortega, A.F. Díaz, J. González, and M. Damas. *Energy-aware Load Balancing of Parallel Evolutionary Algorithms with Heavy Fitness Functions in Heterogeneous CPU-GPU Architectures*. In: **Concurrency and Computation: Practice and Experience** 31.6 (2019), e4688. DOI: [10.1002/cpe.4688](https://doi.org/10.1002/cpe.4688).
1. J.J. Escobar, J. Ortega, A.F. Díaz, J. González, and M. Damas. *Time-energy Analysis of Multi-level Parallelism in Heterogeneous Clusters: The Case of EEG Classification in BCI Tasks*. In: **The Journal of Supercomputing** 75.7 (2019), pp. 3397-3425. DOI: [10.1007/s11227-019-02908-4](https://doi.org/10.1007/s11227-019-02908-4).
1. J.J. Escobar, J. Ortega, A.F. Díaz, J. González, and M. Damas. *A Power-Performance Perspective to Multiobjective Electroencephalogram Feature Selection on Heterogeneous Parallel Platforms*. In: **Journal of Computational Biology** 25.8 (2018), pp. 882-893. DOI: [10.1089/cmb.2018.0080](https://doi.org/10.1089/cmb.2018.0080).
1. J.J. Escobar, J. Ortega, J. González, M. Damas, and A.F. Díaz. *Parallel High-dimensional Multiobjective Feature Selection for EEG Classification with Dynamic Workload Balancing on CPU-GPU*. In: **Cluster Computing** 20.3 (2017), pp. 1881-1897. DOI: [10.1007/s10586-017-0980-7](https://doi.org/10.1007/s10586-017-0980-7).

#### Conferences

1. J.J. Escobar, J. Ortega, A.F. Díaz, J. González, and M. Damas. *A Parallel and Distributed Multi-population GA with Asynchronous Migrations: Energy-time Analysis for Heterogeneous Systems*. In: **Proceedings of the Annual Conference on Genetic and Evolutionary Computation. GECCO'2020**. Cancun, Mexico: ACM, July 2020, pp. 211-212. DOI: [10.1145/3377929.3389908](https://doi.org/10.1145/3377929.3389908).
1. J.J. Escobar, J. Ortega, A.F. Díaz, J. González, and M. Damas. *Energy-time Analysis of Heterogeneous Clusters for EEG Classification*. In: **Proceedings of the 3rd International Workshop on Power-Aware Computing. PACO'2019**. Magdeburg, Germany: Zenodo, November 2019, pp. 7-9. DOI: [10.5281/zenodo.5572831](https://doi.org/10.5281/zenodo.5572831).
1. J.J. Escobar, J. Ortega, A.F. Díaz, J. González, and M. Damas. *Multi-objective Feature Selection for EEG Classification with Multi-Level Parallelism on Heterogeneous CPU-GPU Clusters*. In: **Proceedings of the Annual Conference on Genetic and Evolutionary Computation. GECCO'2018**. Kyoto, Japan: ACM, July 2018, pp. 1862-1869. DOI: [10.1145/3205651.3208239](https://doi.org/10.1145/3205651.3208239).
1. J.J. Escobar, J. Ortega, A.F. Díaz, J. González, and M. Damas. *Speedup and Energy Analysis of EEG Classification for BCI Tasks on CPU-GPU Clusters*. In: **Proceedings of the 6th International Workshop on Parallelism in Bioinformatics. PBIO'2018**. Barcelona, Spain: ACM, September 2018, pp. 33-43. DOI: [10.1145/3235830.3235834](https://doi.org/10.1145/3235830.3235834).
1. J.J. Escobar, J. Ortega, A.F. Díaz, J. González, and M. Damas. *Power-Performance Evaluation of Parallel Multi-objective EEG Feature Selection on CPU-GPU Platforms*. In: **Proceedings of the 5th International Workshop on Parallelism in Bioinformatics. PBIO'2017**. Helsinki, Finland: Springer, August 2017, pp. 580-590. DOI: [10.1007/978-3-319-65482-9_43](https://doi.org/10.1007/978-3-319-65482-9_43).
1. J.J. Escobar, J. Ortega, J. González, M. Damas, and B. Prieto. *Issues on GPU Parallel Implementation of Evolutionary High-Dimensional Multi-objective Feature Selection*. In: **Proceedings of the 20th European Conference on Applications of Evolutionary Computation, Part I. EVOSTAR'2017**. Amsterdam, The Netherlands: Springer, April 2017, pp. 773-788. DOI: [10.1007/978-3-319-55849-3_50](https://doi.org/10.1007/978-3-319-55849-3_50).
1. J. Ortega, J.J. Escobar, A.F. Díaz, J. González, and M. Damas. *Energy-aware Scheduling for Parallel Evolutionary Algorithms in Heterogeneous Architectures*. In: **Proceedings of the 2nd International Workshop on Power-Aware Computing. PACO'2017**. Schloss Ringberg, Germany: Zenodo, July 2017, pp. 27-32. DOI: [10.5281/zenodo.814806](https://doi.org/10.5281/zenodo.814806).
1. J.J. Escobar, J. Ortega, J. González, and M. Damas. *Assessing Parallel Heterogeneous Computer Architectures for Multiobjective Feature Selection on EEG Classification*. In: **Proceedings of the 4th International Conference on Bioinformatics and Biomedical Engineering. IWBBIO'2016**. Granada, Spain: Springer, April 2016, pp. 277-289. DOI: [10.1007/978-3-319-31744-1_25](https://doi.org/10.1007/978-3-319-31744-1_25).
1. J.J. Escobar, J. Ortega, J. González, and M. Damas. *Improving Memory Accesses for Heterogeneous Parallel Multi-objective Feature Selection on EEG Classification*. In: **Proceedings of the 4th International Workshop on Parallelism in Bioinformatics. PBIO'2016**. Grenoble, France: Springer, August 2016, pp. 372-383. DOI: [10.1007/978-3-319-58943-5_30](https://doi.org/10.1007/978-3-319-58943-5_30).

## Funding

This work has been funded by:

* Spanish *Ministerio de Economía y Competitividad* under grants number TIN2012-32039 and TIN2015-67020-P.
* Spanish [*Ministerio de Ciencia, Innovación y Universidades*](https://www.ciencia.gob.es/) under grant number PGC2018-098813-B-C31.
* [*European Regional Development Fund (ERDF)*](https://ec.europa.eu/regional_policy/en/funding/erdf/).

<div style="text-align: right">
  <img src="https://raw.githubusercontent.com/efficomp/Hpmoon/main/docs/logos/mineco.png" height="60">
  <img src="https://raw.githubusercontent.com/efficomp/Hpmoon/main/docs/logos/miciu.jpg" height="60">
  <img src="https://raw.githubusercontent.com/efficomp/Hpmoon/main/docs/logos/erdf.png" height="60">
</div>

## License

[GNU GPLv3](https://www.gnu.org/licenses/gpl-3.0.md).

## Copyright

Hpmoon © 2015 [EFFICOMP](https://efficomp.ugr.es/).
