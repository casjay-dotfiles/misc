#!/usr/bin/env bash

APPNAME="misc"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# @Author          : Jason
# @Contact         : casjaysdev@casjay.net
# @File            : install.sh
# @Created         : Fr, Aug 28, 2020, 00:00 EST
# @License         : WTFPL
# @Copyright       : Copyright (c) CasjaysDev
# @Description     : installer script for misc
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set functions

SCRIPTSFUNCTURL="${SCRIPTSAPPFUNCTURL:-https://github.com/casjay-dotfiles/scripts/raw/master/functions}"
SCRIPTSFUNCTDIR="${SCRIPTSAPPFUNCTDIR:-/usr/local/share/CasjaysDev/scripts}"
SCRIPTSFUNCTFILE="${SCRIPTSAPPFUNCTFILE:-app-installer.bash}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ -f "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE" ]; then
  . "$SCRIPTSFUNCTDIR/functions/$SCRIPTSFUNCTFILE"
elif [ -f "$HOME/.local/share/CasjaysDev/functions/$SCRIPTSFUNCTFILE" ]; then
  . "$HOME/.local/share/CasjaysDev/functions/$SCRIPTSFUNCTFILE"
else
  curl -LSs "$SCRIPTSFUNCTURL/$SCRIPTSFUNCTFILE" -o "/tmp/$SCRIPTSFUNCTFILE" || exit 1
  . "/tmp/$SCRIPTSFUNCTFILE"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
user_installdirs

# OS Support: supported_os unsupported_oses

unsupported_oses

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Make sure the scripts repo is installed

scripts_check

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Defaults
APPNAME="${APPNAME:-misc}"
APPDIR="${APPDIR:-$HOME/.config/$APPNAME}"
INSTDIR="${INSTDIR}"
REPO="${DFMGRREPO:-https://github.com/dfmgr}/${APPNAME}"
REPORAW="${REPORAW:-$REPO/raw}"
APPVERSION="$(__appversion)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Setup plugins

PLUGNAMES=""
PLUGDIR="${SHARE:-$HOME/.local/share}/$APPNAME"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# dfmgr_install fontmgr_install iconmgr_install pkmgr_install systemmgr_install thememgr_install wallpapermgr_install

dfmgr_install

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Version

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Script options IE: --help

show_optvars "$@"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Do not update

#systemmgr_noupdate

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Requires root - no point in continuing

#sudoreq  # sudo required
#sudorun  # sudo optional

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# end with a space

if_os mac && APP="curl wget lynx links nano locate "
if_os linux && APP="curl wget lynx pip3 xdotool links nano ibus mlocate "
PERL=""
PYTH="pip setuptools "
PIPS="shodan ytmdl asciinema toot tootstream rainbowstream irc "
CPAN=""
GEMS=""

# install packages - useful for package that have the same name on all oses
install_packages $APP

# install required packages using file
install_required $APP

# check for perl modules and install using system package manager
install_perl $PERL

# check for python modules and install using system package manager
install_python $PYTH

# check for pip binaries and install using python package manager
install_pip $PIPS

# check for cpan binaries and install using perl package manager
install_cpan $CPAN

# check for ruby binaries and install using ruby package manager
install_gem $GEMS

# Other dependencies
dotfilesreq git dircolors
dotfilesreqadmin

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Ensure directories exist

ensure_dirs
ensure_perms

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Main progam

if [ -d "$APPDIR" ]; then
  execute "backupapp $APPDIR $APPNAME" "Backing up $APPDIR"
fi

if [ -d "$INSTDIR/.git" ]; then
  execute \
    "git_update $INSTDIR" \
    "Updating $APPNAME configurations"
else
  execute \
    "git_clone $REPO/$APPNAME $INSTDIR" \
    "Installing $APPNAME configurations"
fi

# exit on fail
failexitcode

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Plugins

if __am_i_online; then
  if [ "$PLUGNAMES" != "" ]; then
    if [ -d "$PLUGDIR"/PLUREP/.git ]; then
      execute \
        "git_update $PLUGDIR/PLUGREP" \
        "Updating plugin PLUGNAME"
    else
      execute \
        "git_clone PLUGINREPO $PLUGDIR/PLUGREP" \
        "Installing plugin PLUGREP"
    fi
  fi

  # exit on fail
  failexitcode
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# run post install scripts

run_postinst() {
  dfmgr_run_post
  for f in Xresources curlrc wgetrc gntrc inputrc libao profile rpmmacros xscreensaver myclirc; do
    [ ! -L "$HOME/.$f" ] || rm_link "$HOME/.$f"
    cp_rf "$INSTDIR/profile/$f" "$HOME/.$f"
  done
  for c in CasjaysDev dunst lynx xresources; do
    [ ! -L "$HOME/.config/$c" ] || rm_link "$HOME/.config/$c"
    [ -d $HOME/.config/$c ] || mkd "$HOME/.config/$c"
    cp_rf "$INSTDIR/configs/$c/." "$HOME/.config/$c/"
  done
}

execute \
  "run_postinst" \
  "Running post install scripts"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# create version file

dfmgr_install_version

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# exit
run_exit

# end
