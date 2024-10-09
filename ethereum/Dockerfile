FROM ubuntu:24.04
 
COPY . ./eth

WORKDIR eth

RUN apt-get update
RUN apt install -y sudo
RUN ./installEnv.sh
RUN npm install -g @arcologynetwork/frontend-tools

EXPOSE 7545
EXPOSE 3500

CMD ["./start.sh"]
 
