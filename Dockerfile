FROM ubuntu:22.04

RUN git clone git@github.com:whatever60/w_bioinfo_setup.git && \
    cd w_bioinfo_setup && \
    source setup_sudo.sh && \
    source setup.sh
    cd .. && \
    rm -rf w_bioinfo_setup
