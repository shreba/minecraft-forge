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
ENV VERSION 1.7.10-10.13.4.1614
ENV SHELL /bin/bash
ENV NB_USER minecraft
ENV NB_UID 1000
ENV HOME /home/$NB_USER
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Create minecraft user with UID=1000 and in the 'users' group
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER

USER $NB_USER

# download and unpack Minecraft
WORKDIR $HOME
RUN wget --quiet http://files.minecraftforge.net/maven/net/minecraftforge/forge/$VERSION/forge-$VERSION-installer.jar

# run Minecraft installer
RUN java -jar forge-$VERSION-installer.jar --installServer
RUN rm forge-$VERSION-installer.jar

# Install some mods
#RUN cd mods/ && wget --quiet http://files.minecraftforge.net/maven/org/spongepowered/spongeforge/1.11.2-2201-6.0.0-BETA-2041/spongeforge-1.11.2-2201-6.0.0-BETA-2041.jar
#RUN cd mods/ && wget --quiet https://addons-origin.cursecdn.com/files/2355/945/worldedit-forge-mc1.11-6.1.6-dist.jar
#RUN cd mods/ && wget --quiet https://addons-origin.cursecdn.com/files/2361/140/VeinMiner-1.11-0.35.3.605+dad98e1.jar

# Configure remaining tasks for root user
USER root
WORKDIR /root

# Run Minecraft
EXPOSE 25565

COPY run.sh .

ENTRYPOINT ["/root/run.sh"]
