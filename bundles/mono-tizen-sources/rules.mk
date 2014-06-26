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

$(TMP)/vm-$(NAME)/mono-tizen-sources.setup:				\
		$(TMP)/vm-$(NAME)/mono-tizen-build.setup	\
		$(TMP)/mono-tizen-sources.tar
	@mkdir -p $(dir $@)
	cp $< $@.tmp
	echo bundles/mono-tizen-sources/setup.sh >> $@.tmp
	mv $@.tmp $@

$(TMP)/mono-tizen-sources.tar:				\
		$(TMP)/mono-tizen-sources/tar.stamp
	@mkdir -p $(dir $@)
	tar cf $@.tmp -C $(TMP)/mono-tizen-sources/tar .
	@mv $@.tmp $@

$(TMP)/mono-tizen-sources/tar.stamp:				\
		$(MONO_TIZEN_CLONE)/.git/HEAD
	@rm -rf $(dir $@)tar
	@mkdir -p $(dir $@)tar/$(TIZEN_VM__mono_tizen_build_MONO_SOURCES)
	rsync -av --delete $(MONO_TIZEN_CLONE)/.git/			      \
		$(dir $@)tar/$(TIZEN_VM__mono_tizen_build_MONO_SOURCES)/.git/
	rm -f $(dir $@)tar/$(TIZEN_VM__mono_tizen_build_MONO_SOURCES)/.git/index
	cd $(dir $@)tar/$(TIZEN_VM__mono_tizen_build_MONO_SOURCES)/ &&	\
		git reset --hard HEAD
	touch $@
