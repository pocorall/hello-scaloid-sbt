FROM debian:jessie

MAINTAINER <maintainer@email.com>

# Setting up Docker image to replicate "hello-scaloid-sbt" project
# https://github.com/pocorall/hello-scaloid-sbt

####################################
# Install important packages
####################################
RUN echo "Acquire::Retries 20;" >> /etc/apt/apt.conf
RUN apt-get update && apt-get -y install aptitude
RUN aptitude update && aptitude -y --without-recommends install \
  wget curl mc sudo git usbutils unzip \
  openjdk-7-jdk lib32z1 lib32ncurses5 g++-multilib

####################################
# Install SBT
####################################
RUN curl -# -L https://dl.bintray.com/sbt/debian/sbt-0.13.8.deb > /tmp/sbt-0.13.8.deb && \
      dpkg -i /tmp/sbt-0.13.8.deb

####################################
# Create new user "scaloid"
####################################
ENV NEW_USER=scaloid

RUN adduser --disabled-password --gecos '' ${NEW_USER}

# Make him a sudoer
RUN echo "${NEW_USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${NEW_USER} && \
	  chmod 0440 /etc/sudoers.d/${NEW_USER}

####################################
# Switching to user-level
####################################
USER ${NEW_USER}
WORKDIR /home/${NEW_USER}/

####################################
# Set up Android SDK
####################################
# Download and install Android SDK
ENV ANDROID_SDK_URL http://dl.google.com/android/android-sdk_r24.3.3-linux.tgz
RUN wget --progress=bar:force --tries=99 ${ANDROID_SDK_URL} -O /tmp/android_sdk.tgz && \
  tar xzf /tmp/android_sdk.tgz -C /home/${NEW_USER}/

# Install Android SDK components
# do `android list sdk --all -e` to see all available sdk packages
ENV ANDROID_HOME /home/${NEW_USER}/android-sdk-linux
ENV ANDROID_SDK_COMPONENTS platform-tools,build-tools-21.1.2,android-21,android-16,extra-android-support,addon-google_apis-google-21,sys-img-x86_64-addon-google_apis-google-21
RUN echo y | ${ANDROID_HOME}/tools/android update sdk --no-ui --all --filter "${ANDROID_SDK_COMPONENTS}"

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
RUN echo "export ANDROID_HOME=${ANDROID_HOME}" >> /home/${NEW_USER}/.bashrc
RUN echo "export JAVA_HOME=${JAVA_HOME}" >> /home/${NEW_USER}/.bashrc
RUN echo "export DISPLAY=:0" >> /home/${NEW_USER}/.bashrc

####################################
# Set up the project itself
####################################
# Git clone the project
RUN git clone https://github.com/pocorall/hello-scaloid-sbt

# Let sbt download what it needs
RUN cd /home/${NEW_USER}/hello-scaloid-sbt && sbt android:package &&\
    ${ANDROID_HOME}/tools/android update project -p .

####################################
# Add IDEA + Plugins
####################################
# Download and install IntelliJ IDEA
RUN wget --progress=bar:force --tries=99\
    https://download.jetbrains.com/idea/ideaIC-14.1.4.tar.gz -O /tmp/idea.tar.gz && \
    tar xzf /tmp/idea.tar.gz -C /home/${NEW_USER}/ && \
    mv /home/${NEW_USER}/idea-IC-141.1532.4 /home/${NEW_USER}/idea

# Make a runnable script for launching IDEA w/o terminal
RUN echo '#!/bin/bash' > /home/${NEW_USER}/idea/bin/idea-run
RUN echo "nohup /home/${NEW_USER}/idea/bin/idea.sh 2>/dev/null &" >> /home/${NEW_USER}/idea/bin/idea-run
RUN chmod 755 /home/${NEW_USER}/idea/bin/idea-run

RUN echo "export PATH=\${PATH}:${ANDROID_HOME}/tools/:${ANDROID_HOME}/platform-tools/:/home/${NEW_USER}/idea/bin/" >> /home/${NEW_USER}/.bashrc

# Install plugins
RUN mkdir -p /home/${NEW_USER}/.IdeaIC14/config/plugins 
RUN cd /home/${NEW_USER}/.IdeaIC14/config/plugins &&\
  wget --progress=bar:force --tries=99\
  http://plugins.jetbrains.com/files/1347/20041/scala-intellij-bin-1.5.2.zip -O scala-plugin.zip && unzip scala-plugin.zip &&\
  wget --progress=bar:force --tries=99\
  http://plugins.jetbrains.com/files/5007/19457/idea-sbt-plugin-1.7.0.zip -O sbt-plugin.zip && unzip sbt-plugin.zip &&\
  rm -f *.zip

ENV DISPLAY :0

# DONE!

####################################
# Use of Dockerfile
####################################
# Build the docker image ON THE HOST:
# $ docker build -t scaloid .
# 
## Since USB access is required to deploy the app
## do the following ON THE HOST:
# $ adb kill-server
# $ export XSOCK=/tmp/.X11-unix/X0
# $ xhost +localhost
# $ docker run --privileged -v $XSOCK:$XSOCK -v /dev/bus/usb:/dev/bus/usb -it <image>
# This allows one to connect to USB devices and thus, deploy the app on the phone directly from Docker
## For very secure way (using XAuthority) see:
## https://stackoverflow.com/questions/16296753/can-you-run-gui-apps-in-a-docker-container/25280523#25280523
