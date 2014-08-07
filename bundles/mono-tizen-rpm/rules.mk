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

MONO_TIZEN_CLONE = ../mono
MONO_TIZEN_VERSION = 3.6.0

$(TMP)/vm-$(NAME)/mono-tizen-rpm.setup:				\
		$(TMP)/vm-$(NAME)/mono-tizen-build.setup	\
		$(TMP)/mono-tizen-rpm.tar
	@mkdir -p $(dir $@)
	cp $< $@.tmp
	echo bundles/mono-tizen-rpm/setup.sh >> $@.tmp
	mv $@.tmp $@

$(TMP)/mono-tizen-rpm.tar:			\
		$(TMP)/mono-tizen-rpm/tar.stamp
	@mkdir -p $(dir $@)
	tar cf $@.tmp -C $(TMP)/mono-tizen-rpm/tar .
	@mv $@.tmp $@

$(TMP)/mono-tizen-rpm/tar.stamp:				\
		$(TMP)/mono-$(MONO_TIZEN_VERSION).tar.bz2	\
		$(TMP)/mono-core-$(MONO_TIZEN_VERSION)-1.spec
	@rm -rf $(dir $@)tar
	@mkdir -p $(dir $@)tar
	mkdir -p $(dir $@)tar/$(TIZEN_VM__mono_tizen_build_RPM_BUILD)/{SOURCES,SPECS}
	ln $(TMP)/mono-$(MONO_TIZEN_VERSION).tar.bz2 \
		$(dir $@)tar/$(TIZEN_VM__mono_tizen_build_RPM_BUILD)/SOURCES/
	cp $(TMP)/mono-core-$(MONO_TIZEN_VERSION)-1.spec \
		$(dir $@)tar/$(TIZEN_VM__mono_tizen_build_RPM_BUILD)/SPECS/
	touch $@

$(TMP)/mono-$(MONO_TIZEN_VERSION).tar.bz2:		\
		$(TMP)/mono-tizen-rpm/dist.stamp
	@mkdir -p $(dir $@)
	cp $(MONO_TIZEN_CLONE)/mono-$(MONO_TIZEN_VERSION).tar.bz2 $@.tmp
	@mv $@.tmp $@

$(TMP)/mono-core-$(MONO_TIZEN_VERSION)-1.spec:		\
		$(TMP)/mono-tizen-rpm/dist.stamp
	@mkdir -p $(dir $@)
	cp $(MONO_TIZEN_CLONE)/mono-core.spec $@.tmp
	@mv $@.tmp $@

$(TMP)/mono-tizen-rpm/dist.stamp:		\
		$(MONO_TIZEN_CLONE)/Makefile
	@mkdir -p $(dir $@)
	$(MAKE) -C $(MONO_TIZEN_CLONE)		\
		dist-bzip2
	touch $@
