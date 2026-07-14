ARG AMAZON_LINUX_TAG=2
FROM amazonlinux:$AMAZON_LINUX_TAG
RUN yum -y install mailx nc jq unzip openssh-clients curl
RUN (echo '[ZABBIXRepo]';echo 'name = ZABBIX Repo'; echo 'baseurl = https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/';echo 'sslverify=0';echo 'gpgcheck=0')>/etc/yum.repos.d/zabbix.repo 
RUN yum clean all &&  rm -rf /var/cache/yum && yum -y install zabbix-sender 
RUN yum update -y
RUN mkdir -p batchtransfer/tmp
RUN cd batchtransfer/tmp && yum -y remove awscli && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip &&  ./aws/install && cd .. && rm -Rf tmp 
COPY SFTP_TO_S3.sh batchtransfer/ 
COPY S3_TO_SFTP.sh batchtransfer/ 
RUN rm -Rf /etc/yum.repos.d/zabbix.repo
RUN chmod 700 batchtransfer/*.sh
CMD ["/bin/bash"]