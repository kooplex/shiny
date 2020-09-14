FROM rocker/shiny-verse:3.6.1

RUN R -e 'install.packages(c("ggplot2", "shinyWidgets", "shinydashboard", "dplyr", "tidyr", "plotly", "wbstats"), repos = "http://cran.us.r-project.org")'
#RUN R -e 'install.packages(c("sf"), repos = "http://cran.us.r-project.org")'
#RUN R --version
#RUN R -e 'library("sf")'

RUN apt update
RUN apt install -y libudunits2-dev libgdal-dev

RUN R -e 'install.packages(c("tmap"), repos = "http://cran.us.r-project.org")'
RUN R -e 'install.packages(c("rpivotTable"), repos = "http://cran.us.r-project.org")'
RUN R -e 'install.packages(c("stringr"), repos = "http://cran.us.r-project.org")'
RUN R -e 'install.packages(c("shiny.i18n"), repos = "http://cran.us.r-project.org")'
RUN R -e 'install.packages(c("timevis"), repos = "http://cran.us.r-project.org")'
RUN R -e 'install.packages(c("reticulate"), repos = "http://cran.us.r-project.org")'
USER shiny
RUN R -e 'reticulate::install_miniconda();'
USER root
RUN R -e 'install.packages(c("py_install"), repos = "http://cran.us.r-project.org")'
#RUN /root/.local/share/r-miniconda/bin/conda init bash && bash -c "source /root/.bashrc" &&  R --no-restore --no-save -e 'reticulate :: py_install("pandas" );reticulate :: py_install("scikit-learn")'
USER shiny
RUN /home/shiny/.local/share/r-miniconda/bin/conda init bash && bash -c "source /home/shiny/.bashrc" &&  R --no-restore --no-save -e 'reticulate :: py_install("pandas" );reticulate :: py_install("scikit-learn")'

COPY shiny-customized.config /etc/shiny-server/shiny-server.conf
ADD index.html /srv/shiny-server/index.html
WORKDIR /srv/shiny-server



