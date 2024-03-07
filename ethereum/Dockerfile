FROM ubuntu:20.04
 
COPY . ./eth

WORKDIR eth

RUN apt-get update
RUN apt install sudo
RUN ./installJq.sh

EXPOSE 7545

CMD ["./start.sh"]
 
