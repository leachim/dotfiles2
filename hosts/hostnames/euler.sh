#!/bin/bash
# Config for Euler cluster nodes (matches euler-*)

export PATH="/cluster/work/bewi/members/michaes/npm-global/v22.14.0/bin:$PATH"

alias quota_euler="cat /cluster/work/bewi/.bewi_user_data_usage.txt"
alias clusterquota='lfs quota -h -g fmlab'
