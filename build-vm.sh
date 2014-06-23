#!/bin/bash

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

BASE="$(dirname "$0")"

# Source host-based environment files

proto=

if test "$1" = '--proto' -a -n "$2"; then
    proto="$2"
    source "$BASE/protos/$proto/build-vm.env"
    shift 2
fi

if test "$1" = '--force-download'; then
    rm -rf "$BASE/data/$proto"
fi

downloads_dir="$BASE/data/$proto/downloads"
base_img="$BASE/data/$proto/base.qcow2"

if ! test -d "$downloads_dir"; then
    mkdir -p "$downloads_dir"
    mono_vm_download "$downloads_dir"
fi

if ! test "$1" = '--no-verify'; then
    md5sum -c "$BASE/protos/$proto/downloads.md5sums"
fi

tmp_dir="$(mktemp -d "$BASE/tmp/$proto.XXXXXX")"
trap "rm -rf '$tmp_dir'" EXIT

if ! test -f "$base_img"; then
    mkdir "$tmp_dir/unpack"
    mono_vm_unpack "$downloads_dir" "$tmp_dir/unpack"
    mkdir "$tmp_dir/disk"
    mono_vm_make_disk "$downloads_dir" "$tmp_dir/unpack" "$tmp_dir/disk" 'base'
    if ! test -f "$base_img"; then
        echo "Image $base_img was not created?" >&2
        exit 1
    fi
fi

echo 'TODO: Finish implementation.' >&2
false

if test -n "$*"; then
    echo "Unknown args $*." >&2
    false
fi
