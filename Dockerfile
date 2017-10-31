FROM centos:7.4.1708
MAINTAINER WANG Chao <wcwxyz@gmail.com>
RUN yum -y update && yum install -y epel-release && yum -y install mock nosync && yum clean all
RUN useradd -u 1000 builder && usermod -a -G mock builder

VOLUME /rpmbuild

RUN install -g mock -m 2775 -d /rpmbuild/cache/mock
RUN echo "config_opts['cache_topdir'] = '/rpmbuild/cache/mock'" >> /etc/mock/site-defaults.cfg
RUN echo "config_opts['nosync'] = True" >> /etc/mock/site-defaults.cfg

ADD ucloud-epel-6-x86_64.cfg /etc/mock/ucloud-epel-6-x86_64.cfg
ADD ucloud-epel-7-x86_64.cfg /etc/mock/ucloud-epel-7-x86_64.cfg
ADD ucloud-gcc49-epel-6-x86_64.cfg /etc/mock/ucloud-gcc49-epel-6-x86_64.cfg
ADD ucloud-gcc49-python27-epel-6-x86_64.cfg /etc/mock/ucloud-gcc49-python27-epel-6-x86_64.cfg

ADD build-rpm.sh /build-rpm.sh
RUN chmod +x /build-rpm.sh

USER builder
ENV HOME=/home/builder
CMD /build-rpm.sh
