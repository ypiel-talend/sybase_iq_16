# Dockerfile for Sybase IQ 16.0 30 days evaluation
# Install process based on 
# HTTP port : 4282
# HTTPS port : 4283
# RMI port : 4992
# TDS port : 4998
# Starting port : 2638 (exposed)
FROM centos:7

MAINTAINER Yves Piel<yvespiel@gmail.com>

RUN set -x \
  && mkdir -p /opt/sybase/work \
  && mkdir -p /opt/sybase/iq16 \
  && mkdir -p /var/sybase/IQ1/iq_files

RUN set -x \
  && groupadd sybase \
  && useradd -g sybase -d /opt/sybase sybase

COPY iq160_LinuxAMD64.tgz /opt/sybase/work/iq160_LinuxAMD64.tgz
COPY assets/iq_response.txt /tmp/iq_response.txt
COPY assets/exec_createdb.sh /tmp/exec_createdb.sh
COPY assets/create_db.iq.sql /tmp/create_db.iq.sql
COPY assets/endpoint.sybase.iq.sh /tmp/endpoint.sybase.iq.sh

RUN set -x \
  && chown -R sybase:sybase /opt/sybase \
  && chown -R sybase:sybase /var/sybase \
  && chmod +x /tmp/exec_createdb.sh \
  && chmod +x /tmp/endpoint.sybase.iq.sh


RUN set -x \
  && yum -y update \
  && yum -y install csh \
  && yum -y install file \
  && yum -y install libaio \
  && yum -y install libXext \
  && yum -y install libXrender \
  && yum -y install libXtst \
  && yum -y install libXi \
  && yum -y install java-1.8.0-openjdk \
  && yum -y clean packages


RUN set -x \
  && su - sybase \
  && cd /opt/sybase/work/ \
  && tar -xzf iq160_LinuxAMD64.tgz \
  && rm -f iq160_LinuxAMD64.tgz

RUN set -x \
  && su - sybase \
  && cd /opt/sybase/work/SAPIQ_1600_SP11-LinuxAMD64-eval \
  && ./setup.bin -f /tmp/iq_response.txt -i silent -DAGREE_TO_SAP_LICENSE=true -DUNINSTALL_DELETE_DATA_FILES=true \
  && rm -rf /opt/sybase/work

ENV IQLOGDIR16=/var/sybase/IQ1/
ENV PATH=$PATH:/opt/sybase/iq16/IQ-16_0/bin64/
ENV SYBASE=/opt/sybase/iq16/

RUN set -x \
  && /tmp/exec_createdb.sh

EXPOSE 2638
WORKDIR /var/sybase/IQ1
CMD ["/tmp/endpoint.sybase.iq.sh"]
