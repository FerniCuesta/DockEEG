FROM ubuntu:22.04

LABEL license="This file is subject to the terms and conditions defined in file 'LICENSE', which is part of Hpmoon repository."

LABEL funding="This work has been funded by: \
    Spanish 'Ministerio de Economía y Competitividad' under grants number TIN2012-32039 and TIN2015-67020-P. \
    Spanish 'Ministerio de Ciencia, Innovación y Universidades' under grant number PGC2018-098813-B-C31. \
    European Regional Development Fund (ERDF)."

LABEL file="Dockerfile"
LABEL author="Juan José Escobar Pérez"
LABEL date="20/04/2022"
LABEL brief="Dockerfile that build a multi-arch image of Hpmoon"
LABEL copyright="Hpmoon (c) 2015 EFFICOMP"

ENV TZ=Europe/Madrid
ENV DEBIAN_FRONTEND=noninteractive

COPY Hpmoon /root/Hpmoon
WORKDIR /root/Hpmoon

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y dist-upgrade \
    && apt-get -y autoremove \
    && apt-get -y install g++ make libopenmpi-dev ocl-icd-opencl-dev python3 python3-pip \
    && pip install pyserial rx pandas \
    && rm -rf /var/lib/apt/lists/* \
    && make -j N_FEATURES=3600

ENTRYPOINT ["mpirun", "--bind-to", "none", "--allow-run-as-root", "--map-by", "node", "--host", "localhost", "./bin/hpmoon", "-conf", "config.xml"]

# CMD ["sh", "-c", "python3 script.py && rsync -e ssh *.tar jjescobar@hpmoon.ugr.es:/home/jjescobar"]