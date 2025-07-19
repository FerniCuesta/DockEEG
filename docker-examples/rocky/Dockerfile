FROM rockylinux:8.5

ENV TZ=Europe/Madrid
ENV PATH="/usr/lib64/openmpi/bin:$PATH"

COPY Hpmoon /root/Hpmoon
WORKDIR /root/Hpmoon

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && dnf -y update \
    && dnf clean all \
    && dnf -y autoremove \
    && dnf -y --enablerepo=powertools install gcc-c++ make openmpi opencl-headers ocl-icd \
    && ls /usr/lib64 \
    && ln -s /usr/lib64/libOpenCL.so.1 /usr/lib/libOpenCL.so \
    && make -j N_FEATURES=3600

CMD ["mpirun", "--bind-to", "none", "--allow-run-as-root", "--map-by", "node", "--host", "localhost", "./bin/hpmoon", "-conf", "config.xml"]