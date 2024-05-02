#!/bin/bash -e
apt update
apt install --no-install-recommends --no-install-suggests -y \
    git build-essential debhelper libusb-1.0-0-dev \
    librtlsdr-dev pkg-config \
    libncurses-dev zlib1g-dev libzstd-dev
READSB_WORK_DIR="${STAGE_WORK_DIR}/readsb/"
mkdir -p $READSB_WORK_DIR
pushd $READSB_WORK_DIR
rm -rf *
git clone --depth 20 https://github.com/wiedehopf/readsb.git 
pushd readsb
export DEB_BUILD_OPTIONS=noddebs
dpkg-buildpackage -b -Prtlsdr -ui -uc -us
popd
install -v -m 600 readsb_*.deb "${ROOTFS_DIR}/tmp/"

on_chroot << EOF
dpkg -i /tmp/readsb_*.deb
EOF
popd

install -v -m 600 files/blacklist-rtl8xxxu.conf		"${ROOTFS_DIR}/etc/modprobe.d/"
install -v -m 600 files/blacklist-dvb.conf		"${ROOTFS_DIR}/etc/modprobe.d/"
