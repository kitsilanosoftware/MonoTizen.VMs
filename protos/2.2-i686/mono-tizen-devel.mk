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

TIZEN_VM__2_2_i686_PREFIX_URL =					\
	http://download.tizen.org/releases/2.2.1/tizen-2.2_20131107.3

TIZEN_VM__mono_tizen_devel_REPO_URL =					\
	$(TIZEN_VM__2_2_i686_PREFIX_URL)/repos/tizen-base/ia32/packages

TIZEN_VM__mono_tizen_devel_RPMS =			\
	i586/binutils-2.22-1.10.i586.rpm		\
	i586/bison-2.4.1-1.11.i586.rpm			\
	i586/cloog-0.15.9-1.28.i586.rpm			\
	i586/cloog-ppl-0.15.9-1.28.i586.rpm		\
	i586/cpp-4.5.3-2.13.i586.rpm			\
	i586/fdupes-1.40-42.7.i586.rpm			\
	i586/gcc-4.5.3-2.13.i586.rpm			\
	i586/gcc-c++-4.5.3-2.13.i586.rpm		\
	i586/gettext-tools-0.18.1.1-3.15.i586.rpm	\
	i586/kernel-headers-3.0.15-1.7.i586.rpm		\
	i586/libgomp-4.5.3-2.13.i586.rpm		\
	i586/libstdc++-4.5.3-2.13.i586.rpm		\
	i586/libstdc++-devel-4.5.3-2.13.i586.rpm	\
	i586/libtool-2.2.6b-2.14.i586.rpm		\
	i586/m4-1.4.14-1.8.i586.rpm			\
	i586/make-3.81-1.7.i586.rpm			\
	i586/minizip-1.2.5-3.17.i586.rpm		\
	i586/mpc-0.9-1.15.i586.rpm			\
	i586/mpfr-3.0.0-1.12.i586.rpm			\
	i586/patch-2.6.1.169-1.6.i586.rpm		\
	i586/ppl-0.10.2-10.14.i586.rpm			\
	i586/rpm-build-4.9.1-4.10.i586.rpm		\
	i586/xz-5.0.3-2.17.i586.rpm			\
	i586/xz-libs-5.0.3-2.17.i586.rpm		\
	i586/xz-lzma-compat-5.0.3-2.17.i586.rpm		\
	i586/zlib-1.2.5-3.17.i586.rpm			\
	i586/zlib-devel-1.2.5-3.17.i586.rpm		\
	i686/eglibc-2.13-2.16.i686.rpm			\
	i686/eglibc-common-2.13-2.16.i686.rpm		\
	i686/eglibc-devel-2.13-2.16.i686.rpm		\
	i686/eglibc-headers-2.13-2.16.i686.rpm		\
	noarch/autoconf-2.68-1.10.noarch.rpm		\
	noarch/automake-1.11.1-3.12.noarch.rpm

# KLUDGE: This has nothing to do here; TODO: modularize.
TIZEN_VM__mono_tizen_devel_RPMS +=					\
	$(if $(filter buildbot,$(VM_BUNDLES)),				\
		i586/python-devel-2.7.1-2.8.i586.rpm			\
		noarch/python-setuptools-devel-0.6c11-2.8.noarch.rpm	\
		noarch/python-setuptools-0.6c11-2.8.noarch.rpm)
