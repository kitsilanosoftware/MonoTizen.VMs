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

include kernels/2.2-armv7l/rules.mk

TIZEN_VM__2_2_armv7l_home_developer_ALLOC = 1500M

$(TMP)/2.2-armv7l-home-developer/start.in:			\
		protos/2.2-armv7l/start.sh.in
	@mkdir -p $(dir $@)
	cp $< $@.tmp
	@mv $@.tmp $@

$(DATA)/images/2.2-armv7l-home-developer/base.qcow2:	\
		$(DATA)/images/2.2-armv7l/base.qcow2
	@mkdir -p $(dir $@)
	@mv $@.tmp $@
	rm -f $@
	cd $(dir $@) && qemu-img create -f qcow2		\
		-o backing_file=../2.2-armv7l/$(notdir $<)	\
		$(notdir $@).tmp
	chmod a-w $@.tmp
	@mv $@.tmp $@
