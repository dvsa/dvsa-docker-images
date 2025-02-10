FROM amazoncorretto:8

RUN yum update -y && \
    yum install -y httpd-2.4.62 && \
    yum clean all

EXPOSE 80

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
