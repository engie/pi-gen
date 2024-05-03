#!/bin/bash -e
apt update
apt install --no-install-recommends --no-install-suggests -y \
    git build-essential debhelper libusb-1.0-0-dev \
    pkg-config libusb-1.0-0-dev cmake \
    libncurses-dev zlib1g-dev libzstd-dev
READSB_WORK_DIR="${STAGE_WORK_DIR}/readsb/"
mkdir -p $READSB_WORK_DIR
pushd $READSB_WORK_DIR
rm -rf *

git clone https://github.com/rtlsdrblog/rtl-sdr-blog
pushd rtl-sdr-blog
dpkg-buildpackage -b --no-sign
popd

git clone --depth 20 https://github.com/wiedehopf/readsb.git 
pushd readsb
export DEB_BUILD_OPTIONS=noddebs
dpkg-buildpackage -b -Prtlsdr -ui -uc -us
popd

install -v -m 600 readsb_*.deb "${ROOTFS_DIR}/tmp/"
install -v -m 600 librtlsdr0_*.deb "${ROOTFS_DIR}/tmp/"
install -v -m 600 librtlsdr-dev_*.deb "${ROOTFS_DIR}/tmp/"
install -v -m 600 rtl-sdr_*.deb "${ROOTFS_DIR}/tmp/"

on_chroot << EOF
dpkg -i /tmp/librtlsdr0_*.deb
dpkg -i /tmp/rtl-sdr_*.deb
dpkg -i /tmp/readsb_*.deb
EOF
popd

install -v -m 600 files/blacklist-rtl8xxxu.conf		"${ROOTFS_DIR}/etc/modprobe.d/"
install -v -m 600 files/blacklist-dvb.conf		"${ROOTFS_DIR}/etc/modprobe.d/"
install -v -m 600 files/readsb				"${ROOTFS_DIR}/etc/default/readsb"
