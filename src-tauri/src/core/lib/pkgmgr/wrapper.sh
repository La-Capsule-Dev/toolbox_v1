#!/usr/bin/env bash
set -euo pipefail

source "$LIB_DIR/pkgmgr/pkg_op_native.sh"
source "$LIB_DIR/ui/echo_status.sh"


install_pkgs_native()    { pkg_op_native "$1" install "${@:2}"; }
install_one_pkg_native() { pkg_op_native "$1" install "$2"; }
update_pkgs_native()     { pkg_op_native "$1" update; }
remove_pkgs_native()     { pkg_op_native "$1" remove "${@:2}"; }
remove_one_pkg_native()  { pkg_op_native "$1" remove "$2"; }
autoremove_pkgs_native() { pkg_op_native "$1" autoremove; }
autoclean_pkgs_native()      { pkg_op_native "$1" clean; }
