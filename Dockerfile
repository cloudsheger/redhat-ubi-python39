# Use Red Hat Universal Base Image (UBI) as the base image
FROM registry.access.redhat.com/ubi9/python-39

# Set necessary environment variables
ARG APP_ROOT=/opt/app-root
ENV APP_ROOT=$APP_ROOT \
    HOME=${APP_ROOT}/src \
    PATH=$HOME/.local/bin/:/opt/app-root/src/bin:/opt/app-root/bin:$PATH \
    PYTHON_VERSION=3.9 \
    PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    PIP_NO_CACHE_DIR=off \
    LANG=en_US.UTF-8

# Enable the virtual Python environment and default interactive and non-interactive shell environment
ENV BASH_ENV=${APP_ROOT}/etc/py_enable \
    ENV=${APP_ROOT}/etc/py_enable \
    PROMPT_COMMAND=". ${APP_ROOT}/etc/py_enable"

# Copy extra files to the image
COPY ./scripts /

# Switch to root user for commands requiring root privileges
USER root

# Install necessary packages with root privileges
RUN INSTALL_PKGS="python3 python3-devel python3-setuptools python3-pip" && \
    dnf -y upgrade-minimal --setopt=tsflags=nodocs --security && \
    dnf -y --setopt=tsflags=nodocs install $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    dnf -y clean all --enablerepo="*" && \
    rm -rf /var/cache/dnf && \
    pip3 install --upgrade setuptools

# Create a Python virtual environment and set permissions
RUN python3.9 -m venv ${APP_ROOT} && \
    chmod -R 0750 ${APP_ROOT}

# Switch back to the non-root user
USER 1001

# Set permissions and user creation if not exists
RUN fix-permissions ${APP_ROOT} -P && \
    rpm-file-permissions && \
    getent passwd default > /dev/null || (groupadd -g 1001 default && \
    useradd -u 1001 -r -g 1001 -d ${HOME} -s /sbin/nologin \
    -c "Default Application User" default && \
    chown -R default:default ${APP_ROOT} && \
    chmod -R 0750 ${APP_ROOT} && \
    df --local -P | awk '{if (NR!=1) print $6}' \
        | xargs -I '{}' find '{}' -xdev -type d \
        \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null \
        | xargs -I '{}' chmod a+t && \
    chmod 755 \
        /usr/bin/container-entrypoint \
        /usr/bin/fix-permissions \
        /usr/bin/rpm-file-permissions)

# Set the working directory
WORKDIR ${HOME}
