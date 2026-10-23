#!/bin/bash
# Instala ffmpeg automáticamente en sesiones de Claude Code en la nube.

if [ "$CLAUDE_CODE_REMOTE" = "true" ] && ! command -v ffmpeg >/dev/null 2>&1; then
  apt-get update && apt-get install -y ffmpeg
fi

exit 0
