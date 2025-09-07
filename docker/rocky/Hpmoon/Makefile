## This file is subject to the terms and conditions defined in
# file 'LICENSE', which is part of Hpmoon repository.
# 
# This work has been funded by:
# 
# Spanish 'Ministerio de Economía y Competitividad' under grants number TIN2012-32039 and TIN2015-67020-P.\n
# Spanish 'Ministerio de Ciencia, Innovación y Universidades' under grant number PGC2018-098813-B-C31.\n
# European Regional Development Fund (ERDF).
#
# @file Makefile
# @author Juan José Escobar Pérez
# @date 15/06/2015
# @brief File with the necessary rules to compile the project. Also, documentation is generated
# @copyright Hpmoon (c) 2015 EFFICOMP

SRC = src
INC = include
OBJ = obj
BIN = bin
DOC = docs
GNUPLOT = gnuplot

COMP ?= mpic++
CPPFLAGS = -std=c++0x -c -Iinclude
OPT = -O2 -funroll-loops
OMP = -fopenmp

NFEATURES = -D N_FEATURES=$(N_FEATURES)

OBJECTS = $(OBJ)/tinyxml2.o $(OBJ)/cmdParser.o $(OBJ)/config.o $(OBJ)/clUtils.o $(OBJ)/bd.o $(OBJ)/ag.o $(OBJ)/evaluation.o $(OBJ)/individual.o $(OBJ)/zitzler.o $(OBJ)/main.o

# ************ Targets ************

all: $(BIN)/hpmoon

# ************ Documentation ************

documentation:
	@mkdir -p $(DOC)/html
	@doxygen $(DOC)/Doxyfile
	@printf "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">\n" > $(DOC)/index.html
	@printf "<html>\n <head>\n  <meta http-equiv=Refresh content=\"0;url=html/index.html\">\n </head>\n</html>" >> $(DOC)/index.html


# ************ Compilation of modules ************

$(OBJ)/tinyxml2.o: $(SRC)/tinyxml2.cpp $(INC)/tinyxml2.h
	@mkdir -p $(OBJ)
	$(COMP) $(CPPFLAGS) $(OPT) $(SRC)/tinyxml2.cpp -o $(OBJ)/tinyxml2.o

$(OBJ)/cmdParser.o: $(SRC)/cmdParser.cpp $(INC)/cmdParser.h
	$(COMP) $(CPPFLAGS) $(OPT) $(SRC)/cmdParser.cpp -o $(OBJ)/cmdParser.o
$(OBJ)/config.o: $(SRC)/config.cpp $(INC)/config.h
	$(COMP) $(CPPFLAGS) $(NFEATURES) $(OPT) $(SRC)/config.cpp -o $(OBJ)/config.o
$(OBJ)/clUtils.o: $(SRC)/clUtils.cpp $(INC)/clUtils.h
	$(COMP) $(CPPFLAGS) $(NFEATURES) $(OPT) $(SRC)/clUtils.cpp -o $(OBJ)/clUtils.o
$(OBJ)/bd.o: $(SRC)/bd.cpp $(INC)/bd.h
	$(COMP) $(CPPFLAGS) $(OPT) $(SRC)/bd.cpp -o $(OBJ)/bd.o
$(OBJ)/ag.o: $(SRC)/ag.cpp $(INC)/ag.h
	$(COMP) $(CPPFLAGS) $(NFEATURES) $(OPT) $(OMP) $(SRC)/ag.cpp -o $(OBJ)/ag.o
$(OBJ)/evaluation.o: $(SRC)/evaluation.cpp $(INC)/evaluation.h
	$(COMP) $(CPPFLAGS) $(NFEATURES) $(OPT) $(OMP) $(SRC)/evaluation.cpp -o $(OBJ)/evaluation.o
$(OBJ)/individual.o: $(SRC)/individual.cpp $(INC)/individual.h
	$(COMP) $(CPPFLAGS) $(NFEATURES) $(OPT) $(SRC)/individual.cpp -o $(OBJ)/individual.o
$(OBJ)/zitzler.o: $(SRC)/zitzler.cpp $(INC)/zitzler.h
	$(COMP) $(CPPFLAGS) $(NFEATURES) $(OPT) $(SRC)/zitzler.cpp -o $(OBJ)/zitzler.o

$(OBJ)/main.o: $(SRC)/main.cpp
	$(COMP) $(CPPFLAGS) $(NFEATURES) $(OPT) $(SRC)/main.cpp -o $(OBJ)/main.o

# ************ Linking and creating executable ************

$(BIN)/hpmoon: $(OBJECTS)
	@mkdir -p $(BIN) $(GNUPLOT)
	$(COMP) $(OBJECTS) -o $(BIN)/hpmoon -lOpenCL $(OMP)

# ************ Cleaning ***************

clean:
	@echo "Partial cleaning..."
	@printf "\t- Binary files\n"
	@printf "\t- .o files\n"
	@printf "\t- ~ files\n"
	@\rm -rf $(OBJ) $(BIN) *~

eraseAll: clean
	@echo "Additionally..."
	@printf "\t- gnuplot files\n"
	@printf "\t- Documentation files\n"
	@\rm -rf $(GNUPLOT) $(DOC)/html $(DOC)/index.html
