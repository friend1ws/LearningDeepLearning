#! /usr/bin/env bash

mkdir bin
mkdir db
mkdir script
mkdir data

sudo apt-get update -y
sudo apt-get install python-pip -y
sudo apt-get install zlib1g-dev -y
sudo apt-get install libbz2-dev -y
sudo apt-get install liblzma-dev -y
sudo apt-get install bedtools -y
pip install annot_utils

WORKDIR=`pwd`

# install htslib
cd bin
wget https://github.com/samtools/htslib/releases/download/1.8/htslib-1.8.tar.bz2
tar jxvf htslib-1.8.tar.bz2 
cd htslib-1.8/
sudo ./configure 
sudo make
sudo make install
cd $WORKDIR

# install maxentscan
cd bin
wget http://genes.mit.edu/burgelab/maxent/download/fordownload.tar.gz
tar zxvf fordownload.tar.gz
mv fordownload maxent
export PATH=~/bin/maxent:$PATH
cd $WORKDIR

# prepare data
cd db
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_28/GRCh38.primary_assembly.genome.fa.gz
gunzip GRCh38.primary_assembly.genome.fa.gz
bash prep_exon.sh
cd $WORKDIR


