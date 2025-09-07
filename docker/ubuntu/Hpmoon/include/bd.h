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
 * @file bd.h
 * @author Juan José Escobar Pérez
 * @date 15/06/2015
 * @brief Function declarations of the database reader
 * @copyright Hpmoon (c) 2015 EFFICOMP
 */

#ifndef BD_H
#define BD_H

/********************************* Includes *******************************/

#include "config.h" // 'Config' datatype

/******************************** Constants *******************************/

const char *const BD_ERROR_FILE_OPEN = "Error: Could not open the database file";
const char *const BD_ERROR_FILE_EMPTY = "Error: The database file is empty";
const char *const BD_ERROR_ROW_UNEQUAL = "Error: Different number of columns in the row";
const char *const BD_ERROR_DIMENSIONS_MIN = "Error: The database dimensions must be 4x4 or higher";
const char *const BD_ERROR_INSTANCES_RANGE = "Error: The number of instances must be between 4 and";
const char *const BD_ERROR_COLUMNS_UNEQUAL = "Error: The number of columns in the database must match the specified \'N_FEATURES\' parameter when compiling the program";


/********************************* Methods ********************************/

/**
 * @brief Reads and normalizes a database if it is required
 * @param conf The structure with all configuration parameters
 * @return The database which will contain the instances
 */
float* getDataBase(const Config *const conf);


/**
 * @brief The database is transposed
 * @param dataBase Database to be transposed
 * @param conf The structure with all configuration parameters
 * @return The database already transposed
 */
float* transposeDataBase(const float *const dataBase, const Config *const conf);

#endif
