FROM rocker/shiny:latest

MAINTAINER Clemens Schmid <clemens@nevrome.de>

# install necessary system packages
RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    htop \
    nano \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds

# install necessary R packages
RUN R -e "install.packages('remotes')"
RUN R -e "remotes::install_github('nevrome/sdsanalysis')"
RUN R -e "remotes::install_github('nevrome/sdsbrowser')"

RUN mkdir /srv/shiny-server/sdsbrowser
RUN echo "sdsbrowser::sdsbrowser(run_app = FALSE)" >  /srv/shiny-server/sdsbrowser/app.R

# create config 
RUN echo "run_as shiny; \
          sanitize_errors off; \
          disable_protocols xdr-streaming xhr-streaming iframe-eventsource iframe-htmlfile; \
          disable_websockets true; \
		      server { \
  		       listen 3838; \
  		       location / { \
    		         app_dir /srv/shiny-server/sdsbrowser; \
    		         directory_index off; \
    		         log_dir /var/log/shiny-server; \
  		       } \
		     }" > /etc/shiny-server/shiny-server.conf

# start it
CMD exec shiny-server >> /var/log/shiny-server.log 2>&1
