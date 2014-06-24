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

TIZEN_VM__2_2_armv7l_PATCHES = $(wildcard protos/$(PROTO)/patches/*.patch)

include kernels/3.2.0-4-vexpress/rules.mk

$(PROTO)-kernel: $(DOWNLOADS)/3.2.0-4-vexpress/stamp

$(DOWNLOADS)/$(PROTO)/$(TIZEN_VM__2_2_armv7l_TARBALL):			    \
		$(DOWNLOADS)/$(PROTO)/$(TIZEN_VM__2_2_armv7l_TARBALL).stamp
	touch $@

$(DOWNLOADS)/$(PROTO)/$(TIZEN_VM__2_2_armv7l_TARBALL).stamp:	\
		protos/$(PROTO)/downloads.md5sums
	@mkdir -p $(dir $@) $(TMP)/$(PROTO)
	wget -O $(TMP)/$(PROTO)/$(TIZEN_VM__2_2_armv7l_TARBALL) \
		$(TIZEN_VM__2_2_armv7l_BASE_URL)/$(TIZEN_VM__2_2_armv7l_TARBALL)
	cd $(TMP)/$(PROTO) &&						    \
		md5sum -c --strict $(PWD)/protos/$(PROTO)/downloads.md5sums
	mv $(TMP)/$(PROTO)/$(TIZEN_VM__2_2_armv7l_TARBALL) $(dir $@)
	touch $@

$(TMP)/$(PROTO)/unpack.stamp:						\
		$(DOWNLOADS)/$(PROTO)/$(TIZEN_VM__2_2_armv7l_TARBALL)
	@mkdir -p $(dir $@)
	tar xzvf $< -C $(dir $@)
	touch $@

$(DATA)/images/$(PROTO)/pristine.qcow2:		\
		$(TMP)/$(PROTO)/unpack.stamp	\
		protos/$(PROTO)/pristine.sh
	@mkdir -p $(dir $@)
	rm -f $@
	qemu-img create -f qcow2 $@.tmp 25G
	$(BASH) protos/$(PROTO)/pristine.sh $@.tmp	\
		$(TMP)/$(PROTO)/platform.img		\
		$(TMP)/$(PROTO)/ums.img			\
		$(TMP)/$(PROTO)/data.img
	chmod a-w $@.tmp
	@mv $@.tmp $@

$(TMP)/$(PROTO)/orig.stamp:				\
		$(DATA)/images/$(PROTO)/pristine.qcow2	\
		protos/$(PROTO)/orig.guestfish
	@mkdir -p $(dir $@)
	cd $(dir $@) && guestfish --ro -a $(PWD)/$<		\
		-f $(PWD)/protos/$(PROTO)/orig.guestfish
	touch $@

$(TMP)/$(PROTO)/patched.stamp:			\
		$(TMP)/$(PROTO)/orig.stamp	\
		$(TIZEN_VM__2_2_armv7l_PATCHES)
	@mkdir -p $(dir $@)
	@rm -rf $(dir $@)patchwork
	@mkdir -p $(dir $@)patchwork/etc $(dir $@)patchwork/usr/lib/systemd
	tar xf $(PWD)/$(TMP)/$(PROTO)/etc.tar	\
		-C $(dir $@)patchwork/etc
	tar xf $(PWD)/$(TMP)/$(PROTO)/systemd.tar	\
		-C $(dir $@)patchwork/usr/lib/systemd
	$(BASH) tools/apply-patches.sh $(TMP)/$(PROTO)/patchwork	\
		$(TIZEN_VM__2_2_armv7l_PATCHES)
	touch $@

$(TMP)/$(PROTO)/patched.tar: $(TMP)/$(PROTO)/patched.stamp
	@mkdir -p $(dir $@)
	tar cvf $@.tmp -C $(TMP)/$(PROTO)/patchwork .
	@mv $@.tmp $@

$(DATA)/images/$(PROTO)/base.qcow2:			\
		$(DATA)/images/$(PROTO)/pristine.qcow2	\
		$(TMP)/$(PROTO)/patched.tar		\
		tools/force-fsck-part.sh		\
		protos/$(PROTO)/finalize.sh
	@mkdir -p $(dir $@)
	rm -f $@
	cd $(dir $@) && qemu-img create -f qcow2	\
		-o backing_file=$(notdir $<)		\
		$(notdir $@).tmp
	# The provided images are NOT fsck clean!
	$(BASH) tools/force-fsck-part.sh $@.tmp /dev/sda1
	$(BASH) tools/force-fsck-part.sh $@.tmp /dev/sda2
	$(BASH) tools/force-fsck-part.sh $@.tmp /dev/sda3
	$(BASH) protos/$(PROTO)/finalize.sh $@.tmp $(TMP)/$(PROTO)/patched.tar
	chmod a-w $@.tmp
	@mv $@.tmp $@
