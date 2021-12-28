FROM buildroot/base:20211120.1925

USER root
WORKDIR /root
ENV HOME /root
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
   apt install -y build-essential ccache ecj fastjar file g++ gawk \
      gettext git java-propose-classpath libelf-dev libncurses5-dev \
      libncursesw5-dev libssl-dev python python2.7-dev python3 unzip wget \
      rsync subversion swig time xsltproc zlib1g-dev python3-dev \
      python-distutils-extra python3-setuptools software-properties-common && \ 
   rm -rf /var/lib/apt/lists/*

USER br-user
WORKDIR /home/br-user
ENV HOME /home/br-user

RUN git clone https://git.openwrt.org/openwrt/openwrt.git && \
   cd openwrt && \
   git checkout v21.02.1 && \
   ./scripts/feeds update -a && \
   ./scripts/feeds install -a && \
   wget https://downloads.openwrt.org/releases/21.02.1/targets/x86/64/#:~:text=02%3A05%202021-,config.buildinfo,-9ec4c70bb26751edbcad32e73579c54f125e8f287bc4bf4dd16a9e751376a12f -O .config && \
   make -j $(nproc) defconfig download

# Suggest running this and volume mapping in the temporary folders??
