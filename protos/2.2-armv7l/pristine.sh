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

function guestfish_pristine {
    local image="$1"; shift
    local platform="$1"; shift
    local ums="$1"; shift
    local data="$1"; shift

    # A couple of useful constants.
    local gb_bytes="$((1024 * 1024 * 1024))"
    local gb_sectors="$(($gb_bytes / 512))"

    # Our partitions, in sectors.  We start where fdisk usually
    # starts, and create "big enough" partitions.  KLUDGE: We also
    # create a "sacrificial" partition because one of the bootup
    # scripts wants to truncate it--for some reason.
    local start_1='2048'
    local start_2="$(($start_1 + 10 * $gb_sectors))"
    local start_3="$(($start_2 + 2 * $gb_sectors))"
    local start_4="$(($start_3 + 2 * $gb_sectors))"

    guestfish <<EOF
# Target image
add $image
# Source partition images
add-ro $platform
add-ro $ums
add-ro $data
# Start VM
run
# Partitioning
part-init /dev/sda msdos
part-add /dev/sda p $start_1 $(($start_2 - 1))
part-add /dev/sda p $start_2 $(($start_3 - 1))
part-add /dev/sda p $start_3 $(($start_4 - 1))
part-add /dev/sda p $start_4 -1
# Imaging
copy-device-to-device /dev/sdb /dev/sda1 sparse:true
copy-device-to-device /dev/sdc /dev/sda2 sparse:true
copy-device-to-device /dev/sdd /dev/sda3 sparse:true
EOF
}

guestfish_pristine "$@"
