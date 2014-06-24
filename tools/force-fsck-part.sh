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

function guestfish_fsck {
    local image="$1"; shift
    local device="$1"; shift

    guestfish <<EOF
add $image
run
e2fsck $device correct:true
EOF
}

# Guestfish aborts and returns a failure despite correct:true; we just
# ignore that and run one instance per partition (we'll fail later if
# repair did not succeed).
guestfish_fsck "$@" || true
