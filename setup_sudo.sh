# sudo bash setup_sudo.sh

start_dir=$(pwd)
cd ~

sudo apt update
sudo apt install nala -y

# sudo apt-get install software-properties-common
# sudo apt-add-repository -y ppa:rael-gc/rvm
# sudo apt-get update
# sudo apt-get install rvm

sudo nala install -y fish python2 python2-dev python-setuptools python3-dev r-base-core r-base wget curl tmux git htop parallel msttcorefonts font-manager libgsl-dev
# sudo nala install -y libssl1.0-dev
# cd /lib/x86_64-linux-gnu
# sudo ln -s libssl.so.1.0.0 libssl.so.10
# sudo ln -s libcrypto.so.1.0.0 libcrypto.so.10
# cd ~

# AWS utilities
sudo nala install -y awscli s3fs


# R utilities
# sudo nala install -y libharfbuzz-dev libfribidi-dev
# sudo nala install -y libcurl4-gnutls-dev
sudo nala install -y build-essential libxml2-dev libssl-dev libcurl4-openssl-dev libfontconfig1-dev libtiff5-dev libgit2-dev libharfbuzz-dev libfribidi-dev
sudo nala install -y r-base r-base-core r-base-dev r-base-html r-doc-html r-recommended


# JAVA environment
sudo nala install default-jre -y


# prokka
sudo nala install -y ncbi-tools-bin libdatetime-perl libxml-simple-perl libdigest-md5-perl git default-jre bioperl
export PERL_MM_USE_DEFAULT=1
sudo cpan Bio::Perl

# quast
sudo nala install -y pkg-config libfreetype6-dev libpng-dev python3-matplotlib
quast_v=5.2.0
wget -qO- https://github.com/ablab/quast/releases/download/quast_$quast_v/quast-$quast_v.tar.gz | tar xz
mv quast-$quast_v quast
cd quast
sudo python3 setup.py install_full
cd ~

# for ruby
sudo nala install libtool libyaml-dev libffi-dev -y


cd $start_dir
