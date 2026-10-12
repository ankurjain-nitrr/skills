#!/usr/bin/env bash
# Checks which skills fire on a set of prompts. Each prompt runs in a fresh headless Claude Code
# session with only the given plugins loaded, in a throwaway copy of REPO, with file-changing,
# shell, subagent and web tools blocked, so a triggered skill can't change anything.
#
# Usage: trigger-test.sh <queries.tsv> <plugin-dir>...
#   queries.tsv lines: <skill>\t<T|N>\t<prompt>   (T: should trigger, N: should not)
#   <skill> matches the invoked skill's name with or without its plugin prefix.
# Env: REPO   directory copied as each session's working directory (default: an empty git repo)
#      RUNS   runs per prompt (default 1; use 3 to get a trigger rate)
#      JOBS   parallel sessions (default 4)
#      LIMIT  seconds per session (default 150)
set -euo pipefail

if [ "${1:-}" = --one ]; then
  # Internal: one session. Args: --one <work> <id> <prompt>
  work=$2 id=$3 prompt=$4
  run="$work/run-$id"; cp -R "$work/repo" "$run"
  mapfile -t plugins < "$work/plugins" 2>/dev/null || { plugins=(); while IFS= read -r l; do plugins+=("$l"); done < "$work/plugins"; }
  args=(); for p in "${plugins[@]}"; do args+=(--plugin-dir "$p"); done
  cd "$run"
  # perl alarm: macOS has no `timeout`.
  perl -e 'alarm shift; exec @ARGV' "${LIMIT:-150}" claude -p "$prompt" \
    --output-format stream-json --verbose --no-session-persistence \
    --setting-sources project "${args[@]}" \
    --disallowedTools Bash Edit Write NotebookEdit Agent WebFetch WebSearch \
    > "$work/$id.jsonl" 2>/dev/null || true
  exit 0
fi

[ $# -ge 2 ] || { sed -n '2,13p' "$0"; exit 2; }
queries=$(cd "$(dirname "$1")" && pwd)/$(basename "$1"); shift
work=$(mktemp -d)
for p in "$@"; do (cd "$p" && pwd); done > "$work/plugins"
if [ -n "${REPO:-}" ]; then cp -R "$REPO" "$work/repo"
else mkdir "$work/repo" && git -C "$work/repo" init -q; fi

runs=${RUNS:-1}; n=0
while IFS=$'\t' read -r skill exp prompt; do
  [ -n "$skill" ] || continue; n=$((n + 1))
  for r in $(seq 1 "$runs"); do printf '%s\0%s\0%s\0' "$work" "$n-$r" "$prompt"; done
done < "$queries" | xargs -0 -n 3 -P "${JOBS:-4}" "$0" --one

python3 -I - "$queries" "$work" "$runs" <<'PY'
import json, sys
queries, work, runs = sys.argv[1], sys.argv[2], int(sys.argv[3])
rows = [l.rstrip("\n").split("\t", 2) for l in open(queries) if l.strip()]
passed = 0
for i, (skill, exp, prompt) in enumerate(rows, 1):
    hits, seen = 0, set()
    for r in range(1, runs + 1):
        invoked = []
        try:
            for line in open(f"{work}/{i}-{r}.jsonl"):
                try: m = json.loads(line)
                except ValueError: continue
                msg = m.get("message")
                if not isinstance(msg, dict): continue  # some events carry message as a string
                for c in msg.get("content") or []:
                    if isinstance(c, dict) and c.get("type") == "tool_use" and c.get("name") == "Skill":
                        invoked.append(c["input"].get("skill", ""))
        except FileNotFoundError: pass
        seen.update(invoked)
        hits += any(s == skill or s.endswith(":" + skill) for s in invoked)
    rate = hits / runs
    ok = rate >= 0.5 if exp == "T" else rate < 0.5
    passed += ok
    print(f"{'PASS' if ok else 'FAIL'}  {skill:<16} {exp}  rate {rate:.2f}  invoked {sorted(seen)}  {prompt[:70]}")
print(f"\n{passed}/{len(rows)} passed  (transcripts: {work})")
PY
