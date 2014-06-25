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

TIZEN_VM__mono_tizen_devel_ROOT_FILES =				\
	$(wildcard bundles/mono-tizen-devel/files/root/*)

mono-tizen-devel-bundle: $(TMP)/mono-tizen-devel.tar

$(TMP)/mono-tizen-devel.tar:			\
		$(TMP)/mono-tizen-devel.stamp
	@mkdir -p $(dir $@)
	tar cf $@.tmp -C $(TMP)/mono-tizen-devel .
	@mv $@.tmp $@

$(TMP)/mono-tizen-devel.stamp:					\
		$(TIZEN_VM__mono_tizen_devel_ROOT_FILES)
	@mkdir -p $(dir $@)
	@rm -rf $(dir $@)mono-tizen-devel
	@mkdir -p $(dir $@)mono-tizen-devel/root
	for F in $(notdir $(TIZEN_VM__mono_tizen_devel_ROOT_FILES)); do	\
		cp bundles/mono-tizen-devel/files/root/$$F		\
			$(dir $@)mono-tizen-devel/root;			\
	done
	touch $@
