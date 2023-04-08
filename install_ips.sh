interproscan_v=5.61-93.0
start_dir=$(pwd)

cd ~
wget https://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/$interproscan_v/interproscan-$interproscan_v-64-bit.tar.gz
tar pxzf interproscan-$interproscan_v-64-bit.tar.gz
mv interproscan-$interproscan_v interproscan
cp -r $start_dir/install_ips/bin/* interproscan/bin/
cp -r $start_dir/install_ips/data/* interproscan/data/

cd interproscan
cat $start_dir/install_ips/add_properties.txt >> interproscan.properties
echo "pirsf.pl.binary.switches=--outfmt i5" >> interproscan.properties
python3 setup.py interproscan.properties

bin/hmmer/hmmer3/3.3/hmmpress -f data/gene3d/4.3.0/gene3d_main.hmm
bin/hmmer/hmmer3/3.3/hmmpress -f data/hamap/2021_04/hamap.hmm.lib
bin/hmmer/hmmer3/3.3/hmmpress -f data/panther/17.0/famhmm/binHmm 
bin/hmmer/hmmer3/3.3/hmmpress -f data/pfam/35.0/pfam_a.hmm
bin/hmmer/hmmer3/3.1b1/hmmpress -f data/sfld/4/sfld.hmm
bin/hmmer/hmmer3/3.1b1/hmmpress -f data/superfamily/1.75/hmmlib_1.75
bin/hmmer/hmmer3/3.3/hmmpress -f data/tigrfam/15.0/TIGRFAMs_HMM.LIB

cd $start_dir
