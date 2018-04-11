FROM debian:9.2
LABEL Author="Sileno Brito"
LABEL Email="repo@i9corp.com.br"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y --reinstall linux-image-$(uname -r)
RUN apt-get install -y pptpd iptables rsyslog dos2unix kmod postgresql-client freeradius freeradius-postgresql

#pptpd
COPY ./etc/pptpd.conf /etc/pptpd.conf
COPY ./etc/ppp/pptpd-options /etc/ppp/pptpd-options
COPY ./pptp-config /etc/init.d/pptp-config
COPY ./radius-config /etc/init.d/radius-config
COPY ./start-packages.sh /usr/local/bin/start-packages

RUN chmod 0664 /etc/ppp/pptpd-options \
    && chmod 0664 /etc/pptpd.conf \
    && chmod 0775 /etc/init.d/pptp-config \
    && chmod 0775 /etc/init.d/radius-config \
    && chmod 0775 /usr/local/bin/start-packages

RUN dos2unix /etc/ppp/pptpd-options \
    && dos2unix /etc/pptpd.conf \
    && dos2unix /etc/init.d/pptp-config \
    && dos2unix /etc/init.d/radius-config \
    && dos2unix /usr/local/bin/start-packages

RUN update-rc.d pptp-config defaults
RUN update-rc.d radius-config defaults

# freeradius
ENV PG_USER "radius"
ENV PG_PASS "radpass"
ENV PG_HOST "127.0.0.1"
ENV PG_PORT 5432
ENV PG_DBASE "radius"
ENV PGPASSWORD $PG_PASS

ARG RADIUS_DIR=/etc/freeradius/3.0
RUN mkdir -p /usr/src/raddb

COPY ./etc/raddb/schema.sql /usr/src/raddb/schema.sql
COPY ./etc/raddb/ippool.sql /usr/src/raddb/ippool.sql
COPY ./etc/raddb/cui.sql /usr/src/raddb/cui.sql

COPY ./etc/raddb/mods-config/queries.conf ${RADIUS_DIR}/mods-config/sql/main/postgresql/queries.conf
COPY ./etc/raddb/mods-enabled/sql ${RADIUS_DIR}/mods-available/i9_sql
COPY ./etc/raddb/sites-available/default ${RADIUS_DIR}/sites-available/default
COPY ./etc/raddb/sites-available/inner-tunnel ${RADIUS_DIR}/sites-available/inner-tunnel
COPY ./etc/raddb/clients.conf ${RADIUS_DIR}/clients.conf
RUN ln -sf ${RADIUS_DIR}/mods-available/sql ${RADIUS_DIR}/mods-enabled/sql

RUN chmod 0640 ${RADIUS_DIR}/clients.conf \
    ${RADIUS_DIR}/sites-available/inner-tunnel \
    ${RADIUS_DIR}/sites-available/default  \
    ${RADIUS_DIR}/mods-enabled/sql \
    ${RADIUS_DIR}/mods-config/sql/main/postgresql/queries.conf \
    ${RADIUS_DIR}/mods-available/i9_sql

RUN chown -R freerad:freerad ${RADIUS_DIR}/clients.conf \
    ${RADIUS_DIR}/sites-available/inner-tunnel \
    ${RADIUS_DIR}/sites-available/default  \
    ${RADIUS_DIR}/mods-enabled/sql \
    ${RADIUS_DIR}/mods-config/sql/main/postgresql/queries.conf \
    ${RADIUS_DIR}/mods-available/i9_sql

RUN dos2unix ${RADIUS_DIR}/clients.conf \
    ${RADIUS_DIR}/sites-available/inner-tunnel \
    ${RADIUS_DIR}/sites-available/default  \
    ${RADIUS_DIR}/mods-enabled/sql \
    ${RADIUS_DIR}/mods-config/sql/main/postgresql/queries.conf \
    ${RADIUS_DIR}/mods-available/i9_sql

RUN apt-get autoremove && apt-get clean

EXPOSE 1723
EXPOSE 1812
CMD [ "/usr/local/bin/start-packages" ]