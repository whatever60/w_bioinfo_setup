# sudo bash setup_sudo.sh

sudo apt update
sudo apt install nala -y

sudo nala install -y fish python2 nala


# AWS utilities
sudo nala install -y awscli s3fs


# R utilities
# sudo nala install -y libharfbuzz-dev libfribidi-dev
# sudo nala install -y libcurl4-gnutls-dev
sudo nala install -y build-essential libxml2-dev libssl-dev libcurl4-openssl-dev libfontconfig1-dev libtiff5-dev libgit2-dev
sudo nala install -y r-base r-base-core r-base-dev r-base-html r-doc-html r-recommended


# JAVA environment
sudo nala install default-jre -y


# prokka
sudo nala install ncbi-tools-bin
sudo nala install -y libdatetime-perl libxml-simple-perl libdigest-md5-perl git default-jre bioperl
sudo cpan Bio::Perl


# quast
sudo nala install -y pkg-config libfreetype6-dev
quast_v=5.2.0
wget -qO- https://github.com/ablab/quast/releases/download/quast_$quast_v/quast-$quast_v.tar.gz | tar xz
cd $HOME/quast-$quast_v
sudo python2 setup.py install_full
cd ~


# for ruby
sudo nala install libtool libyaml-dev -y