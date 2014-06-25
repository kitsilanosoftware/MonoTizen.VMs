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

cd "$BASE"

PROTO="$1"; shift
VM_NAME="$1"; shift

if ! test -d "protos/$PROTO"; then
    echo "Unknown prototype $PROTO." >&2
    false
fi

if test -d "data/vms/$VM_NAME"; then
    echo "VM $VM_NAME already exists." >&2
    false
fi

exec make vm "NAME=$VM_NAME" "PROTO=$PROTO" "$@"
