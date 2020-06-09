FROM rocker/shiny-verse

COPY shiny-customized.config /etc/shiny-server/shiny-server.conf
ADD index.html /srv/shiny-server/index.html

WORKDIR /srv/shiny-server



