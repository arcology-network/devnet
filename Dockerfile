FROM ubuntu:24.04
 
COPY . ./devnet

WORKDIR devnet

RUN apt-get update
RUN apt install -y sudo
RUN apt install -y  wget
RUN ln -sf /usr/share/zoneinfo/America/Phoenix /etc/localtime
RUN ./cli/install.sh -p 127.0.0.1
RUN npm install -g @arcologynetwork/frontend-tools

EXPOSE 8545

ENTRYPOINT ["cli/start.sh"]

 
