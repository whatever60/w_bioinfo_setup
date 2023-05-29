function echo_blue {
    echo -e "\033[34m===== $1 =====\033[0m"
}

get_binary_from_github() {
    local group_name=$1
    local project_name=$2
    local path=$3
    # folder_name is an optional keyword argument --folder_name
    local folder_name=$4
    
    release_url="https://github.com/${group_name}/${project_name}/releases/download/${path}"
    filename=$(basename "$path")

    # check if release_url ends with .tar.gz or .zip
    # Download the release archive and extract it
    if [[ $filename == *.zip ]]; then
        # if folder_name is not provided, use the filename without extension
        if [[ -z $folder_name ]]; then
            folder_name=$(basename "$filename" .zip)
        fi
        wget -q $release_url
        unzip -q $filename
        rm $filename
    elif [[ $filename == *.tar.gz ]]; then
        if [[ -z $folder_name ]]; then
            folder_name=$(basename "$filename" .tar.gz)
        fi
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


start_dir=$(pwd)

SOFTWARE_PATH=$HOME/software
mkdir -p $SOFTWARE_PATH
cd $SOFTWARE_PATH

export PATH=$PATH:$SOFTWARE_PATH

# python
echo_blue "Installing pip3..."
wget -q https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py 2>/dev/null >/dev/null
export PATH=$PATH:$HOME/.local/bin


echo_blue "Installing Python packages..."
pip3 install numpy \
  scipy \
  pandas \
  scikit-learn \
  matplotlib \
  seaborn \
  umap-learn 2>/dev/null >/dev/null

pip3 install torch \
  lightning \
  torch_geometric \
  jax \
  flax \
  optax \
  diffrax \
  pyro-ppl \
  numpyro \
  blackjax \
  pymc 2>/dev/null >/dev/null

pip3 install pyg_lib \
  torch_scatter \
  torch_sparse \
  torch_cluster \
  torch_spline_conv \
  -f https://data.pyg.org/whl/torch-2.0.0+cpu.html 2>/dev/null >/dev/null

pip3 install dgl \
  -f https://data.dgl.ai/wheels/repo.html 2>/dev/null >/dev/null

pip3 install dglgo \
  -f https://data.dgl.ai/wheels-test/repo.html 2>/dev/null >/dev/null

pip3 install ipywidgets \
  ipython \
  jupyterlab 2>/dev/null >/dev/null

pip3 install black \
  rich 2>/dev/null >/dev/null

pip3 install scanpy \
  scrublet \
  leidenalg \
  MACS3 \
  biopython \
  pygenomeviz \
  pysam \
  checkm-genome \
  multiqc \
  cutadapt \
  aniclustermap \
  pathlib \
  pathlib2 \
  bioinfokit \
  pyBigWig \
  igv_notebook 2>/dev/null >/dev/null


echo_blue "Installing R packages..."
# R utilities
mkdir -p $HOME/R/x86_64-pc-linux-gnu/4.1
mkdir -p $HOME/R/x86_64-pc-linux-gnu/4.2
# R --silent --slave --no-save --no-restore -e
Rscript --silent --slave --no-save --no-restore -e 'install.packages("BiocManager", lib="~/R/x86_64-pc-linux-gnu/4.1")' 2>/dev/null
Rscript --silent --slave --no-save --no-restore $start_dir/r_packages.r 2>/dev/null


# ====================
echo_blue "Installing JAVA"
# JAVA
sudo wget -qO- https://download.oracle.com/java/20/latest/jdk-20_linux-x64_bin.tar.gz | sudo tar xz
JAVA_HOME=$SOFTWARE_PATH/jdk-20.0.1
PATH=$JAVA_HOME/bin:$PATH
cd $SOFTWARE_PATH



# ====================
echo_blue "Installing parallel..."
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
PARALLEL_VERION=20230522
wget -qO- http://ftp.gnu.org/gnu/parallel/parallel-latest.tar.bz2 | tar xj
cd $SOFTWARE_PATH/parallel-$PARALLEL_VERION
./configure --prefix $SOFTWARE_PATH/parallel 2>/dev/null >/dev/null
make 2>/dev/null >/dev/null
make install 2>/dev/null >/dev/null
cd $SOFTWARE_PATH
rm -rf $SOFTWARE_PATH/parallel-$PARALLEL_VERION
export PATH=$PATH:$SOFTWARE_PATH/parallel/bin

# ====================
echo_blue "Installing bowtie2, STAR, minimap2, bwa, HISAT2..."
# bowtie2, STAR, minimap2
get_binary_from_github "BenLangmead" "bowtie2" "v2.5.1/bowtie2-2.5.1-linux-x86_64.zip"
get_binary_from_github "alexdobin" "STAR" "2.7.10b/STAR_2.7.10b.zip"
get_binary_from_github "lh3" "minimap2" "v2.24/minimap2-2.24_x64-linux.tar.bz2"

# BWA
git clone https://github.com/lh3/bwa.git 2>/dev/null
cd bwa; make 2>/dev/null >/dev/null
cd $SOFTWARE_PATH
export PATH=$PATH:$SOFTWARE_PATH/bwa

# HISAT2
git clone https://github.com/DaehwanKimLab/hisat2.git 2>/dev/null
cd hisat2; make 2>/dev/null >/dev/null
cd $SOFTWARE_PATH
export PATH=$PATH:$SOFTWARE_PATH/hisat2


# ====================
echo_blue "Installing sra-tools..."
# sra-tools
SRATOOLS_VERSION="sratoolkit.3.0.2"
wget -qO- https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.0.2/sratoolkit.3.0.2-ubuntu64.tar.gz | tar xz
mv $SRATOOLS_VERSION-ubuntu64 sratoolkit
export PATH=$PATH:$SOFTWARE_PATH/sratoolkit/bin

# ====================
echo_blue "Installing htslib, samtools, bcftools, ucsc toolkit..."
# htslib
wget -qO- https://github.com/samtools/htslib/releases/download/1.17/htslib-1.17.tar.bz2 | tar xj
mv htslib-1.17 htslib
cd htslib
./configure --prefix $SOFTWARE_PATH/htslib 2>/dev/null >/dev/null
make 2>/dev/null >/dev/null
make install 2>/dev/null >/dev/null
cd $SOFTWARE_PATH
export PATH=$PATH:$SOFTWARE_PATH/htslib/bin

# samtools
wget -qO- https://github.com/samtools/samtools/releases/download/1.17/samtools-1.17.tar.bz2 | tar xj
mv samtools-1.17 samtools
cd samtools
./configure --prefix $SOFTWARE_PATH/samtools 2>/dev/null >/dev/null
make 2>/dev/null >/dev/null
make install 2>/dev/null >/dev/null
cd $SOFTWARE_PATH
export PATH=$PATH:$SOFTWARE_PATH/samtools/bin

# bcftools
wget -qO- https://github.com/samtools/bcftools/releases/download/1.17/bcftools-1.17.tar.bz2 | tar xj
mv bcftools-1.17 bcftools
cd bcftools
./configure --prefix $SOFTWARE_PATH/bcftools 2>/dev/null >/dev/null
make 2>/dev/null >/dev/null
make install 2>/dev/null >/dev/null
cd $SOFTWARE_PATH
export PATH=$PATH:$SOFTWARE_PATH/bcftools/bin

# UCSC utilities
mkdir -p $SOFTWARE_PATH/ucsc
rsync -aqP rsync://hgdownload.soe.ucsc.edu/genome/admin/exe/linux.x86_64/ $SOFTWARE_PATH/ucsc
chmod a+x $SOFTWARE_PATH/ucsc/bedToBigBed
cd $SOFTWARE_PATH
export PATH=$PATH:$SOFTWARE_PATH/ucsc


# ====================
echo_blue "Installing FastQC, Trimmomatic, fastp..."
# FastQC
FASTQC_VERSION=0.12.1
wget -q https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v$FASTQC_VERSION.zip
unzip -q fastqc_v$FASTQC_VERSION.zip
export PATH=$PATH:$SOFTWARE_PATH/FastQC
rm fastqc_v$FASTQC_VERSION.zip
chmod 777 $SOFTWARE_PATH/FastQC/fastqc
# echo "#!/bin/bash" > $HOME/FastQC/fastqc
# echo "java -jar $HOME/FastQC/fastqc.jar \$@" >> $HOME/FastQC/fastqc


# Trimmomatic
TRIMMOMATIC_VERSION=0.39
wget -q http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/Trimmomatic-$TRIMMOMATIC_VERSION.zip
unzip -q Trimmomatic-$TRIMMOMATIC_VERSION.zip
rm Trimmomatic-$TRIMMOMATIC_VERSION.zip
mv Trimmomatic-$TRIMMOMATIC_VERSION Trimmomatic
# https://unix.stackexchange.com/questions/3051/how-to-echo-a-bang
echo '#!/bin/bash' > Trimmomatic/trimmomatic  # must be single quotes
echo "java -jar Trimmomatic/trimmomatic-0.39.jar \$@" >> Trimmomatic/trimmomatic
chmod +x $SOFTWARE_PATH/Trimmomatic/trimmomatic
export PATH=$PATH:$SOFTWARE_PATH/Trimmomatic

# fastp
wget -q http://opengene.org/fastp/fastp
chmod a+x ./fastp


# ====================
echo_blue "Installing cufflinks, salmon, jellyfish, trinity, StringTie, subread, RSEM, kallisto..."
# cufflinks
cufflinks_v=2.2.1
wget -qO- http://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-$cufflinks_v.Linux_x86_64.tar.gz | tar xz
mv cufflinks-$cufflinks_v.Linux_x86_64 cufflinks
export PATH=$PATH:$SOFTWARE_PATH/cufflinks

# jellyfish
get_binary_from_github "gmarcais" "Jellyfish" "v2.3.0/jellyfish-2.3.0.tar.gz"


# trinity
trinity_v=2.15.1
get_binary_from_github "trinityrnaseq" "trinityrnaseq" "Trinity-v$trinity_v/trinityrnaseq-v$trinity_v.FULL.tar.gz" trinityrnaseq-v$trinity_v


# StringTie
get_binary_from_github "gpertea" "stringtie" "v2.2.1/stringtie-2.2.1.Linux_x86_64.tar.gz"

# subread
SUBREAD_V=2.0.3
wget -qO- https://gigenet.dl.sourceforge.net/project/subread/subread-$SUBREAD_V/subread-$SUBREAD_V-Linux-x86_64.tar.gz | tar xz
mv subread-$SUBREAD_V-Linux-x86_64 subread
export PATH=$PATH:$SOFTWARE_PATH/subread

# Salmon
salmon_v=1.10.0
get_binary_from_github COMBINE-lab salmon v$salmon_v/salmon-${salmon_v}_linux_x86_64.tar.gz salmon-latest_linux_x86_64


# RSEM
# blockmodeling will fail to install. It doesn't matter since we've installed it in R.
RSEM_v=1.3.3
wget -qO- https://github.com/deweylab/RSEM/archive/refs/tags/v$RSEM_v.tar.gz | tar xz
cd RSEM-$RSEM_v
make 2>/dev/null >/dev/null
make ebseq 2>/dev/null >/dev/null
cd $SOFTWARE_PATH
mv RSEM-$RSEM_v RSEM
export PATH=$PATH:$SOFTWARE_PATH/RSEM


# kallisto
kallisto_v=0.46.1
wget -qO- https://github.com/pachterlab/kallisto/releases/download/v$kallisto_v/kallisto_linux-v$kallisto_v.tar.gz | tar xz
export PATH=$PATH:$SOFTWARE_PATH/kallisto

# ====================
echo_blue "Installing prokka, Prodigal, pplacer, kraken2, fastANI..."
# prokka
git clone https://github.com/tseemann/prokka.git $SOFTWARE_PATH/prokka 2>/dev/null
$SOFTWARE_PATH/prokka/bin/prokka --setupdb 2>/dev/null >/dev/null
export PATH=$PATH:$SOFTWARE_PATH/prokka/bin
wget -qO- ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools/converters/by_program/tbl2asn/linux64.tbl2asn.gz > tbl2asn.gz
gunzip -q tbl2asn.gz
chmod +x tbl2asn
mv tbl2asn $SOFTWARE_PATH/prokka/binaries/linux/


# Prodigal
Prodigal_V=2.6.3
mkdir $SOFTWARE_PATH/prodigal
wget -qO- https://github.com/hyattpd/Prodigal/releases/download/v$Prodigal_V/prodigal.linux > $SOFTWARE_PATH/prodigal/prodigal
chmod +x $SOFTWARE_PATH/prodigal/prodigal
export PATH=$PATH:$SOFTWARE_PATH/prodigal


# pplacer
get_binary_from_github "matsen" "pplacer" "v1.1.alpha19/pplacer-linux-v1.1.alpha19.zip" "pplacer-Linux-v1.1.alpha19"


# kraken2
kraken_v=2.1.2
wget -qO- https://github.com/DerrickWood/kraken2/archive/refs/tags/v$kraken_v.tar.gz | tar xz
mkdir $SOFTWARE_PATH/kraken2
cd kraken2-$kraken_v
./install_kraken2.sh $SOFTWARE_PATH/kraken2 2>/dev/null >/dev/null
export PATH=$PATH:$SOFTWARE_PATH/kraken2
rm -rf $SOFTWARE_PATH/kraken2-$kraken_v
cd $SOFTWARE_PATH


# fastANI
fastANI_v=1.33
wget -q https://github.com/ParBLiSS/FastANI/releases/download/v$fastANI_v/fastANI-Linux64-v$fastANI_v.zip
unzip -qf fastANI-Linux64-v$fastANI_v.zip
rm fastANI-Linux64-v$fastANI_v.zip


# ====================
echo_blue "Installing Ruby..."
# ruby
ruby_v=3.2.1
wget -qO- https://cache.ruby-lang.org/pub/ruby/$(echo $ruby_v | cut -d "." -f 1,2)/ruby-$ruby_v.tar.gz | tar xz
cd ruby-$ruby_v
./configure --prefix $SOFTWARE_PATH/ruby 2>/dev/null >/dev/null
make 2>/dev/null >/dev/null
make install 2>/dev/null >/dev/null
cd $SOFTWARE_PATH
rm -rf ruby-$ruby_v
export PATH=$PATH:$SOFTWARE_PATH/ruby/bin

# ====================
echo_blue "Installing KofamKOALA..."
# KofamKOALA (requires HMMER, ruby, parallel)
mkdir -p $SOFTWARE_PATH/kofamscan
mkdir -p $SOFTWARE_PATH/kofamscan/db
mkdir -p $SOFTWARE_PATH/kofamscan/bin
cd $SOFTWARE_PATH/kofamscan/db
wget -q ftp://ftp.genome.jp/pub/db/kofam/ko_list.gz 
wget -qO- ftp://ftp.genome.jp/pub/db/kofam/profiles.tar.gz | tar xz
gunzip ko_list.gz
cd $SOFTWARE_PATH/kofamscan/bin
kofam_scan_v=1.3.0
wget -qO- https://www.genome.jp/ftp/tools/kofam_scan/kofam_scan-$kofam_scan_v.tar.gz | tar xz
echo "profile: $SOFTWARE_PATH/kofamscan/db/profiles" > config.yml
echo "ko_list: $SOFTWARE_PATH/kofamscan/db/ko_list" >> config.yml
echo "hmmsearch: $(which hmmsearch)" >> config.yml
echo "parallel: $(which parallel)" >> config.yml
echo "cpu: 8" >> config.yml
cd $SOFTWARE_PATH
export PATH=$PATH:$SOFTWARE_PATH/kofamscan/bin/kofam_scan-$kofam_scan_v


# ====================
echo_blue "Installing PWMscan..."
# PWMscan
# https://github.com/wassermanlab/JASPAR-UCSC-tracks
wget -qO- https://sourceforge.net/projects/pwmscan/files/pwmscan/rel-1.1.9/pwmscan.1.1.9.tar.gz | tar xz
cd pwmscan
mkdir -p bin
make clean 2>/dev/null >/dev/null && make cleanbin 2>/dev/null >/dev/null
make 2>/dev/null >/dev/null && make install 2>/dev/null >/dev/null
cd $SOFTWARE_PATH
export PATH=$PATH:$SOFTWARE_PATH/pwmscan/bin


# ====================
echo_blue "Installing nextflow..."
wget -qO- https://get.nextflow.io | bash 2>/dev/null >/dev/null
chmod +x nextflow
nextflow self-update 2>/dev/null >/dev/null

# ====================
# echo_blue "Installing mamba..."
wget -q "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh"
bash Mambaforge-Linux-x86_64.sh -b -p $SOFTWARE_PATH/mambaforge >/dev/null
export PATH=$PATH:$SOFTWARE_PATH/mambaforge/bin

# ====================
echo_blue "Installing HMMER, HH-suite, TM-score, TM-align, US-align, MMseqs2, foldseek..."
# HMMER
HMMER_V=3.3.2
wget -qO- http://eddylab.org/software/hmmer/hmmer-$HMMER_V.tar.gz | tar xz
cd hmmer-$HMMER_V
./configure --prefix $SOFTWARE_PATH/hmmer 2>/dev/null >/dev/null
make 2>/dev/null >/dev/null
make check 2>/dev/null >/dev/null
make install 2>/dev/null >/dev/null
(cd easel; make install 2>/dev/null >/dev/null)
cd $SOFTWARE_PATH
rm -rf hmmer-$HMMER_V
export PATH=$SOFTWARE_PATH/hmmer/bin:$PATH

# HH-suite
mkdir -p $SOFTWARE_PATH/hh-suite
cd $SOFTWARE_PATH/hh-suite
wget -qO- https://github.com/soedinglab/hh-suite/releases/download/v3.3.0/hhsuite-3.3.0-SSE2-Linux.tar.gz | tar xz
export PATH=$PATH:$(pwd)/bin:$(pwd)/scripts
cd $SOFTWARE_PATH

# TM-score
mkdir -p $SOFTWARE_PATH/TM-score
cd $SOFTWARE_PATH/TM-score
wget -q https://zhanggroup.org/TM-score/TMscore.cpp
g++ -static -O3 -ffast-math -lm -o TMscore TMscore.cpp
cd $SOFTWARE_PATH
export PATH=$PATH:$SOFTWARE_PATH/TM-score

# TM-align
mkdir -p $SOFTWARE_PATH/TM-align
cd $SOFTWARE_PATH/TM-align
wget -q https://zhanggroup.org/TM-align/TMalign.cpp
wget -q https://zhanggroup.org/TM-align/readme.c++.txt
g++ -static -O3 -ffast-math -lm -o TMalign TMalign.cpp
cd $SOFTWARE_PATH
export PATH=$PATH:$SOFTWARE_PATH/TM-align

# US-align
mkdir -p $SOFTWARE_PATH/US-align
cd $SOFTWARE_PATH/US-align
wget -q https://zhanggroup.org/US-align/bin/module/USalign.cpp
g++ -static -O3 -ffast-math -o USalign USalign.cpp
cd $SOFTWARE_PATH
export PATH=$PATH:$SOFTWARE_PATH/US-align

# foldseek
wget -qO- https://mmseqs.com/foldseek/foldseek-linux-avx2.tar.gz | tar xz
export PATH=$PATH:$(pwd)/foldseek/bin/

# MMseqs2
wget -qO- https://mmseqs.com/latest/mmseqs-linux-avx2.tar.gz | tar xz
export PATH=$(pwd)/mmseqs/bin/:$PATH

# ====================
# For cell ranger and space ranger, manual installation from website is required
# echo_blue "Installing Cell Ranger and Space Ranger..."
# # Space Ranger
# wget -qO- "https://cf.10xgenomics.com/releases/spatial-exp/spaceranger-2.0.1.tar.gz?Expires=1684996597&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvc3BhdGlhbC1leHAvc3BhY2VyYW5nZXItMi4wLjEudGFyLmd6IiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNjg0OTk2NTk3fX19XX0_&Signature=E5rDek62W11UPX5OsKSYRVb7x4L2evquJDbaR~xHsLOOYhYbdwq-fqW1IDYanKBVUI-YpFbpgTPlbVPq-IyPpkUOjeU8o2sruViv8Ey~9-~6ZISbWK-vDxWpf8OdPOiR9py8ZILrv9zHBPgvD5OnRBszZmyg3-oLGb8hXqCn-OC~D3NwecXTfeSSLABdVhsD~RuNR3vDYSRfa1U-xtfCyRgL3SNWHbuADQAs8UpsJ18VoD459iaM5HA2hVgrf05iG0Ub4Lr5FiiJxTlJ8rYRmZ1HNCYTwZoSVfp8WubSDV9p9DlU8-QUKwzkANEndRan1KHKI0PmkEQvTOmNaurUpg__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA" | tar xz
# mv spaceranger-2.0.1 spaceranger
# export PATH=$PATH:spaceranger

# # Cell Ranger
# wget -qO- "https://cf.10xgenomics.com/releases/cell-exp/cellranger-7.1.0.tar.gz?Expires=1684996757&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1leHAvY2VsbHJhbmdlci03LjEuMC50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE2ODQ5OTY3NTd9fX1dfQ__&Signature=ftfvhAMAVKK71ntHGYuqTUIkEgg0wakEPuhq9LKSpHktvRXvtzGlZ7J18bH4qXxM2e~B1KhaVi9wzFutk8rweuhKtEcIgy0OF0~Yb-2Jgw0fyMdTM9Kw-nKvyAL-scBNHfWEsOQTEAL4sNoslIKIT42bZWP0C~tX1OKQy3nRUshboOeQb1EWNcOmr2ZvpEjCq27lHa4cuJoZn2I66ezQCY7WjT~aoBryiLGK-kVBNwjjNZfgwMOLdl7XTXjOxZUhyEdziYzY1y0PWmQT6X7AXbWDKBUDf4Z1bpLWBViGie90VIJe0YkXjViEG4P39gX7VkoQDpqX1C4n-ifywhzzJQ__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA" | tar xz
# mv cellranger-7.1.0 cellranger
# export PATH=$PATH:cellranger


# ====================
echo_blue "Installing Picard, Shi7..."
# Picard
wget -q https://github.com/broadinstitute/picard/releases/download/3.0.0/picard.jar
echo \#\!/bin/bash > $SOFTWARE_PATH/picard
echo "java -jar $SOFTWARE_PATH/picard.jar \$@" >> $SOFTWARE_PATH/picard
chmod +x $SOFTWARE_PATH/picard


# ====================
echo "Finishing..."
echo "PATH=$PATH" >> $HOME/.bashrc
echo "JAVA_HOME=$JAVA_HOME" >> $HOME/.bashrc

cd $start_dir
