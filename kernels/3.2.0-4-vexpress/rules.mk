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

TIZEN_VM__3_2_0_4_vexpress_FILES =		\
	vmlinuz-3.2.0-4-vexpress		\
	initrd.img-3.2.0-4-vexpress

TIZEN_VM__3_2_0_4_vexpress_BASE_URL =			\
	http://people.debian.org/~aurel32/qemu/armhf

$(DOWNLOADS)/3.2.0-4-vexpress/stamp:				\
		kernels/3.2.0-4-vexpress/downloads.md5sums
	@mkdir -p $(dir $@) $(TMP)/3.2.0-4-vexpress
	for F in $(TIZEN_VM__3_2_0_4_vexpress_FILES); do		\
		wget -O $(TMP)/3.2.0-4-vexpress/$$F			\
			$(TIZEN_VM__3_2_0_4_vexpress_BASE_URL)/$$F;	\
	done
	cd $(TMP)/3.2.0-4-vexpress && md5sum -c --strict		\
		 $(PWD)/kernels/3.2.0-4-vexpress/downloads.md5sums
	for F in $(TIZEN_VM__3_2_0_4_vexpress_FILES); do	\
		mv $(TMP)/3.2.0-4-vexpress/$$F $(dir $@);	\
	done
	touch $@
