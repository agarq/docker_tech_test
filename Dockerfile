FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.utf8
ENV LC_ALL en_US.utf8

RUN apt-get update -y && apt-get upgrade -y 

RUN apt-get install -y git

RUN apt-get install -y openjdk-11-jre-headless

RUN apt-get install -y apache2

RUN apt-get install -y maven \
    apt-transport-https \
    ca-certificates \
    curl gnupg-agent \
    software-properties-common \
    wget \
    locales && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
RUN apt-get install -y code

RUN curl -SL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel Current --install-dir /usr/share/dotnet && \
    ln -s /usr/share/dotnet/dotnet /usr/local/bin/

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main" >> /etc/apt/sources.list.d/pgdg.list \
    && apt-get update \
    && apt-get install -y postgresql-11 postgresql-contrib-11

RUN rm -rf /var/lib/apt/lists/*

COPY ./helloworld/ /var/www/html/
EXPOSE 80

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
