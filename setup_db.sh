# bash setup_db.sh 

# build database
# checkm
mkdir $HOME/.checkm
cd $HOME/.checkm
wget -qO- https://data.ace.uq.edu.au/public/CheckM_databases/checkm_data_2015_01_16.tar.gz | tar xz
cd ~
export CHECKM_DATA_PATH=$HOME/.checkm

# kraken2
kraken2-build --standard --threads 24 --db $HOME/kraken2-db



# InterProScan
# follow https://interproscan-docs.readthedocs.io/en/latest/UserDocs.html#installation-requirements
# download interproscan
# if you want full capability:
# download Phobius, SignalP and TMHMM and copy requried files to required path.
# python3 setup.py interproscan.properties
# add "pirsf.pl.binary.switches=--outfmt i5" to interproscan.properties
# run these
# bin/hmmer/hmmer3/3.3/hmmpress -f data/gene3d/4.3.0/gene3d_main.hmm
# bin/hmmer/hmmer3/3.3/hmmpress -f data/hamap/2021_04/hamap.hmm.lib
# bin/hmmer/hmmer3/3.3/hmmpress -f data/panther/17.0/famhmm/binHmm 
# bin/hmmer/hmmer3/3.3/hmmpress -f data/pfam/35.0/pfam_a.hmm
# bin/hmmer/hmmer3/3.1b1/hmmpress -f data/sfld/4/sfld.hmm
# bin/hmmer/hmmer3/3.1b1/hmmpress -f data/superfamily/1.75/hmmlib_1.75
# bin/hmmer/hmmer3/3.3/hmmpress -f data/tigrfam/15.0/TIGRFAMs_HMM.LIB
interproscan_v=5.60-92.0
wget https://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.60-92.0/interproscan-$interproscan_v-64-bit.tar.gz
tar pxzf interproscan-$interproscan_v-64-bit.tar.gz
