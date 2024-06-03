FROM ubuntu:20.04
 
COPY . ./eth

WORKDIR eth

RUN apt-get update
RUN apt install sudo
RUN ./installEnv.sh
RUN npm install -g @arcologynetwork/frontend-tools

EXPOSE 7545

CMD ["./start.sh"]
 
