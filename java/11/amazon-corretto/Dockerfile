FROM maven:3.9.6-amazoncorretto-11 as maven

# Update package lists and install necessary packages
RUN yum update -y && \
    yum install -y zip-3.* unzip-6.* python3-3.* && \
    yum clean all && \
    rm -rf /var/cache/yum

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update && \
    rm -f awscliv2.zip
    