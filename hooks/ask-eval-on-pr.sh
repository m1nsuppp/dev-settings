#!/bin/bash

INPUT=$(cat)
SID=$(echo "$INPUT" | jq -r .session_id)
SENTINEL="/tmp/claude-eval-asked-$SID"

[ -f "$SENTINEL" ] && exit 0
touch "$SENTINEL"

REASON='PR 생성 직전입니다. AskUserQuestion 툴을 사용해 사용자에게 "/eval 스킬로 결과물 검토를 받으시겠습니까?"를 묻고, 선택지는 ["예, /eval 로 검토 받기", "아니오, 그대로 PR 생성"]으로 제시하세요. 응답에 따라 /eval 을 먼저 실행하거나 곧바로 gh pr create 를 재시도하세요.'

jq -nc --arg reason "$REASON" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "deny",
    permissionDecisionReason: $reason
  }
}'
