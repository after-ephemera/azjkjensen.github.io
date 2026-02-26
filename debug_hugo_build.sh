#!/bin/bash
# Debug script to check Hugo build behavior

LOG_FILE="/Users/jkjensen/dev/azjkjensen.github.io/.cursor/debug.log"
TIMESTAMP=$(date +%s)000

# Helper function to log NDJSON
log() {
  local msg="$1"
  local log_msg="$2"
  local run_id="${3:-initial}"
  local hyp_id="${4:-general}"
  local data="${5:-}"
  if [ -z "$data" ]; then
    echo "{\"timestamp\":$TIMESTAMP,\"location\":\"debug_hugo_build.sh\",\"message\":\"$log_msg\",\"data\":{\"value\":\"$msg\"},\"sessionId\":\"debug-session\",\"runId\":\"$run_id\",\"hypothesisId\":\"$hyp_id\"}" >> "$LOG_FILE"
  else
    echo "{\"timestamp\":$TIMESTAMP,\"location\":\"debug_hugo_build.sh\",\"message\":\"$log_msg\",\"data\":{$data},\"sessionId\":\"debug-session\",\"runId\":\"$run_id\",\"hypothesisId\":\"$hyp_id\"}" >> "$LOG_FILE"
  fi
}

# Check Hugo version
HUGO_VERSION=$(hugo version 2>&1)
log "$HUGO_VERSION" "hugo_version" "initial" "A" "\"version\":\"$HUGO_VERSION\""

# Check if posts exist in content
POST1="/Users/jkjensen/dev/azjkjensen.github.io/content/posts/2025-12-30-ai-era-developer-metrics.md"
POST2="/Users/jkjensen/dev/azjkjensen.github.io/content/posts/2025-12-22-trusted-execution-environments.md"

if [ -f "$POST1" ]; then
  log "EXISTS" "post1_exists" "initial" "A" "\"file\":\"2025-12-30-ai-era-developer-metrics.md\""
  # Extract date
  DATE1=$(grep -E "^date\s*=" "$POST1" | head -1 | sed 's/date = //' | sed "s/'//g" | sed 's/"//g' | tr -d ' ')
  log "$DATE1" "post1_date" "initial" "A" "\"date\":\"$DATE1\""
  # Check draft status
  DRAFT1=$(grep -E "^draft\s*=" "$POST1" | head -1 | sed 's/draft = //' | sed "s/'//g" | sed 's/"//g' | tr -d ' ' | tr '[:upper:]' '[:lower:]')
  log "$DRAFT1" "post1_draft" "initial" "A" "\"draft\":\"$DRAFT1\""
else
  log "NOT_FOUND" "post1_missing" "initial" "A" "\"file\":\"2025-12-30-ai-era-developer-metrics.md\""
fi

if [ -f "$POST2" ]; then
  log "EXISTS" "post2_exists" "initial" "A" "\"file\":\"2025-12-22-trusted-execution-environments.md\""
  DATE2=$(grep -E "^date\s*=" "$POST2" | head -1 | sed 's/date = //' | sed "s/'//g" | sed 's/"//g' | tr -d ' ')
  log "$DATE2" "post2_date" "initial" "A" "\"date\":\"$DATE2\""
  DRAFT2=$(grep -E "^draft\s*=" "$POST2" | head -1 | sed 's/draft = //' | sed "s/'//g" | sed 's/"//g' | tr -d ' ' | tr '[:upper:]' '[:lower:]')
  log "$DRAFT2" "post2_draft" "initial" "A" "\"draft\":\"$DRAFT2\""
else
  log "NOT_FOUND" "post2_missing" "initial" "A" "\"file\":\"2025-12-22-trusted-execution-environments.md\""
fi

# Try to build with --buildFuture and capture output
cd /Users/jkjensen/dev/azjkjensen.github.io
BUILD_OUTPUT=$(hugo --buildFuture 2>&1)
log "$BUILD_OUTPUT" "hugo_build_output" "initial" "B" "\"output\":\"$BUILD_OUTPUT\""

# Check if post directories were created
PUBLIC_POST1="/Users/jkjensen/dev/azjkjensen.github.io/public/posts/2025-12-30-ai-era-developer-metrics"
PUBLIC_POST2="/Users/jkjensen/dev/azjkjensen.github.io/public/posts/2025-12-22-trusted-execution-environments"

if [ -d "$PUBLIC_POST1" ]; then
  log "EXISTS" "public_post1_dir_exists" "initial" "C" "\"dir\":\"public/posts/2025-12-30-ai-era-developer-metrics\""
else
  log "MISSING" "public_post1_dir_missing" "initial" "C" "\"dir\":\"public/posts/2025-12-30-ai-era-developer-metrics\""
fi

if [ -d "$PUBLIC_POST2" ]; then
  log "EXISTS" "public_post2_dir_exists" "initial" "C" "\"dir\":\"public/posts/2025-12-22-trusted-execution-environments\""
else
  log "MISSING" "public_post2_dir_missing" "initial" "C" "\"dir\":\"public/posts/2025-12-22-trusted-execution-environments\""
fi

# Count pages built
PAGES_BUILT=$(echo "$BUILD_OUTPUT" | grep -o "[0-9]* pages" | head -1)
log "$PAGES_BUILT" "pages_built" "initial" "D" "\"pages\":\"$PAGES_BUILT\""

echo "Debug complete. Check $LOG_FILE for results."


