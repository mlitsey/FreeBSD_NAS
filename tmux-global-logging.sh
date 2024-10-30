#!/usr/bin/env bash
# sudo apt install tmux
#set -x # enables debugging
#set -e # bash will exit on error
#printf " \n\n Don't forget to check /var/log/syslog or /var/log/cron for cronjob script run times \n\n"


if [ -n "$TMUX_PANE" ] && [ "$TMUX_PANE_LOGGING" != "1" ]; then
  export TMUX_PANE_LOGGING=1
else
  exit 0
fi

LOGS=$HOME/.tmux/logs
mkdir --parents $LOGS
#LOG_PATH="$LOGS/$(date +%Y%m%d_%H%M%S).pane${TMUX_PANE//[^0-9]/}.log"
#LOG_PATH="$LOGS/$(date +%F_%T).pane${TMUX_PANE//[^0-9]/}.log"
LOG_PATH="$LOGS/$(date +%F_%H%M%S).pane${TMUX_PANE//[^0-9]/}.log"

# sudo apt install ansifilter
tmux pipe-pane -t "${TMUX_PANE}" "exec cat - | ansifilter >> $LOG_PATH"

# without ansifilter
#tmux pipe-pane -t "${TMUX_PANE}" "exec cat - >> $LOG_PATH"

# add to .bashrc
# /usr/local/bin/tmux-global-logging.sh
# or
# $HOME/tmux-global-logging.sh
