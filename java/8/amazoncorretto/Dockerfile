FROM amazoncorretto:8

RUN yum update -y && \
    yum install -y httpd && \
    yum clean all

EXPOSE 80

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
