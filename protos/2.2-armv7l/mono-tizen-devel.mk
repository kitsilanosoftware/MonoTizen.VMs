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

TIZEN_VM__mono_tizen_devel_REPO_URL =					     \
	$(TIZEN_VM__2_2_armv7l_PREFIX_URL)/repos/tizen-base/armv7l/packages

TIZEN_VM__mono_tizen_devel_RPMS =			\
	armv7l/binutils-2.22-1.1.armv7l.rpm		\
	armv7l/bison-2.4.1-1.1.armv7l.rpm		\
	armv7l/cpp-4.5.3-1.2.armv7l.rpm			\
	armv7l/eglibc-devel-2.13-1.9.armv7l.rpm		\
	armv7l/eglibc-headers-2.13-1.9.armv7l.rpm	\
	armv7l/fdupes-1.40-42.1.armv7l.rpm		\
	armv7l/gcc-4.5.3-1.2.armv7l.rpm			\
	armv7l/gcc-c++-4.5.3-1.2.armv7l.rpm		\
	armv7l/gettext-tools-0.18.1.1-2.1.armv7l.rpm	\
	armv7l/kernel-headers-3.0.15-1.1.armv7l.rpm	\
	armv7l/libstdc++-devel-4.5.3-1.2.armv7l.rpm	\
	armv7l/libtool-2.2.6b-1.1.armv7l.rpm		\
	armv7l/m4-1.4.14-1.1.armv7l.rpm			\
	armv7l/make-3.81-1.1.armv7l.rpm			\
	armv7l/mpc-0.9-1.1.armv7l.rpm			\
	armv7l/mpfr-3.0.0-1.1.armv7l.rpm		\
	armv7l/patch-2.6.1.169-1.1.armv7l.rpm		\
	armv7l/rpm-build-4.9.1-4.1.armv7l.rpm		\
	armv7l/xz-lzma-compat-5.0.3-1.1.armv7l.rpm	\
	armv7l/zlib-devel-1.2.5-2.5.armv7l.rpm		\
	noarch/autoconf-2.68-1.1.noarch.rpm		\
	noarch/automake-1.11.1-3.1.noarch.rpm

TIZEN_VM__mono_tizen_devel_CACHE =		\
	var/cache/zypp/packages/Tizen-base
