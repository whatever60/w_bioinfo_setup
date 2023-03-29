FROM ubuntu:22.04

COPY setup_sudo.sh /root
COPY setup.sh /root
COPY r_packages.r /root

RUN chmod +x /root/setup_sudo.sh && \
    chmod +x /root/setup.sh

RUN /root/setup_sudo.sh
RUN /root/setup.sh
RUN Rscript --silent --slave --no-save --no-restore /root/r_packages.r

CMD ["/bin/bash"]
