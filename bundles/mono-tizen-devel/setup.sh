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

function guestfish_bundle_setup {
    local image="$1"; shift
    local proto_mount_guestfish="$1"; shift

    (
        cat <<EOF
add $image
run
EOF
        cat "$proto_mount_guestfish"
        cat <<EOF
tar-in tmp/mono-tizen-devel.tar /
EOF
    ) | guestfish

    status=${PIPESTATUS[0]}
    if test $status -ne 0; then
        return $status
    fi
}

guestfish_bundle_setup "$@"
