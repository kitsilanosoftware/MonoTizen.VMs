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

TIZEN_VM__2_2_armv7l_TARBALL = tizen-2.2_20130719.3_RD-PQ.tar.gz
TIZEN_VM__2_2_armv7l_BASE_URL = http://download.tizen.org/releases/2.2/tizen-2.2_20130719.3/images/RD-PQ

TIZEN_VM__2_2_armv7l_PATCHES = $(wildcard protos/2.2-armv7l/patches/*.patch)

include kernels/3.2.0-4-vexpress/rules.mk

2.2-armv7l-kernel: $(DOWNLOADS)/3.2.0-4-vexpress/stamp

$(TMP)/2.2-armv7l/start.in:			\
		protos/2.2-armv7l/start.sh.in
	@mkdir -p $(dir $@)
	cp $< $@.tmp
	@mv $@.tmp $@

$(DOWNLOADS)/2.2-armv7l/$(TIZEN_VM__2_2_armv7l_TARBALL):		      \
		$(DOWNLOADS)/2.2-armv7l/$(TIZEN_VM__2_2_armv7l_TARBALL).stamp
	touch $@

$(DOWNLOADS)/2.2-armv7l/$(TIZEN_VM__2_2_armv7l_TARBALL).stamp:	\
		protos/2.2-armv7l/downloads.md5sums
	@mkdir -p $(dir $@) $(TMP)/2.2-armv7l
	wget -O $(TMP)/2.2-armv7l/$(TIZEN_VM__2_2_armv7l_TARBALL) \
		$(TIZEN_VM__2_2_armv7l_BASE_URL)/$(TIZEN_VM__2_2_armv7l_TARBALL)
	cd $(TMP)/2.2-armv7l && md5sum -c --strict		\
		$(PWD)/protos/2.2-armv7l/downloads.md5sums
	mv $(TMP)/2.2-armv7l/$(TIZEN_VM__2_2_armv7l_TARBALL) $(dir $@)
	touch $@

$(TMP)/2.2-armv7l/unpack.stamp:						\
		$(DOWNLOADS)/2.2-armv7l/$(TIZEN_VM__2_2_armv7l_TARBALL)
	@mkdir -p $(dir $@)
	tar xzvf $< -C $(dir $@)
	touch $@

$(DATA)/images/2.2-armv7l/pristine.qcow2:	\
		$(TMP)/2.2-armv7l/unpack.stamp	\
		protos/2.2-armv7l/pristine.sh
	@mkdir -p $(dir $@)
	rm -f $@
	qemu-img create -f qcow2 $@.tmp 25G
	$(BASH) protos/2.2-armv7l/pristine.sh $@.tmp	\
		$(TMP)/2.2-armv7l/platform.img		\
		$(TMP)/2.2-armv7l/ums.img		\
		$(TMP)/2.2-armv7l/data.img
	chmod a-w $@.tmp
	@mv $@.tmp $@

$(TMP)/2.2-armv7l/orig.stamp:					\
		$(DATA)/images/2.2-armv7l/pristine.qcow2	\
		protos/2.2-armv7l/orig.guestfish
	@mkdir -p $(dir $@)
	cd $(dir $@) && guestfish --ro -a $(PWD)/$<		\
		-f $(PWD)/protos/2.2-armv7l/orig.guestfish
	touch $@

$(TMP)/2.2-armv7l/patched.stamp:		\
		$(TMP)/2.2-armv7l/orig.stamp	\
		$(TIZEN_VM__2_2_armv7l_PATCHES)
	@mkdir -p $(dir $@)
	@rm -rf $(dir $@)patchwork
	@mkdir -p $(dir $@)patchwork/etc $(dir $@)patchwork/usr/lib/systemd
	tar xf $(PWD)/$(TMP)/2.2-armv7l/etc.tar	\
		-C $(dir $@)patchwork/etc
	tar xf $(PWD)/$(TMP)/2.2-armv7l/systemd.tar	\
		-C $(dir $@)patchwork/usr/lib/systemd
	$(BASH) tools/apply-patches.sh $(TMP)/2.2-armv7l/patchwork	\
		$(TIZEN_VM__2_2_armv7l_PATCHES)
	touch $@

$(TMP)/2.2-armv7l/patched.tar: $(TMP)/2.2-armv7l/patched.stamp
	@mkdir -p $(dir $@)
	tar cvf $@.tmp -C $(TMP)/2.2-armv7l/patchwork .
	@mv $@.tmp $@

$(DATA)/images/2.2-armv7l/base.qcow2:				\
		$(DATA)/images/2.2-armv7l/pristine.qcow2	\
		$(TMP)/2.2-armv7l/patched.tar			\
		$(TIZEN_VM__3_2_0_4_vexpress_MODULES_TAR)	\
		tools/force-fsck-part.sh			\
		protos/2.2-armv7l/finalize.sh
	@mkdir -p $(dir $@)
	rm -f $@
	cd $(dir $@) && qemu-img create -f qcow2	\
		-o backing_file=$(notdir $<)		\
		$(notdir $@).tmp
	# The provided images are NOT fsck clean!
	$(BASH) tools/force-fsck-part.sh $@.tmp /dev/sda1
	$(BASH) tools/force-fsck-part.sh $@.tmp /dev/sda2
	$(BASH) tools/force-fsck-part.sh $@.tmp /dev/sda3
	$(BASH) protos/2.2-armv7l/finalize.sh $@.tmp		\
		$(TMP)/2.2-armv7l/patched.tar			\
		$(TIZEN_VM__3_2_0_4_vexpress_MODULES_TAR)
	chmod a-w $@.tmp
	@mv $@.tmp $@

$(TMP)/vm-%/setup.tar:				\
		protos/2.2-armv7l/vm-setup.sh	\
		$(TMP)/vm-%/setup.env		\
		$(TMP)/2.2-armv7l/orig.stamp
	@mkdir -p $(dir $@)
	@rm -rf $(dir $@)vm-setup
	@mkdir -p $(dir $@)vm-setup/etc
	tar xf $(PWD)/$(TMP)/2.2-armv7l/etc.tar	\
		-C $(dir $@)vm-setup/etc	\
		./sysconfig/network
	$(BASH) protos/2.2-armv7l/vm-setup.sh	\
		$(TMP)/vm-$*/setup.env		\
		$(dir $@)vm-setup
	tar cf $@.tmp -C $(dir $@)vm-setup .
	@mv $@.tmp $@
