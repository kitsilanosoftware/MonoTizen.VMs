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

TIZEN_VM__3_0pre_i586_PREFIX_URL = \
	http://download.tizen.org/releases/daily/tizen/common/tizen_20140704.1

TIZEN_VM__mono_tizen_devel_REPO_URL = \
	$(TIZEN_VM__3_0pre_i586_PREFIX_URL)/repos/emulator32-wayland/packages

TIZEN_VM__mono_tizen_devel_RPMS =			\
	i686/binutils-2.23.1-5.1.i686.rpm		\
	i686/bison-2.6.2-5.1.i686.rpm			\
	i686/cpp-4.8-4.1.i686.rpm			\
	i686/cpp48-4.8.2-5.1.i686.rpm			\
	i686/fdupes-1.40-4.1.i686.rpm			\
	i686/gcc-4.8-4.1.i686.rpm			\
	i686/gcc-c++-4.8-4.1.i686.rpm			\
	i686/gcc48-4.8.2-5.1.i686.rpm			\
	i686/gcc48-c++-4.8.2-5.1.i686.rpm		\
	i686/gettext-runtime-0.18.3.2-4.1.i686.rpm	\
	i686/gettext-tools-0.18.3.2-4.1.i686.rpm	\
	i686/glibc-devel-2.18-4.3.i686.rpm		\
	i686/libasan-4.8.2-5.1.i686.rpm			\
	i686/libatomic-4.8.2-5.1.i686.rpm		\
	i686/libgomp-4.8.2-5.1.i686.rpm			\
	i686/libitm-4.8.2-5.1.i686.rpm			\
	i686/libmpc-1.0-4.1.i686.rpm			\
	i686/libmpfr-3.1.1-4.1.i686.rpm			\
	i686/libstdc++48-devel-4.8.2-5.1.i686.rpm	\
	i686/libtool-2.4.2-4.1.i686.rpm			\
	i686/m4-1.4.16-4.1.i686.rpm			\
	i686/make-3.82-4.1.i686.rpm			\
	i686/rpm-build-4.11.0.1-13.1.i686.rpm		\
	i686/zlib-devel-1.2.7-4.1.i686.rpm		\
	noarch/autoconf-2.69-5.1.noarch.rpm		\
	noarch/automake-1.12.1-5.1.noarch.rpm		\
	noarch/linux-glibc-devel-3.10-4.1.noarch.rpm

# KLUDGE: This has nothing to do here; TODO: modularize.
TIZEN_VM__mono_tizen_devel_RPMS +=		\
	$(if $(filter buildbot,$(VM_BUNDLES)),	\
		)
