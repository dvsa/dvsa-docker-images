FROM maven:3.9.6-amazoncorretto-11 as maven

ARG PROXYHOST=""
ARG PROXYPORT=""
ARG NOPROXY=""
ARG NOPROXYJAVA=""

# Update package lists and install necessary packages
RUN yum update -y && \
    yum install -y zip unzip python3 aws-cli
    