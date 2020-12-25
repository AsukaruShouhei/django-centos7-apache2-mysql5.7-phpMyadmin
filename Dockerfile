#
# Apache2.4、MySQL5.7、★Django,Python
#
# どのイメージをもとにするか
#FROM centos7
#RUN yum update -y && yum clean all
## Apacheインストール
#RUN yum install -y httpd
## Django,Python
#ENV PYTHONUNBUFFERED 1
#WORKDIR /code
#COPY requirements.txt /code/
#RUN pip install -r requirements.txt
# 一旦書き換え
FROM centos:centos7
ENV PYTHONUNBUFFERED 1
# docker-composeで設定したボリューム先に合わせる必要があります。
RUN mkdir /home/code
WORKDIR /home/code

# Python env
RUN yum install -y python3 python3-devel python3-libs httpd-devel gcc make mariadb-devel wget
RUN curl https://bootstrap.pypa.io/get-pip.py | python3

ADD requirements.txt /home/code/
# Apacheとwsgiを接続させる必要あり。Djangoはcgi系で動かします。
ADD wsgi.conf /etc/httpd/conf.d/
RUN pip install -r requirements.txt

RUN systemctl enable httpd

CMD ["/sbin/init"]
