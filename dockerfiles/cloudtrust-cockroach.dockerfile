FROM cloudtrust-baseimage:f27

ARG cockroach_service_git_tag
ARG cockroach_release
ARG config_git_tag
ARG config_repo

RUN dnf -y install ncurses-compat-libs.x86_64 nginx && \
    dnf clean all

RUN groupadd cockroach && \
    useradd -m -s /sbin/nologin -g cockroach cockroach && \
    install -d -v -m755 /opt/cockroach -o root -g root && \
    install -d -v -m755 /etc/cockroach -o cockroach -g cockroach

WORKDIR /cloudtrust
RUN git clone git@github.com:cloudtrust/cockroach-service.git && \
    git clone ${config_repo} ./config

WORKDIR /cloudtrust/cockroach-service
RUN git checkout ${cockroach_service_git_tag}

WORKDIR /cloudtrust/cockroach-service
# Install regular stuff. Systemd, monit...
RUN install -v -m0644 deploy/etc/security/limits.d/* /etc/security/limits.d/ && \
    install -v -m0644 deploy/etc/monit.d/* /etc/monit.d/ && \
    install -v -m0644 -D deploy/etc/nginx/conf.d/* /etc/nginx/conf.d/ && \
    install -v -m0644 deploy/etc/nginx/nginx.conf /etc/nginx/nginx.conf && \
    install -v -m0644 deploy/etc/nginx/mime.types /etc/nginx/mime.types && \
    install -v -o root -g root -m 644 -d /etc/systemd/system/nginx.service.d && \
    install -v -o root -g root -m 644 deploy/etc/systemd/system/nginx.service.d/limit.conf /etc/systemd/system/nginx.service.d/limit.conf

##
##  COCKROACH
##

WORKDIR /cloudtrust
RUN wget ${cockroach_release} -O cockroach.tgz && \
    mkdir cockroach && \
    tar -xvzf cockroach.tgz -C cockroach --strip-components 1 && \
    install -v -m0755 cockroach/cockroach /opt/cockroach/cockroach && \
    rm cockroach.tgz && \
    rm -rf cockroach/

WORKDIR /cloudtrust/cockroach-service
RUN install -v -o cockroach -g cockroach -m 644 deploy/etc/systemd/system/cockroach.service /etc/systemd/system/cockroach.service && \
    install -d -v -o root -g root -m 644 /etc/systemd/system/cockroach.service.d && \
    install -v -o root -g root -m 644 deploy/etc/systemd/system/cockroach.service.d/limit.conf /etc/systemd/system/cockroach.service.d/limit.conf && \
    install -d -v -o cockroach -g cockroach -m 744 /var/lib/cockroach 

##
##  CONFIG
##

WORKDIR /cloudtrust/config
RUN git checkout ${config_git_tag}

WORKDIR /cloudtrust/config
# Nothing yet


# Enable services
RUN systemctl enable cockroach.service && \
    systemctl enable nginx.service && \
    systemctl enable monit.service

VOLUME ["/var/lib/cockroach"]
