#!/bin/bash

on_chroot << EOF
if ! id -u finalapproach >/dev/null 2>&1; then
	adduser --disabled-password --comment "" finalapproach
fi
EOF

REPO="${ROOTFS_DIR}/home/finalapproach/finalapproach"
if [ ! -d "${REPO}" ]; then
	git clone https://github.com/engie/finalapproach.git $REPO
fi

on_chroot << EOF
pushd /home/finalapproach/finalapproach

mkdir -p venv
rm -rf venv/*
python3 -m venv venv
source venv/bin/activate

pip install -r requirements.txt

deactivate
popd
EOF

install -v -m 600 files/finalapproach.service "${ROOTFS_DIR}/etc/systemd/system/"

on_chroot << EOF
systemctl enable finalapproach
EOF
