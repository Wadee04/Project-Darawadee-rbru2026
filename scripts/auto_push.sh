#!/usr/bin/env bash
# ============================================================
# auto_push.sh — auto commit + push ขึ้น GitHub
# เรียกโดย Kiro hook เมื่อบันทึกไฟล์
# ============================================================
set -e

cd "$(git rev-parse --show-toplevel)" 2>/dev/null || exit 0

# ถ้าไม่มีอะไรเปลี่ยน ไม่ต้องทำอะไร
if git diff --quiet && git diff --cached --quiet; then
  exit 0
fi

# stage เฉพาะไฟล์ในโปรเจกต์ (เลี่ยง .dart_tool, build)
git add lib/ assets/ pubspec.yaml supabase_schema.sql supabase_mock_data.sql 2>/dev/null || true

# ถ้าไม่มีอะไร staged ก็จบ
if git diff --cached --quiet; then
  exit 0
fi

STAMP=$(date '+%Y-%m-%d %H:%M:%S')
git commit -m "auto: update ($STAMP)" >/dev/null 2>&1 || exit 0

# push แบบ background-safe
git push origin master >/dev/null 2>&1 || true
echo "pushed to origin/master at $STAMP"
