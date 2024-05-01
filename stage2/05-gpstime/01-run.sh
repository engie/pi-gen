#!/bin/bash -e

install -v -m 600 files/gpsd		"${ROOTFS_DIR}/etc/default/"
install -v -m 600 files/gps.conf	"${ROOTFS_DIR}/etc/chrony/conf.d/"
