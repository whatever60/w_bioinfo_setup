FROM ubuntu:22.04

COPY setup_sudo.sh /root
COPY setup.sh /root
COPY r_packages.r /root

RUN chmod +x /root/setup_sudo.sh && \
    chmod +x /root/setup.sh

CMD /root/setup.sh
