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

function guestfish_alloc {
    local image="$1"; shift
    local size="$1"; shift

    guestfish <<EOF
add $image
run
mount /dev/sda1 /
fallocate64 /home/developer/data.filler $size
rm /home/developer/data.filler
EOF
}

guestfish_alloc "$@"
