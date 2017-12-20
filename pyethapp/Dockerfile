FROM ethresearch/pyethapp-research:devel

RUN apt-get install -y --no-install-recommends apt-utils python-minimal aptitude curl

# Download the filebeat package and install 
RUN curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.1.0-amd64.deb
RUN dpkg -i filebeat-6.1.0-amd64.deb
