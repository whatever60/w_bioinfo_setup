# sudo bash setup_sudo.sh

sudo apt update
sudo apt install nala -y

sudo nala install -y fish python2 r-base wget curl

# AWS utilities
sudo nala install -y awscli s3fs


# R utilities
# sudo nala install -y libharfbuzz-dev libfribidi-dev
# sudo nala install -y libcurl4-gnutls-dev
sudo nala install -y build-essential libxml2-dev libssl-dev libcurl4-openssl-dev libfontconfig1-dev libtiff5-dev libgit2-dev
sudo nala install -y r-base r-base-core r-base-dev r-base-html r-doc-html r-recommended
Rscript --silent --slave --no-save --no-restore r_packages.r


# JAVA environment
sudo nala install default-jre -y


# prokka
sudo nala install -y ncbi-tools-bin libdatetime-perl libxml-simple-perl libdigest-md5-perl git default-jre bioperl
sudo cpan Bio::Perl

# quast
sudo nala install -y pkg-config libfreetype6-dev

# for ruby
sudo nala install libtool libyaml-dev -y
