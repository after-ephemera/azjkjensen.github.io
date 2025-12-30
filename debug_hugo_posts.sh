#!/bin/bash
# Debug script to check Hugo post processing

LOG_FILE="/Users/jkjensen/dev/azjkjensen.github.io/.cursor/debug.log"
TIMESTAMP=$(date +%s)000

# Helper function to log NDJSON
log() {
  local msg="$1"
  local log_msg="$2"
  local run_id="${3:-initial}"
  local hyp_id="${4:-general}"
  local data="$5"
  echo "{\"timestamp\":$TIMESTAMP,\"location\":\"debug_hugo_posts.sh\",\"message\":\"$log_msg\",\"data\":{\"value\":\"$msg\",$data},\"sessionId\":\"debug-session\",\"runId\":\"$run_id\",\"hypothesisId\":\"$hyp_id\"}" >> "$LOG_FILE"
}

# Get current date for comparison
CURRENT_DATE=$(date +%s)
log "$CURRENT_DATE" "current_timestamp" "initial" "A" "\"currentDate\":$CURRENT_DATE"

# Check post files
POST_FILE="/Users/jkjensen/dev/azjkjensen.github.io/content/posts/2025-12-30-ai-era-developer-metrics.md"
if [ -f "$POST_FILE" ]; then
  log "$POST_FILE" "file_exists" "initial" "A" "\"file\":\"$POST_FILE\""
  
  # Extract date from frontmatter
  POST_DATE=$(grep -E "^date\s*=" "$POST_FILE" | head -1 | sed 's/date = //' | sed "s/'//g" | sed 's/"//g' | tr -d ' ')
  log "$POST_DATE" "post_date_from_frontmatter" "initial" "A" "\"postDate\":\"$POST_DATE\""
  
  # Check if date is in future (simple string comparison for 2025)
  if echo "$POST_DATE" | grep -q "2025"; then
    log "2025 detected" "future_year_detected" "initial" "A" "\"year\":2025"
  fi
else
  log "NOT_FOUND" "file_not_found" "initial" "A" "\"file\":\"$POST_FILE\""
fi

# Check if post appears in public HTML
HTML_POST_DIR="/Users/jkjensen/dev/azjkjensen.github.io/public/posts/2025-12-30-ai-era-developer-metrics"
if [ -d "$HTML_POST_DIR" ]; then
  log "$HTML_POST_DIR" "html_dir_exists" "initial" "B" "\"dir\":\"$HTML_POST_DIR\""
else
  log "MISSING" "html_dir_missing" "initial" "B" "\"dir\":\"$HTML_POST_DIR\""
fi

# Check if post appears in index.html
INDEX_HTML="/Users/jkjensen/dev/azjkjensen.github.io/public/index.html"
if [ -f "$INDEX_HTML" ]; then
  if grep -q "2025-12-30-ai-era-developer-metrics" "$INDEX_HTML"; then
    log "FOUND" "found_in_index_html" "initial" "C" "\"file\":\"index.html\""
  else
    log "NOT_FOUND" "not_in_index_html" "initial" "C" "\"file\":\"index.html\""
  fi
else
  log "MISSING" "index_html_missing" "initial" "C" "\"file\":\"index.html\""
fi

# Check posts/index.html
POSTS_INDEX="/Users/jkjensen/dev/azjkjensen.github.io/public/posts/index.html"
if [ -f "$POSTS_INDEX" ]; then
  if grep -q "2025-12-30-ai-era-developer-metrics" "$POSTS_INDEX"; then
    log "FOUND" "found_in_posts_index_html" "initial" "C" "\"file\":\"posts/index.html\""
  else
    log "NOT_FOUND" "not_in_posts_index_html" "initial" "C" "\"file\":\"posts/index.html\""
  fi
else
  log "MISSING" "posts_index_html_missing" "initial" "C" "\"file\":\"posts/index.html\""
fi

# Check XML feeds (these should include future posts)
XML_INDEX="/Users/jkjensen/dev/azjkjensen.github.io/public/index.xml"
if [ -f "$XML_INDEX" ]; then
  if grep -q "2025-12-30-ai-era-developer-metrics" "$XML_INDEX"; then
    log "FOUND" "found_in_xml" "initial" "D" "\"file\":\"index.xml\""
  else
    log "NOT_FOUND" "not_in_xml" "initial" "D" "\"file\":\"index.xml\""
  fi
fi

echo "Debug complete. Check $LOG_FILE for results."

