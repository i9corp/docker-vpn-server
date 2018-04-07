FROM debian:jessie-slim

LABEL Author="Sileno Brito"
LABEL Email="silenobrito@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y pptpd iptables rsyslog

COPY ./etc/pptpd.conf /etc/pptpd.conf
COPY ./etc/ppp/pptpd-options /etc/ppp/pptpd-options

COPY pptpconfig /etc/init.d/pptpconfig
RUN chmod 0777 /etc/init.d/pptpconfig
RUN update-rc.d pptpconfig defaults

COPY entrypoint.sh /entrypoint.sh
RUN chmod 0777 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["pptpd", "--fg"]