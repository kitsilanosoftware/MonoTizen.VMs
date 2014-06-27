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

PRELOAD_DIR='/root/rpms/pre'

if ls "$PRELOAD_DIR"/*/*.rpm > /dev/null 2>&1; then
    rpm_flags='-i'
    if test -f "$PRELOAD_DIR/i686/eglibc-2.13-2.16.i686.rpm"; then
        # KLUDGE: We don't have an exact match between the emulator
        # image and the upstream packages, and have to act nasty.
        rpm_flags='-i --nodeps --ignorearch --force'
    fi

    rpm $rpm_flags "$PRELOAD_DIR"/*/*.rpm && rm -rf "$PRELOAD_DIR"
fi

RPMS="$(cat /root/rpms/install.d/*.list)"

if test -n "$RPMS"; then
    zypper -n refresh
    zypper -n install $RPMS
fi
