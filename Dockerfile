FROM ubuntu:20.04
 
COPY . ./devnet

WORKDIR devnet

RUN apt-get update
RUN apt install sudo
RUN apt install -y  wget
RUN ln -sf /usr/share/zoneinfo/America/Phoenix /etc/localtime
RUN ./cli/install.sh -p 127.0.0.1


EXPOSE 8545

ENTRYPOINT ["cli/start.sh"]

 
