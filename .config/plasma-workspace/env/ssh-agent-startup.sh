#!/bin/sh
[ -z "$SSH_AGENT_PID" ] || eval "$(ssh-agent)"
export SSH_ASKPASS=`which ksshaskpass`
ssh-add </dev/null
