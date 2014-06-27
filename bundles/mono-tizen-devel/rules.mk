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

TIZEN_VM__mono_tizen_devel_SETUP =		\
	bundles/mono-tizen-devel/files/setup.sh

TIZEN_VM__mono_tizen_devel_PARTS =				\
	$(wildcard bundles/mono-tizen-devel/files/parts/*.sh)

TIZEN_VM__mono_tizen_devel_RPM_LIST =		\
	autoconf automake libtool gettext-tools	\
	gcc-c++ kernel-headers make rpm-build	\
	bison fdupes zlib-devel pkgconfig

-include protos/$(PROTO)/mono-tizen-devel.mk

$(TMP)/vm-%/mono-tizen-devel.setup:			\
		$(TMP)/mono-tizen-devel-$(PROTO).tar
	@mkdir -p $(dir $@)
	echo bundles/mono-tizen-devel/setup.sh > $@.tmp
	mv $@.tmp $@

$(TMP)/mono-tizen-devel-$(PROTO).tar:				\
		$(TMP)/mono-tizen-devel-$(PROTO)/tar.stamp
	@mkdir -p $(dir $@)
	tar cf $@.tmp -C $(TMP)/mono-tizen-devel-$(PROTO)/tar .
	@mv $@.tmp $@

$(TMP)/mono-tizen-devel-$(PROTO)/tar.stamp:			\
		$(TMP)/mono-tizen-devel-$(PROTO)/rpms.stamp	\
		$(TIZEN_VM__mono_tizen_devel_SETUP)		\
		$(TIZEN_VM__mono_tizen_devel_PARTS)
	@mkdir -p $(dir $@)
	@rm -rf $(dir $@)tar
	mkdir -p $(dir $@)tar/root/rpms/install.d
	echo $(TIZEN_VM__mono_tizen_devel_RPM_LIST)			 \
		> $(dir $@)tar/root/rpms/install.d/mono-tizen-devel.list
	mkdir -p $(dir $@)tar/root/setup.d
	cp $(TIZEN_VM__mono_tizen_devel_PARTS) $(dir $@)tar/root/setup.d
	cp $(TIZEN_VM__mono_tizen_devel_SETUP) $(dir $@)tar/root/setup.sh
	for F in $(TIZEN_VM__mono_tizen_devel_RPMS); do			\
		mkdir -p $(dir $@)tar/root/rpms/pre/$$(dirname $$F);	\
		ln $(DOWNLOADS)/mono-tizen-devel/$$F			\
			$(dir $@)tar/root/rpms/pre/$$F;			\
	done
	touch $@

$(TMP)/mono-tizen-devel-$(PROTO)/rpms.stamp:			\
		$(foreach R,$(TIZEN_VM__mono_tizen_devel_RPMS),	\
			$(DOWNLOADS)/mono-tizen-devel/$(R))
	@mkdir -p $(dir $@)
	touch $@

$(DOWNLOADS)/mono-tizen-devel/%.rpm:
	@mkdir -p $(dir $@)
	wget -O $@.tmp						\
		$(TIZEN_VM__mono_tizen_devel_REPO_URL)/$(subst	\
			$(DOWNLOADS)/mono-tizen-devel/,,$@)
	@mv $@.tmp $@
