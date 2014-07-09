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

    guestfish <<EOF
# Target image
add $image
# Start VM
run
# Spread FSes to fill their partitions
resize2fs /dev/sda
# Mount root
mount /dev/sda /
tar-in $patched_tar /
# TODO: Migrate to patches of sort.
rm /etc/nologin
EOF
}

guestfish_finalize "$@"
