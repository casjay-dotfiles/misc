#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
PROG="compton.sh"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 031120210507-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : compton.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Thursday, Mar 11, 2021 05:07 EST
# @File          : compton.sh
# @Description   : polybar compton/picom script
# @TODO          :
# @Other         :
# @Resource      : https://github.com/jaagr/polybar/wiki/User-contributed-modules
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# main function
__help() {
  printf_help "Usage: compton.sh"
}
main() {
  local DIR="${SRC_DIR:-$PWD}"
  if [[ -f "$DIR/functions.bash" ]]; then
    . "$DIR/functions.bash"
  else
    printf "\t\t\\033[0;31m%s \033[0m\n" "Couldn't source the functions file from $DIR"
    return 1
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  [ "$1" = "--help" ] && __help
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  local icon='  '
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if pgrep -x "compton" &>/dev/null || pgrep -x "picom" &>/dev/null; then
    echo "%{F#00AF02}$icon " #Green
  else
    echo "%{F#65737E}$icon " #Gray
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
main "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit $?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
