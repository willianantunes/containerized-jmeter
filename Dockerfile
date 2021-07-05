ARG JMETER_VERSION="5.4"
ARG JMETER_SHORTER_FILE_NAME="apache-jmeter"
ARG JMETER_FILE_NAME="${JMETER_SHORTER_FILE_NAME}-${JMETER_VERSION}"
ARG JMETER_DOWNLOAD_URL="https://archive.apache.org/dist/jmeter/binaries/${JMETER_FILE_NAME}.tgz"

FROM adoptopenjdk/openjdk16:jdk-16.0.1_9-alpine

# Basic dependencies
RUN apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	&& update-ca-certificates \
	&& apk add --no-cache --update tzdata curl icu-libs unzip bash nss \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies

# Now we set up the JMeter
WORKDIR /app

RUN addgroup -g 1000 -S customgroup \
    && adduser -S -u 1000 customuser -G customgroup \
    && chown -R 1000:1000 /app && chown -R 1000:1000 /opt

USER customuser

ARG JMETER_VERSION
ARG JMETER_FILE_NAME
ARG JMETER_DOWNLOAD_URL

RUN curl -O ${JMETER_DOWNLOAD_URL} \
    && tar -xzf ${JMETER_FILE_NAME}.tgz --directory /opt \
    && rm -rf ${JMETER_FILE_NAME}.tgz

ENV PATH="${PATH}:/opt/${JMETER_FILE_NAME}/bin"
