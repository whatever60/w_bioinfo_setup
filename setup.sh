get_binary_from_github() {
    local group_name=$1
    local project_name=$2
    local path=$3
    
    release_url="https://github.com/${group_name}/${project_name}/releases/download/${path}"
    filename=$(basename "$path")

    # check if release_url ends with .tar.gz or .zip
    # Download the release archive and extract it
    if [[ $filename == *.zip ]]; then
        folder_name=$(basename "$filename" .zip)
        wget $release_url
        unzip -q $filename
        rm $filename
    elif [[ $filename == *.tar.gz ]]; then
        folder_name=$(basename "$filename" .tar.gz)
        wget -qO- $release_url | tar xz
    elif [[ $filename == *.tar.bz2 ]]; then
        folder_name=$(basename "$filename" .tar.bz2)
        wget -qO- $release_url | tar xj
    else
        echo "Unknown file extension"
        exit 1
    fi

    # Rename the extracted directory to the project name
    mv $folder_name $project_name

    # Add the project's executable directory to the PATH environment variable
    export PATH="$PATH:$PWD/$project_name"
}



export PATH=$PATH:$HOME

# python
wget https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py
export PATH=$PATH:$HOME/.local/bin

pip3 install numpy scipy pandas scikit-learn matplotlib seaborn umap-learn
pip3 install torch lightning torch_geometric jax flax optax diffrax pyro-ppl numpyro blackjax pymc
# for cpu and pytorch 2.0
pip3 install pyg_lib torch_scatter torch_sparse torch_cluster torch_spline_conv -f https://data.pyg.org/whl/torch-2.0.0+cpu.html
# for cpu
pip3 install dgl -f https://data.dgl.ai/wheels/repo.html
pip3 install dglgo -f https://data.dgl.ai/wheels-test/repo.html
pip3 install ipywidgets ipython jupyterlab
pip3 install black rich
pip3 install scanpy scrublet leidenalg MACS3 biopython pygenomeviz pysam checkm-genome multiqc cutadapt aniclustermap


# R utilities
# mkdir -p $HOME/R/x86_64-pc-linux-gnu/4.1
# R --silent --slave --no-save --no-restore -e


# parallel
# installing parallel with apt will make you lose moreutils
# but others say it will work
# sudo yum install parallel
# sudo apt install parallel -y
# (wget -O - pi.dk/3 || lynx -source pi.dk/3 || curl pi.dk/3/ || fetch -o - http://pi.dk/3 ) > install.sh
# sha1sum install.sh | grep 883c667e01eed62f975ad28b6d50e22a
# md5sum install.sh | grep cc21b4c943fd03e93ae1ae49e28573c0
# sha512sum install.sh | grep da012ec113b49a54e705f86d51e784ebced224fdf
# bash install.sh
PARALLEL_VERION=20230222
wget -qO- http://ftp.gnu.org/gnu/parallel/parallel-latest.tar.bz2 | tar xj
cd $HOME/parallel-$PARALLEL_VERION
./configure --prefix $HOME/parallel
make
make install
cd ~
rm -rf $HOME/parallel-$PARALLEL_VERION
export PATH=$PATH:$HOME/parallel/bin

# alignment
# bowtie2, STAR, minimap2
get_binary_from_github "BenLangmead" "bowtie2" "v2.5.1/bowtie2-2.5.1-linux-x86_64.zip"
get_binary_from_github "alexdobin" "STAR" "2.7.10b/STAR_2.7.10b.zip"
get_binary_from_github "lh3" "minimap2" "v2.24/minimap2-2.24_x64-linux.tar.bz2"

# BWA
git clone https://github.com/lh3/bwa.git
cd bwa; make
cd ~
export PATH=$PATH:$HOME/bwa

# HISAT2
git clone https://github.com/DaehwanKimLab/hisat2.git
cd hisat2; make
cd ~
export PATH=$PATH:$HOME/hisat2


# sra-tools
SRATOOLS_VERSION="sratoolkit.3.0.1"
wget -qO- https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz | tar xz
export PATH=$PATH:$HOME/$SRATOOLS_VERSION-ubuntu64/bin


# Sequence data QC and preprocessing
# FastQC
FASTQC_VERSION=0.11.9
wget https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v$FASTQC_VERSION.zip
unzip fastqc_v$FASTQC_VERSION.zip
export PATH=$PATH:$HOME/FastQC
rm fastqc_v$FASTQC_VERSION.zip
# echo "#!/bin/bash" > $HOME/FastQC/fastqc
# echo "java -jar $HOME/FastQC/fastqc.jar \$@" >> $HOME/FastQC/fastqc


# Trimmomatic
TRIMMOMATIC_VERSION=0.39
wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-$TRIMMOMATIC_VERSION.zip
unzip Trimmomatic-$TRIMMOMATIC_VERSION.zip
export PATH=$PATH:$HOME/Trimmomatic-$TRIMMOMATIC_VERSION
echo "#!/bin/bash" > $HOME/Trimmomatic-$TRIMMOMATIC_VERSION/trimmomatic
echo "java -jar $HOME/Trimmomatic-$TRIMMOMATIC_VERSION/trimmomatic-0.39.jar \$@" >> $HOME/Trimmomatic-$TRIMMOMATIC_VERSION/trimmomatic
chmod +x $HOME/Trimmomatic-$TRIMMOMATIC_VERSION/trimmomatic
rm Trimmomatic-$TRIMMOMATIC_VERSION.zip


# fastp
wget http://opengene.org/fastp/fastp
chmod a+x ./fastp


# cufflinks
cufflinks_v=2.2.1
wget -qO- http://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-$cufflinks_v.Linux_x86_64.tar.gz | tar xz
mv cufflinks-$cufflinks_v.Linux_x86_64 cufflinks
export PATH=$PATH:$HOME/cufflinks


# jellyfish
get_binary_from_github "gmarcais" "Jellyfish" "v2.3.0/bin/jellyfish-2.3.0.tar.gz"


# trinity
get_binary_from_github "trinityrnaseq" "trinityrnaseq" "Trinity-v2.15.1/trinityrnaseq-v2.15.1.FULL.tar.gz"


# StringTie
get_binary_from_github "gpertea" "stringtie" "v2.2.1/util/stringtie-2.2.1.Linux_x86_64.tar.gz"


# subread
SUBREAD_V=2.0.3
wget -qO- https://gigenet.dl.sourceforge.net/project/subread/subread-$SUBREAD_V/subread-$SUBREAD_V-Linux-x86_64.tar.gz | tar xz
export PATH=$PATH:$HOME/subread-$SUBREAD_V-Linux-x86_64/bin


# prokka
git clone https://github.com/tseemann/prokka.git $HOME/prokka
$HOME/prokka/bin/prokka --setupdb
export PATH=$PATH:$HOME/prokka/bin
wget -O tbl2asn.gz ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz
gunzip tbl2asn.gz
chmod +x tbl2asn
mv tbl2asn $HOME/prokka/binaries/linux/


# HMMER
HMMER_V=3.3.2
wget -qO- http://eddylab.org/software/hmmer/hmmer-$HMMER_V.tar.gz | tar xz
cd hmmer-$HMMER_V
./configure --prefix $HOME/hmmer
make
make check
make install
(cd easel; make install)
export PATH=$PATH:$HOME/hmmer$HMMER_V/bin
cd ~


# Prodigal
Prodigal_V=2.6.3
mkdir $HOME/prodigal
wget -qO- https://github.com/hyattpd/Prodigal/releases/download/v$Prodigal_V/prodigal.linux > $HOME/prodigal/prodigal
chmod +x $HOME/prodigal/prodigal
export PATH=$PATH:$HOME/prodigal


# pplacer
get_binary_from_github "matsen" "pplacer" "v1.1.alpha19/pplacer-linux-v1.1.alpha19.zip"


# kraken2
kraken_v=2.1.2
wget -qO- https://github.com/DerrickWood/kraken2/archive/refs/tags/v$kraken_v.tar.gz | tar xz
mkdir $HOME/kraken2
cd kraken2-$kraken_v
./install_kraken2.sh $HOME/kraken2
export PATH=$PATH:$HOME/kraken2
rm -rf $HOME/kraken2-$kraken_v


# fastANI
fastANI_v=1.33
get_binary_from_github "ParBLiSS" "FastANI" "v$fastANI_v/fastANI-Linux64-v$fastANI_v.zip"


# Salmon
salmon_v=1.10.0
get_binary_from_github "COMBINE-lab" "salmon" "v$salmon_v/salmon-$salmon_v\_linux_x86_64.tar.gz"


# RSEM
RSEM_v=1.3.3
wget -qO- https://github.com/deweylab/RSEM/archive/refs/tags/v$RSEM_v.tar.gz | tar xz
cd RSEM-$RSEM_v
make
make ebseq
cd ~
export PATH=$PATH:$HOME/RSEM-$RSEM_v


# kallisto
kallisto_v=0.46.1
get_binary_from_github "pachterlab" "kallisto" "v$kallisto_v/kallisto_linux-v$kallisto_v.tar.gz"


# ruby
ruby_v=3.2.1
wget -qO- https://cache.ruby-lang.org/pub/ruby/$(echo $ruby_v | cut -d "." -f 1,2)/ruby-$ruby_v.tar.gz | tar xz
cd ruby-$ruby_v
./configure --prefix $HOME/ruby
make 
make install
cd ~
rm -rf ruby-$ruby_v
export PATH=$PATH:$HOME/ruby/bin


# KofamKOALA (requires HMMER, ruby, parallel)
mkdir -p ~/kofamscan
mkdir -p ~/kofamscan/db
mkdir -p ~/kofamscan/bin
cd ~/kofamscan/db
wget ftp://ftp.genome.jp/pub/db/kofam/ko_list.gz 
wget -qO- ftp://ftp.genome.jp/pub/db/kofam/profiles.tar.gz | tar xz
gunzip ko_list.gz
cd ~/kofamscan/bin
kofam_scan_v=1.3.0
wget -qO- https://www.genome.jp/ftp/tools/kofam_scan/kofam_scan-$kofam_scan_v.tar.gz | tar xz
echo "profile: $HOME/kofamscan/db/profiles" > config.yml
echo "ko_list: $HOME/kofamscan/db/ko_list" >> config.yml
echo "hmmsearch: $(which hmmsearch)" >> config.yml
echo "parallel: $(which parallel)" >> config.yml
echo "cpu: 8" >> config.yml
cd ~
export PATH=$PATH:$HOME/kofamscan/bin/kofam_scan-$kofam_scan_v


# PWMscan
# https://github.com/wassermanlab/JASPAR-UCSC-tracks
wget -qO- https://sourceforge.net/projects/pwmscan/files/pwmscan/rel-1.1.9/pwmscan.1.1.9.tar.gz | tar xz
cd pwmscan
mkdir -p bin
make clean && make cleanbin
make && make install
cd ~
export PATH=$PATH:$HOME/pwmscan/bin


# Protein
# HH-suite
wget -qO- https://github.com/soedinglab/hh-suite/releases/download/v3.3.0/hhsuite-3.3.0-SSE2-Linux.tar.gz | tar xz
export PATH=$PATH:$(pwd)/bin:$(pwd)/scripts

# TM-align
mkdir -p ~/TM-align
cd ~/TM-align
wget https://zhanggroup.org/TM-align/TMalign.cpp
wget https://zhanggroup.org/TM-align/readme.c++.txt
g++ -static -O3 -ffast-math -lm -o TMalign TMalign.cpp
cd ~
export PATH=$PATH:$HOME/TM-align

# US-align
mkdir -p ~/US-align
cd ~/US-align
wget https://zhanggroup.org/US-align/bin/module/USalign.cpp
g++ -static -O3 -ffast-math -o USalign USalign.cpp
cd ~
export PATH=$PATH:$HOME/US-align

# foldseek
wget -qO- https://mmseqs.com/foldseek/foldseek-linux-avx2.tar.gz | tar xz
export PATH=$PATH:$(pwd)/foldseek/bin/

# MMseqs2
wget -qO- https://mmseqs.com/latest/mmseqs-linux-avx2.tar.gz | tar xz
export PATH=$(pwd)/mmseqs/bin/:$PATH


# QUAST
quast_v=5.2.0
wget -qO- https://github.com/ablab/quast/releases/download/quast_$quast_v/quast-$quast_v.tar.gz | tar xz
cd $HOME/quast-$quast_v
python2 setup.py install_full
cd ~
