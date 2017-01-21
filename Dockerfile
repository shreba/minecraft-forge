# Minecraft moded server, v1.11.2
FROM ubuntu:16.04
MAINTAINER SteamFab <martin@steamfab.io>

USER root

# install Minecraft dependencies
RUN apt-get update && apt-get install -y \
    default-jre-headless \
    wget \
    rsyslog \
    unzip

RUN update-ca-certificates -f

# clean up
RUN apt-get clean
RUN rm -rf /tmp/* /tmp/.[!.]* /tmp/..?*  /var/lib/apt/lists/*

# Setup locale
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment
ENV VERSION 1.11.2-13.20.0.2222
ENV SHELL /bin/bash
ENV NB_USER minecraft
ENV NB_UID 1000
ENV HOME /home/$NB_USER
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Create minecraft user with UID=1000 and in the 'users' group
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER

# Copy Mincecraft config files
#COPY banned-ips.json $HOME
#COPY banned-players.json $HOME
#COPY ops.json $HOME
#COPY server.properties $HOME
#COPY whitelist.json $HOME
#RUN chown $NB_USER:users $HOME/*.json && \
#    chown $NB_USER:users $HOME/server.properties
#COPY server-icon.png $HOME
#RUN chown $NB_USER:users $HOME/server-icon.png

USER $NB_USER

# download and unpack Minecraft
WORKDIR $HOME
RUN wget --quiet http://files.minecraftforge.net/maven/net/minecraftforge/forge/$VERSION/forge-$VERSION-installer.jar

# run Minecraft installer
RUN java -jar forge-$VERSION-installer.jar --installServer
RUN rm forge-$VERSION-installer.jar

# Copy eula set to 'true'
#COPY eula.txt .

# Install some mods
RUN cd mods/ && wget --quiet http://files.minecraftforge.net/maven/org/spongepowered/spongeforge/1.11.2-2201-6.0.0-BETA-2041/spongeforge-1.11.2-2201-6.0.0-BETA-2041.jar
#RUN cd mods/ && wget --quiet https://addons-origin.cursecdn.com/files/2355/945/worldedit-forge-mc1.11-6.1.6-dist.jar
RUN cd mods/ && wget --quiet https://addons-origin.cursecdn.com/files/2361/140/VeinMiner-1.11-0.35.3.605+dad98e1.jar

#RUN cd mods/ && wget --quiet http://ci.forgeessentials.com/job/FE/1336/artifact/build/libs/forgeessentials-1.7.10-1.4.5.1336-server.jar
#RUN cd mods/ && wget --quiet https://addons-origin.cursecdn.com/files/2361/848/forgeessentials-1.7.10-1.4.5.1330-server.jar

# Configure remaining tasks for root user
USER root
WORKDIR /root

# Setup backup cron job
#ADD backup-cron /etc/cron.d/backup-cron
#RUN chmod 0644 /etc/cron.d/backup-cron
#RUN touch /var/log/cron.log 

# install gcloud
#ENV PATH /opt/google-cloud-sdk/bin:$PATH
#RUN mkdir -p /opt/gcloud && \
#    wget --quiet --no-check-certificate --directory-prefix=/tmp/ https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.zip && \
#    unzip /tmp/google-cloud-sdk.zip -d /opt/ && \
#    /opt/google-cloud-sdk/install.sh --usage-reporting=true --path-update=true --bash-completion=true --rc-path=/opt/gcloud/.bashrc --disable-installation-options && \
#    gcloud --quiet components update app preview alpha beta app-engine-java app-engine-python kubectl bq core gsutil gcloud && \
#    rm -rf /tmp/*

# Setup backup cron job
#ADD backup-cron /etc/cron.d/backup-cron
#RUN chmod 0644 /etc/cron.d/backup-cron
#RUN touch /var/log/cron.log

# Backup script to be run by cron job
#COPY backup.sh /home/$NB_USER
#RUN chown $NB_USER:users /home/$NB_USER/backup.sh

# logrotate configuration for backup files
#COPY backup /etc/logrotate.d

# Run Minecraft
EXPOSE 25565

COPY run.sh .

ENTRYPOINT ["/root/run.sh"]