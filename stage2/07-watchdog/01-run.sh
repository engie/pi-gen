#!/bin/bash
install -v -m 600 files/99-watchdog.rules	"${ROOTFS_DIR}/etc/udev/rules.d/"

on_chroot << EOF
groupadd -f watchdog
usermod -aG watchdog finalapproach
EOF
