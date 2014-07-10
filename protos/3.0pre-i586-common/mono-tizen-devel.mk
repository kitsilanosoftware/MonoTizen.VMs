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

TIZEN_VM__3_0pre_i586_PREFIX_URL = \
	http://download.tizen.org/releases/daily/tizen/common/tizen_20140704.1/

TIZEN_VM__mono_tizen_devel_REPO_URL = \
	$(TIZEN_VM__3_0pre_i586_PREFIX_URL)/repos/emulator32-wayland/packages

TIZEN_VM__mono_tizen_devel_RPMS =

# KLUDGE: This has nothing to do here; TODO: modularize.
TIZEN_VM__mono_tizen_devel_RPMS +=		\
	$(if $(filter buildbot,$(VM_BUNDLES)),	\
		)
