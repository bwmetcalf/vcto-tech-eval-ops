FROM centos:6
MAINTAINER Brandon Metcalf "bwmetcalf@gmail.com"
 
ENV CONTAINER brandonmetcalf/countme

RUN yum -y update
RUN yum -y install python35 python35-pip
RUN pip-3.5 install flask
RUN pip-3.5 install redis
RUN mkdir -p /opt/countme

ADD ./app.py /opt/countme/app.py

ENTRYPOINT ["python3", ""/opt/countme/app.py"]
