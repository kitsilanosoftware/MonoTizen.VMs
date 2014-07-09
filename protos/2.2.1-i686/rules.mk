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

TIZEN_VM__2_2_1_i686_PREFIX_URL =					\
	http://download.tizen.org/releases/2.2/tizen-2.2_20130719.3

TIZEN_VM__2_2_1_i686_PATCHES =				\
	$(wildcard protos/$(PROTO)/patches/*.patch)

TIZEN_VM__2_2_1_i686_KERNEL =			\
	$(DOWNLOADS)/$(PROTO)/bzImage.x86

TIZEN_VM__2_2_1_i686_PRISTINE =			\
	$(DOWNLOADS)/$(PROTO)/emulimg-2.2.x86

$(PROTO)-kernel: $(DOWNLOADS)/$(PROTO)/kernel.stamp

$(DOWNLOADS)/$(PROTO)/kernel.stamp:			\
		$(TIZEN_VM__2_2_1_i686_KERNEL)		\
		$(TIZEN_VM__2_2_1_i686_PRISTINE)
	# TODO: Verify that we are indeed using the same images?
	# $(DOWNLOADS)/$(PROTO) &&					    \
	#	md5sum -c --strict $(PWD)/protos/$(PROTO)/downloads.md5sums
	touch $@

$(TMP)/$(PROTO)/orig.stamp:				\
		$(TIZEN_VM__2_2_1_i686_PRISTINE)	\
		protos/$(PROTO)/orig.guestfish
	@mkdir -p $(dir $@)
	cd $(dir $@) && guestfish --ro -a $(PWD)/$<		\
		-f $(PWD)/protos/$(PROTO)/orig.guestfish
	touch $@

$(TMP)/$(PROTO)/patched.stamp:			\
		$(TMP)/$(PROTO)/orig.stamp	\
		$(TIZEN_VM__2_2_1_i686_PATCHES)
	@mkdir -p $(dir $@)
	@rm -rf $(dir $@)patchwork
	@mkdir -p $(dir $@)patchwork/etc $(dir $@)patchwork/usr/lib/systemd
	tar xf $(PWD)/$(TMP)/$(PROTO)/etc.tar	\
		-C $(dir $@)patchwork/etc
	tar xf $(PWD)/$(TMP)/$(PROTO)/systemd.tar	\
		-C $(dir $@)patchwork/usr/lib/systemd
	$(BASH) tools/apply-patches.sh $(TMP)/$(PROTO)/patchwork	\
		$(TIZEN_VM__2_2_1_i686_PATCHES)
	touch $@

$(TMP)/$(PROTO)/patched.tar: $(TMP)/$(PROTO)/patched.stamp
	@mkdir -p $(dir $@)
	tar cf $@.tmp -C $(TMP)/$(PROTO)/patchwork .
	@mv $@.tmp $@

$(DATA)/images/$(PROTO)/base.qcow2:			\
		$(TIZEN_VM__2_2_1_i686_PRISTINE)	\
		$(TMP)/$(PROTO)/patched.tar		\
		protos/$(PROTO)/finalize.sh
	@mkdir -p $(dir $@)
	rm -f $@
	cd $(dir $@) && qemu-img create -f qcow2			\
		-o backing_file=../../downloads/$(PROTO)/$(notdir $<)	\
		$(notdir $@).tmp
	$(BASH) protos/$(PROTO)/finalize.sh $@.tmp	\
		$(TMP)/$(PROTO)/patched.tar
	chmod a-w $@.tmp
	@mv $@.tmp $@

$(TMP)/vm-%/setup.tar:				\
		protos/$(PROTO)/vm-setup.sh	\
		$(TMP)/vm-%/setup.env		\
		$(TMP)/$(PROTO)/orig.stamp
	@mkdir -p $(dir $@)
	@rm -rf $(dir $@)vm-setup
	@mkdir -p $(dir $@)vm-setup/etc
	tar xf $(PWD)/$(TMP)/$(PROTO)/etc.tar	\
		-C $(dir $@)vm-setup/etc	\
		./sysconfig/network
	$(BASH) protos/$(PROTO)/vm-setup.sh	\
		$(TMP)/vm-$*/setup.env		\
		$(dir $@)vm-setup
	tar cf $@.tmp -C $(dir $@)vm-setup .
	@mv $@.tmp $@
