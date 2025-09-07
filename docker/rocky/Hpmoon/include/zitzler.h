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
 * @file zitzler.h
 * @author Juan José Escobar Pérez
 * @date 26/02/2018
 * @brief Function declarations of the hypervolume metric calculation procedure
 * @copyright Hpmoon (c) 2015 EFFICOMP
 */

#ifndef ZITZLER_H
#define ZITZLER_H

/********************************* Methods ********************************/

/**
 * @brief Gets the hypervolume measure for the specified set of points
 * @param points The set of points
 * @param nPoints The number of points
 * @param nObjectives The number of objectives
 * @return The hypervolume value
 */
double GetHypervolume(double **points, const int nPoints, const int nObjectives);

#endif
