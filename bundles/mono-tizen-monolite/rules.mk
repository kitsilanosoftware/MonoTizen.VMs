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

MONO_TIZEN_CLONE = /path/to/mono/git/clone

$(TMP)/bundles/mono-tizen-monolite.setup:		\
		$(TMP)/bundles/mono-tizen-build.setup	\
		$(TMP)/mono-tizen-monolite.tar
	@mkdir -p $(dir $@)
	cp $< $@.tmp
	echo bundles/mono-tizen-monolite/setup.sh >> $@.tmp
	mv $@.tmp $@

$(TMP)/mono-tizen-monolite.tar:				\
		$(TMP)/mono-tizen-monolite/tar.stamp
	@mkdir -p $(dir $@)
	tar cf $@.tmp -C $(TMP)/mono-tizen-monolite/tar .
	@mv $@.tmp $@

$(TMP)/mono-tizen-monolite/tar.stamp:				\
		$(TMP)/mono-tizen-monolite/monolite.tar.gz
	@rm -rf $(dir $@)tar
	mkdir -p $(dir $@)tar/$(TIZEN_VM__mono_tizen_build_MT)/
	tar xzf $< -C $(dir $@)tar/$(TIZEN_VM__mono_tizen_build_MT)/
	cd $(dir $@)tar/$(TIZEN_VM__mono_tizen_build_MT)/ &&	\
		ln -s monolite-* monolite
	touch $@

$(TMP)/mono-tizen-monolite/monolite.tar.gz:		\
		bundles/mono-tizen-monolite/monolite.mk	\
		$(MONO_TIZEN_CLONE)/Makefile
	@mkdir -p $(dir $@)
	$(MAKE) -C $(MONO_TIZEN_CLONE) -f $(abspath $<)	\
		MONO_TIZEN_MONOLITE=$(abspath $@.tmp)	\
		get-monolite-latest
	@mv $@.tmp $@
