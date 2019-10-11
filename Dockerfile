FROM alpine

RUN apk update && apk add py-pip postgresql-client
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

ADD run.sh run.sh
RUN sed -i 's/\r$//' run.sh && chmod +x run.sh

CMD ["/bin/sh", "run.sh"]
