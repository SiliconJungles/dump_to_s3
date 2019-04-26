FROM postgres:alpine

RUN apk update && apk add py-pip
RUN pip install awscli --upgrade

ENV PGDUMP_OPTIONS -Fc --no-acl --no-owner
ENV PGDUMP_DATABASE **None**

ENV AWS_ACCESS_KEY_ID **None**
ENV AWS_SECRET_ACCESS_KEY **None**
ENV AWS_BUCKET **None**

ENV PREFIX **None**

RUN apk add tzdata
RUN cp /usr/share/zoneinfo/Asia/Singapore /etc/localtime
RUN echo "Asia/Singapore" > /etc/timezone

ADD run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
