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

TIZEN_VM__3_0pre_i586_common_PREFIX_URL = \
	http://download.tizen.org/releases/daily/tizen/common/tizen_20140704.1/

TIZEN_VM__3_0pre_i586_common_IMAGES_URL = \
	$(TIZEN_VM__3_0pre_i586_common_PREFIX_URL)/images/emulator32-wayland/common-emulator-wayland-mbr-i586/

TIZEN_VM__3_0pre_i586_common_TARBALL = \
	tizen_20140704.1_common-emulator-wayland-mbr-i586.tar.gz

TIZEN_VM__3_0pre_i586_common_KERNEL = \
	vmlinuz-3.14.4-7.1-x86-common

TIZEN_VM__3_0pre_i586_common_INITRD = \
	initrd-3.14.4-7.1-x86-common.img

TIZEN_VM__3_0pre_i586_common_PATCHES = \
	$(wildcard protos/$(PROTO)/patches/*.patch)

$(PROTO)-kernel: tmp/$(PROTO)/kernel.stamp

$(DOWNLOADS)/$(PROTO)/$(TIZEN_VM__3_0pre_i586_common_TARBALL):
	@mkdir -p $(dir $@)
	wget -O $@.tmp							\
		$(TIZEN_VM__3_0pre_i586_common_IMAGES_URL)/$(notdir $@)
	@mv $@.tmp $@

$(DATA)/images/$(PROTO)/tizen-common.img:				      \
		$(DOWNLOADS)/$(PROTO)/$(TIZEN_VM__3_0pre_i586_common_TARBALL)
	@mkdir -p $(dir $@) $(TMP)/$(PROTO)
	tar xzf $< -m -C $(TMP)/$(PROTO)
	mv $(TMP)/$(PROTO)/$(notdir $@) $@

$(TMP)/$(PROTO)/patched.stamp:			\
		$(TMP)/$(PROTO)/orig.stamp	\
		$(TIZEN_VM__3_0pre_i586_common_PATCHES)
	@mkdir -p $(dir $@)
	@rm -rf $(dir $@)patchwork
	@mkdir -p $(dir $@)patchwork/etc $(dir $@)patchwork/usr/lib/systemd
	tar xf $(PWD)/$(TMP)/$(PROTO)/etc.tar	\
		-C $(dir $@)patchwork/etc
	chmod -R u+rw $(dir $@)patchwork/etc
	tar xf $(PWD)/$(TMP)/$(PROTO)/systemd.tar	\
		-C $(dir $@)patchwork/usr/lib/systemd
	$(BASH) tools/apply-patches.sh $(TMP)/$(PROTO)/patchwork	\
		$(TIZEN_VM__3_0pre_i586_common_PATCHES)
	touch $@

$(TMP)/$(PROTO)/patched.tar: $(TMP)/$(PROTO)/patched.stamp
	@mkdir -p $(dir $@)
	tar cf $@.tmp -C $(TMP)/$(PROTO)/patchwork .
	@mv $@.tmp $@

$(DATA)/images/$(PROTO)/base.qcow2:				\
		$(DATA)/images/$(PROTO)/tizen-common.img	\
		$(TMP)/$(PROTO)/patched.tar
	@mkdir -p $(dir $@)
	rm -f $@
	cd $(dir $@) && qemu-img create -f qcow2	\
		-o backing_file=$(notdir $<)		\
		$(notdir $@).tmp 25G
	# The provided images are NOT fsck clean!
	$(BASH) tools/force-fsck-part.sh $@.tmp /dev/sda
	$(BASH) protos/$(PROTO)/finalize.sh $@.tmp	\
		$(TMP)/$(PROTO)/patched.tar
	chmod a-w $@.tmp
	@mv $@.tmp $@

$(TMP)/$(PROTO)/orig.stamp:					\
		$(DATA)/images/$(PROTO)/tizen-common.img	\
		protos/$(PROTO)/orig.guestfish
	@mkdir -p $(dir $@)
	cd $(dir $@) && guestfish --ro -a $(PWD)/$<		\
		-f $(PWD)/protos/$(PROTO)/orig.guestfish
	touch $@

$(TMP)/$(PROTO)/kernel.stamp:			\
		$(TMP)/$(PROTO)/orig.stamp
	@mkdir -p $(dir $@) $(DATA)/images/$(PROTO)/
	tar xf $(TMP)/$(PROTO)/boot.tar -C $(dir $@)		\
		./$(TIZEN_VM__3_0pre_i586_common_KERNEL)	\
		./$(TIZEN_VM__3_0pre_i586_common_INITRD)
	mv $(dir $@)$(TIZEN_VM__3_0pre_i586_common_KERNEL)	\
		$(dir $@)$(TIZEN_VM__3_0pre_i586_common_INITRD)	\
		$(DATA)/images/$(PROTO)/
	touch $@

$(TMP)/vm-%/setup.tar:				\
		protos/$(PROTO)/vm-setup.sh	\
		$(TMP)/vm-%/setup.env		\
		$(TMP)/$(PROTO)/orig.stamp
	@mkdir -p $(dir $@)
	@rm -rf $(dir $@)vm-setup
	@mkdir -p $(dir $@)vm-setup/etc
	$(BASH) protos/$(PROTO)/vm-setup.sh	\
		$(TMP)/vm-$*/setup.env		\
		$(dir $@)vm-setup
	tar cf $@.tmp -C $(dir $@)vm-setup .
	@mv $@.tmp $@
