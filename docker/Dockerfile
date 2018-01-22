FROM centos:7
MAINTAINER Brandon Metcalf "bwmetcalf@gmail.com"
 
ENV CONTAINER brandonmetcalf/countme

RUN yum -y update
RUN yum -y install epel-release
RUN yum -y install python34
RUN yum -y install python34-pip
RUN pip3.4 install flask
RUN pip3.4 install redis
RUN mkdir -p /opt/countme

ADD ./app.py /opt/countme/app.py

ENTRYPOINT ["/bin/bash"]
