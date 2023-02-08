# Dockerfile for getting DLS RHEL7 dev environment working in a container
# hosted on RHEL8
#
# This is a stopgap so that we can use effort to promote the
# kubernetes model https://github.com/dls-controls instead of spending
# effort in rebuilding our toolchain for RHEL8

FROM centos:7

# environment
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LC_CTYPE=en_US.UTF-8
ENV MODULEPATH=/etc/scl/modulefiles:/etc/scl/modulefiles:/etc/scl/modulefiles:/usr/share/Modules/modulefiles:/etc/modulefiles:/usr/share/modulefiles:/dls_sw/apps/Modules/modulefiles:/dls_sw/etc/modulefiles:/home/hgv27681/privatemodules:/dls_sw/prod/tools/RHEL8-x86_64/defaults/modulefiles

# make QT not complain
ENV QT_X11_NO_MITSHM=1
ENV LIBGL_ALWAYS_INDIRECT=1

RUN yum update -y && \
    # dev tools and libraries
    yum groupinstall -y "Development Tools" && \
    yum install -y glibc.i686 redhat-lsb-core libusbx net-snmp-libs environment-modules git2u net-tools screen cmake lapack-devel readline-devel pcre-devel boost-devel libpcap-devel numactl-libs vim dbus-x11 bind-utils libssh2-devel xorg-x11-server-Xvfb \
    # edm dependencies
    epel-release giflib-devel libXmu-devel libpng-devel libXtst-devel zlib-devel xorg-x11-proto-devel motif-devel libX11-devel libXp-devel libXpm-devel libtirpc-devel \
    # areaDetector dependencies
    libxml2-devel libjpeg-turbo-devel libtiff-devel \
    # Odin dependencies
    hdf5-devel zeromq-devel librdkafka-devel \
    # QT4 dependencies
    pyqt4-devel PackageKit-gtk3-module libcanberra-gtk2 mesa-dri-drivers.x86_64 xcb-util xcb-util-devel libxcb.x86_64 libxkbcommon-x11 \
    # dls-remote-desktop-support
    xfreerdp zenity \
    # useful tools
    sudo meld tk dejavu-sans-mono-fonts gnome-terminal xterm xmessage evince eog firefox java openldap-clients && \
    # These packages are not found in the initial install so try again
    yum install -y zeromq-devel git2u meld && \
    # clean up caches
    yum clean all && \
    # nasty hack to avoid overlay filesystem problems with --userns=keep-id
    # hopefully can be removed when this PR is released and deployed at DLS
    # https://github.com/containers/fuse-overlayfs/pull/381
    rm -fr /var/lib/yum/yumdb/*

# full sudo rights inside the container
COPY /sudoers /etc/sudoers

# Workaround to ensure all locales are available
RUN sed -i "/override_install_langs=en_US/d" /etc/yum.conf
RUN yum reinstall -y glibc-common

# set container time to BST
RUN ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime

# latest git from the endpoint repo https://computingforgeeks.com/install-git-2-on-centos-7/
RUN sudo yum remove -y git git-* && \
    # libcurl-devel for git-remote-https
    yum -y install libcurl-devel && \
    sudo yum -y install https://packages.endpointdev.com/rhel/7/os/x86_64/endpoint-repo.x86_64.rpm && \
    sudo yum -y install git
