#!/bin/bash
# Instala ffmpeg y las dependencias de video-use automáticamente en sesiones de Claude Code en la nube.

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"

if [ "$CLAUDE_CODE_REMOTE" = "true" ]; then
  if ! command -v ffmpeg >/dev/null 2>&1; then
    apt-get update && apt-get install -y ffmpeg
  fi

  if ! pip show video-use >/dev/null 2>&1 \
     || ! python3 -c "import requests, librosa, matplotlib, PIL, numpy" >/dev/null 2>&1; then
    pip install --break-system-packages -e "$PROJECT_DIR/.claude/skills/video-use"
  fi
fi

exit 0
