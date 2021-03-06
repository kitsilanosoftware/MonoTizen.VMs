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

# No set -e in source-able files!
#set -e

PREFIX="$HOME/opt/distcc"

# Add hosts to ~/.distcc/hosts!
unset DISTCC_HOSTS

if test -x "$PREFIX/bin/distcc"; then
    PATH="$PREFIX/bin:$PATH"
    CC="$PREFIX/bin/gcc"
    CXX="$PREFIX/bin/g++"

    export CC CXX
fi
