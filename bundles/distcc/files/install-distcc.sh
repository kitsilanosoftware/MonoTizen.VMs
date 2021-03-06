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

PREFIX="$HOME/opt/distcc"
BASE="$(dirname "$0")"

build_arg=
if test -r /etc/rpm/platform; then
    build_arg="--build=$(cat /etc/rpm/platform)"
fi

cd "$HOME/sources/distcc"
./autogen.sh
./configure "$build_arg" --prefix="$PREFIX" --disable-Werror
make distcc
make install-programs bin_PROGRAMS=distcc

for cc_path in /usr/bin/*gcc* /usr/bin/*g++*; do
    cc_name="$(basename "$cc_path")"

    (
        cd "$PREFIX/bin"
        ln -s 'distcc' "$cc_name"
    ) || exit 1
done

echo
echo 'Installed.  Add the hosts to ~/.distcc/hosts, and source'
echo "$BASE/setup-distcc.sh before starting the first build."
echo
