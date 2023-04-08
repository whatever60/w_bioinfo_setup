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
