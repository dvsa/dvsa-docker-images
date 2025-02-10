FROM amazoncorretto:8

RUN yum update -y && \
    yum install -y httpd-2.4.62 && \
    yum clean all

RUN groupadd -r httpd && useradd -r -g httpd httpd

RUN chown -R httpd:httpd /var/www /etc/httpd /var/run/httpd /var/log/httpd

USER httpd

EXPOSE 80

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
