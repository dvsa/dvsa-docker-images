FROM maven:3.9.6-amazoncorretto-11 as maven

# Update package lists and install necessary packages
RUN yum update -y && \
    yum install -y zip >= 3.0 unzip >= 6.0 python3 >= 3.7 aws-cli >= 2 && \
    yum clean all && \
    rm -rf /var/cache/yum
    