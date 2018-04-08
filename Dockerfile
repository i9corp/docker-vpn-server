FROM debian:9.2
LABEL Author="Sileno Brito"
LABEL Email="repo@i9corp.com.br"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y --reinstall linux-image-$(uname -r)
RUN apt-get install -y pptpd iptables rsyslog dos2unix kmod 

ENV POSTGRES_USERNAME=vpn-server
ENV POSTGRES_PASSWORD=123456
ENV POSTGRES_PORT=5432
ENV POSTGRES_HOST=127.0.0.1

COPY ./etc/pptpd.conf /etc/pptpd.conf
COPY ./etc/ppp/pptpd-options /etc/ppp/pptpd-options
COPY pptpconfig /etc/init.d/pptpconfig
COPY start-packages.sh /usr/local/bin/start-packages

RUN chmod 0664 /etc/ppp/pptpd-options \
    && chmod 0664 /etc/pptpd.conf \
    && chmod 0775 /etc/init.d/pptpconfig \
    && chmod 0775 /usr/local/bin/start-packages

RUN dos2unix /etc/ppp/pptpd-options \
    && dos2unix /etc/pptpd.conf \
    && dos2unix /etc/init.d/pptpconfig \
    && dos2unix /usr/local/bin/start-packages

RUN update-rc.d pptpconfig defaults

RUN echo "teste * 123456 *" >> /etc/ppp/chap-secrets


EXPOSE 1723

CMD [ "/usr/local/bin/start-packages" ]