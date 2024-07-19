# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
ARG ORTHANC_VERSION=latest

FROM orthancteam/orthanc:$ORTHANC_VERSION as orthanc_build
ARG S3_PLUGIN_BRANCH=default

RUN apt-get -y update
RUN apt-get install -y git mercurial build-essential unzip cmake libcrypto++-dev wget python3 python3-pip python3-setuptools

WORKDIR /tmp
RUN hg clone https://hg.orthanc-server.com/orthanc-object-storage/
WORKDIR /tmp/orthanc-object-storage
RUN hg up -c "$S3_PLUGIN_BRANCH"

WORKDIR /tmp/build
RUN cmake -DSTATIC_BUILD=ON -DCMAKE_BUILD_TYPE=Release -DUSE_VCPKG_PACKAGES=OFF -DUSE_SYSTEM_GOOGLE_TEST=OFF ../orthanc-object-storage/Aws
RUN CORES=`grep -c ^processor /proc/cpuinfo` && make -j$CORES

FROM orthancteam/orthanc:$ORTHANC_VERSION
COPY --from=orthanc_build /tmp/build/libOrthancAwsS3Storage.so /usr/share/orthanc/plugins/

# Update OS packages
RUN apt-get -y update 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

# Create non-root Orthanc user and group
RUN if id -u orthanc >/dev/null 2>&1; then \
      userdel orthanc; \
    fi && \
    if getent group orthanc; then \
      groupdel orthanc; \
    fi && \
    groupadd -r orthanc -g 433 && \
    useradd -u 431 -r -g orthanc -c "Orthanc user" orthanc

RUN chmod -R 755 /usr/share/orthanc
RUN chown -R orthanc /usr/share/orthanc
RUN chown -R orthanc:orthanc /usr/share/orthanc/plugins-available

# Add custom script that can remove S3 plugin if necessary
COPY custom-script.sh /tmp
RUN chown -R orthanc /tmp
RUN chmod +x /tmp/custom-script.sh

#USER orthanc
