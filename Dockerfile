FROM ubuntu:14.04
MAINTAINER Robert Syme <robsyme@gmail.com>

RUN sed 's/main$/main universe/' -i /etc/apt/sources.list
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq
RUN apt-get upgrade -qqy

# Install the basics
RUN apt-get install -qqy wget unzip build-essential zlib1g-dev libgsl0-dev

# Install cortex
ADD http://downloads.sourceforge.net/project/cortexassembler/cortex_var/latest/CORTEX_release_v1.0.5.21.tgz /opt/cortex_var/
RUN cd /opt/cortex_var && \
    tar -xzvf *.tgz && \
    ln -s CORTEX_release_v1.0.5.21 current && \
    cd current && \
    bash install.sh

WORKDIR /opt/cortex_var/current
ADD compile.sh /opt/cortex_var/current/
RUN bash compile.sh && rm compile.sh

# Install VCFTools
RUN mkdir -p /opt/vcftools
ADD http://downloads.sourceforge.net/project/vcftools/vcftools_0.1.12b.tar.gz /opt/vcftools/
RUN cd /opt/vcftools && \
    tar -xzvf vcftools*.tar.gz && \
    ln -s vcftools_0.1.12b current && \
    cd current && \
    make

# Install Stampy    
RUN apt-get install -qqy r-base python-dev

RUN mkdir -p /opt/stampy
ADD http://www.well.ox.ac.uk/bioinformatics/Software/Stampy-latest.tgz /opt/stampy/
RUN cd /opt/stampy && \
    tar -xzvf Stampy-latest.tgz && \
    ln -s stampy-1.0.23 current

ADD Stampy_Makefile /opt/stampy/current/makefile
RUN cd /opt/stampy/current && \
    make

ENV PERL5LIB /opt/cortex_var/current/scripts/analyse_variants/bioinf-perl/lib:/opt/cortex_var/current/scripts/calling
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/stampy/current:/opt/cortex_var/current/bin:/opt/cortex_var/current/scripts/analyse_variants/needleman_wunsch


