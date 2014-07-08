#!/bin/bash
#
# Copyright 2014 Kitsilano Software Inc.
#
# This file is part of MonoTizen.
#
# MonoTizen is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# MonoTizen is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with MonoTizen.  If not, see <http://www.gnu.org/licenses/>.

set -e

function guestfish_finalize {
    local image="$1"; shift
    local patched_tar="$1"; shift
    local modules_tar="$1"; shift

    guestfish <<EOF
# Target image
add $image
# Start VM
run
# Spread FSes to fill their partitions
resize2fs /dev/sda1
resize2fs /dev/sda2
resize2fs /dev/sda3
# Mount root
mount /dev/sda1 /
tar-in $patched_tar /
tar-in $modules_tar /lib/modules
# TODO: Migrate to patches of sort.
rm /etc/nologin
rm /etc/.pwd.lock
rm /usr/lib/systemd/system/basic.target.wants/smack-default-labeling.service
rm /usr/lib/systemd/system/basic.target.wants/smack-device-labeling.service
rm /usr/lib/systemd/system/basic.target.wants/smack.service
rm /usr/lib/systemd/system/local-fs.target.wants/boot.mount
rm /usr/lib/systemd/system/local-fs.target.wants/csa.mount
rm /usr/lib/systemd/system/local-fs.target.wants/resize2fs-root.service
rm /usr/lib/systemd/system/local-fs.target.wants/smack.mount
rm /usr/lib/systemd/system/multi-user.target.wants/alarm-server.service
rm /usr/lib/systemd/system/multi-user.target.wants/avsystem.service
rm /usr/lib/systemd/system/multi-user.target.wants/bluetooth-address.service
rm /usr/lib/systemd/system/multi-user.target.wants/clipboard.service
rm /usr/lib/systemd/system/multi-user.target.wants/dlog-main.service
rm /usr/lib/systemd/system/multi-user.target.wants/dlog-radio.service
rm /usr/lib/systemd/system/multi-user.target.wants/gps-manager.service
rm /usr/lib/systemd/system/multi-user.target.wants/gstreamer.service
rm /usr/lib/systemd/system/multi-user.target.wants/media-server.service
rm /usr/lib/systemd/system/multi-user.target.wants/msg-service.service
rm /usr/lib/systemd/system/multi-user.target.wants/nfc-manager.service
rm /usr/lib/systemd/system/multi-user.target.wants/oma-dm-agent.service
rm /usr/lib/systemd/system/multi-user.target.wants/osp-tmpdir-setup.service
rm /usr/lib/systemd/system/multi-user.target.wants/pulseaudio.service
rm /usr/lib/systemd/system/multi-user.target.wants/secure-storage.service
rm /usr/lib/systemd/system/multi-user.target.wants/security-server.service
rm /usr/lib/systemd/system/multi-user.target.wants/sensor-framework.service
rm /usr/lib/systemd/system/multi-user.target.wants/smack-default-labeling.service
rm /usr/lib/systemd/system/multi-user.target.wants/sound-server.path
rm /usr/lib/systemd/system/multi-user.target.wants/systemd-ask-password-wall.path
rm /usr/lib/systemd/system/multi-user.target.wants/telephony.service
rm /usr/lib/systemd/system/multi-user.target.wants/wrt-security-daemon.service
ln-s /usr/lib/systemd/system/sshd.service /usr/lib/systemd/system/multi-user.target.wants/sshd.service
EOF
}

guestfish_finalize "$@"
