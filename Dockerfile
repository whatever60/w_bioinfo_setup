FROM ubuntu:22.04

RUN useradd -ms /bin/bash ubuntu
USER ubuntu
WORKDIR /home/ubuntu

COPY setup_sudo.sh .
COPY setup.sh .
COPY r_packages.r .

RUN chmod +x /home/ubuntu/setup_sudo.sh
RUN chmod +x /home/ubuntu/setup.sh

USER root
RUN /home/ubuntu/setup_sudo.sh

USER ubuntu
RUN /home/ubuntu/setup.sh

CMD ["/usr/bin/fish"]
