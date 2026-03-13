#!/bin/bash
CCUSAGE=/cluster/home/michaes/.bun/bin/ccusage
SED=/usr/bin/sed
GREP=/usr/bin/grep
CACHE=/cluster/home/michaes/.claude/statusline_blocks_cache.json
CACHE_MAX_AGE=60

input=$(cat)

# Parse JSON without jq -- use grep on single-line JSON
extract() { echo "$input" | $GREP -oP "\"$1\"\\s*:\\s*\\K[^\",}]+" | head -1; }
extract_str() { echo "$input" | $GREP -oP "\"$1\"\\s*:\\s*\"\\K[^\"]*" | head -1; }

SESSION=$(extract_str session_name)
[ -z "$SESSION" ] && SESSION=$(extract_str session_id | cut -c1-8)
SESSION=${SESSION:-?}
MODEL=$(extract_str display_name)
MODEL=${MODEL:-?}
PCT=$(extract used_percentage | cut -d. -f1)
PCT=${PCT:-0}
DURATION_MS=$(extract total_duration_ms | cut -d. -f1)
DURATION_MS=${DURATION_MS:-0}

# Colors
GREEN='\033[32m'; YELLOW='\033[33m'; RED='\033[31m'; DIM='\033[2m'; RESET='\033[0m'

if [ "$PCT" -ge 90 ] 2>/dev/null; then BAR_COLOR="$RED"
elif [ "$PCT" -ge 70 ] 2>/dev/null; then BAR_COLOR="$YELLOW"
else BAR_COLOR="$GREEN"; fi

FILLED=$((PCT * 10 / 100)); EMPTY=$((10 - FILLED))
BAR=$(printf "%${FILLED}s" | tr ' ' '#')$(printf "%${EMPTY}s" | tr ' ' '-')

# Duration in h m format, omit 0h
TOTAL_SECS=$((DURATION_MS / 1000))
D_HRS=$((TOTAL_SECS / 3600)); D_MINS=$(( (TOTAL_SECS % 3600) / 60 ))
if [ "$D_HRS" -gt 0 ]; then
  DURATION="${D_HRS}h ${D_MINS}m spent"
else
  DURATION="${D_MINS}m spent"
fi

# ccusage statusline
CCUSAGE_LINE=$(printf '%s' "$input" | $CCUSAGE statusline 2>/dev/null || true)

# Block budget: refresh cache if stale
USED_PCT="?"
PROJ_PCT="?"
NOW=$(date +%s)
if [ -f "$CACHE" ]; then
  FILE_MOD=$(stat -c %Y "$CACHE" 2>/dev/null || echo 0)
  CACHE_AGE=$((NOW - FILE_MOD))
else
  CACHE_AGE=$((CACHE_MAX_AGE + 1))
fi

if [ "$CACHE_AGE" -gt "$CACHE_MAX_AGE" ]; then
  (timeout 10 $CCUSAGE blocks --active --token-limit max --json > "${CACHE}.tmp" 2>/dev/null && mv "${CACHE}.tmp" "$CACHE") &
fi

TIME_LEFT="?"
if [ -f "$CACHE" ]; then
  CACHE_DATA=$(cat "$CACHE")
  TOTAL_TOKENS=$(echo "$CACHE_DATA" | $GREP -oP '"totalTokens"\s*:\s*\K[0-9]+' | head -1)
  LIMIT=$(echo "$CACHE_DATA" | $GREP -oP '"limit"\s*:\s*\K[0-9]+' | head -1)
  PROJ_TOKENS=$(echo "$CACHE_DATA" | $GREP -oP '"projectedUsage"\s*:\s*\K[0-9]+' | head -1)
  if [ -n "$LIMIT" ] && [ "$LIMIT" -gt 0 ] 2>/dev/null; then
    [ -n "$TOTAL_TOKENS" ] && USED_PCT="$((TOTAL_TOKENS * 100 / LIMIT))%"
    [ -n "$PROJ_TOKENS" ] && PROJ_PCT="$((PROJ_TOKENS * 100 / LIMIT))%"
  fi
  # Compute time left from block endTime in UTC
  END_TIME=$(echo "$CACHE_DATA" | $GREP -oP '"endTime"\s*:\s*"\K[^"]+' | head -1)
  if [ -n "$END_TIME" ]; then
    END_EPOCH=$(date -d "$END_TIME" +%s 2>/dev/null || echo 0)
    NOW_UTC=$(date -u +%s)
    REMAIN_S=$((END_EPOCH - NOW_UTC))
    if [ "$REMAIN_S" -gt 0 ]; then
      TIME_LEFT="$((REMAIN_S / 3600))h $((REMAIN_S % 3600 / 60))m"
    else
      TIME_LEFT="0m"
    fi
  fi
fi

# Line 1
echo -e "${DIM}${MODEL}${RESET} | ${DIM}[$SESSION]${RESET} ${BAR_COLOR}${BAR}${RESET} ${PCT}% | ${USED_PCT} used | ${PROJ_PCT} proj | ${TIME_LEFT} left | ${DURATION}"

# Line 2: ccusage with model and (time left) stripped
echo "$CCUSAGE_LINE" | $SED 's/^[^|]*| //; s/ ([^)]*left)//'
