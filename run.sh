#!/bin/bash

set -e

if [ "${AWS_ACCESS_KEY_ID}" = "**None**" ]; then
  echo "You need to set the AWS_ACCESS_KEY_ID environment variable."
  exit 1
fi

if [ "${AWS_SECRET_ACCESS_KEY}" = "**None**" ]; then
  echo "You need to set the AWS_SECRET_ACCESS_KEY environment variable."
  exit 1
fi

if [ "${AWS_BUCKET}" = "**None**" ]; then
  echo "You need to set the AWS_BUCKET environment variable."
  exit 1
fi

if [ "${PREFIX}" = "**None**" ]; then
  echo "You need to set the PREFIX environment variable."
  exit 1
fi

if [ "${PGDUMP_DATABASE}" = "**None**" ]; then
  echo "You need to set the PGDUMP_DATABASE environment variable."
  exit 1
fi

if [ -z "${POSTGRES_ENV_POSTGRES_USER}" ]; then
  echo "You need to set the POSTGRES_ENV_POSTGRES_USER environment variable."
  exit 1
fi

if [ -z "${POSTGRES_PORT_5432_TCP_ADDR}" ]; then
  echo "You need to set the POSTGRES_PORT_5432_TCP_ADDR environment variable or link to a container named POSTGRES."
  exit 1
fi

if [ -z "${POSTGRES_PORT_5432_TCP_PORT}" ]; then
  echo "POSTGRES_PORT_5432_TCP_PORT not set, defaulting to 5432"
  POSTGRES_PORT_5432_TCP_PORT=5432
fi


if [ -z "${POSTGRES_ENV_POSTGRES_PASSWORD}" ]; then
  echo "POSTGRES_ENV_POSTGRES_PASSWORD not set, proceeding without a password"
else
  export PGPASSWORD=${POSTGRES_ENV_POSTGRES_PASSWORD}
fi

POSTGRES_HOST_OPTS="-h $POSTGRES_PORT_5432_TCP_ADDR -p $POSTGRES_PORT_5432_TCP_PORT -U $POSTGRES_ENV_POSTGRES_USER"

echo "Starting dump of ${PGDUMP_DATABASE} database from ${POSTGRES_PORT_5432_TCP_ADDR}..."

DUMPFILE="${PGDUMP_DATABASE}_$(date +%d-%b-%Y-%H-%M-%S).sql"
pg_dump $PGDUMP_OPTIONS $POSTGRES_HOST_OPTS $PGDUMP_DATABASE > $DUMPFILE
gzip $DUMPFILE

aws s3 cp $DUMPFILE.gz s3://$AWS_BUCKET/$PREFIX/$DUMPFILE.gz

echo "Done!"

exit 0
