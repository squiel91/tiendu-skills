#!/usr/bin/env bash
set -euo pipefail

SKILLS_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
PLATFORM_ROOT="$SKILLS_REPO/../platform"
COPY_ONLY=false

usage() {
	cat <<'EOF'
Usage: ./sync-from-platform.sh [--platform PATH] [--copy-only]

Copy the skills flagged "public" in the monorepo's packages/skills/skills.config.json,
skipping Manu-only manu.md files, remove skill folders that are no longer public,
commit the result, and push the current branch to origin. Requires a clean checkout.

  --platform PATH  Use another platform checkout as the source
  --copy-only      Copy the files for review without committing or pushing
EOF
}

while [[ $# -gt 0 ]]; do
	case "$1" in
		--platform)
			[[ $# -ge 2 && -n "$2" ]] || { usage >&2; exit 1; }
			PLATFORM_ROOT="$2"
			shift 2
			;;
		--copy-only) COPY_ONLY=true; shift ;;
		--help|-h) usage; exit 0 ;;
		*) printf 'Unknown argument: %s\n' "$1" >&2; usage >&2; exit 1 ;;
	esac
done

for command in git rsync node; do
	command -v "$command" >/dev/null 2>&1 || {
		printf 'Missing required command: %s\n' "$command" >&2
		exit 1
	}
done

SOURCE="$PLATFORM_ROOT/packages/skills"
CONFIG="$SOURCE/skills.config.json"
[[ -f "$CONFIG" ]] || { printf 'Missing skills config: %s\n' "$CONFIG" >&2; exit 1; }

mapfile -t SKILLS < <(node -e '
	const config = JSON.parse(require("fs").readFileSync(process.argv[1], "utf8"))
	for (const [name, flags] of Object.entries(config)) if (flags.public === true) console.log(name)
' "$CONFIG")
[[ ${#SKILLS[@]} -gt 0 ]] || { printf 'No skills are flagged public in %s\n' "$CONFIG" >&2; exit 1; }

for skill in "${SKILLS[@]}"; do
	if [[ ! "$skill" =~ ^[a-z0-9][a-z0-9-]*$ || ! -f "$SOURCE/$skill/SKILL.md" || -L "$SOURCE/$skill" || -L "$SKILLS_REPO/$skill" ]]; then
		printf 'Expected regular skill folders with SKILL.md: %s\n' "$skill" >&2
		exit 1
	fi
done

# Top-level skill folders here that are no longer published.
RETIRED=()
for dir in "$SKILLS_REPO"/*/; do
	name="$(basename "$dir")"
	[[ -f "$dir/SKILL.md" ]] || continue
	[[ " ${SKILLS[*]} " == *" $name "* ]] || RETIRED+=("$name")
done

if [[ "$COPY_ONLY" == false ]]; then
	if [[ -n "$(git -C "$SKILLS_REPO" status --porcelain)" ]]; then
		printf 'The skills checkout has local changes. Commit or preserve them before publishing; use --copy-only to review the export.\n' >&2
		exit 1
	fi
	BRANCH="$(git -C "$SKILLS_REPO" symbolic-ref --quiet --short HEAD)" || {
		printf 'Publishing requires a checked-out branch.\n' >&2
		exit 1
	}
	git -C "$SKILLS_REPO" remote get-url origin >/dev/null
fi

for skill in "${SKILLS[@]}"; do
	mkdir -p "$SKILLS_REPO/$skill"
	# manu.md files are Manu-only instructions and never leave the monorepo.
	rsync -a --delete --delete-excluded --exclude 'manu.md' "$SOURCE/$skill/" "$SKILLS_REPO/$skill/"
done
for skill in "${RETIRED[@]}"; do
	rm -rf "${SKILLS_REPO:?}/$skill"
done

if [[ "$COPY_ONLY" == true ]]; then
	printf 'Copied %s from %s. Review with git status and git diff; no commit or push was made.\n' "${SKILLS[*]}" "$SOURCE"
	exit 0
fi

git -C "$SKILLS_REPO" add -A -- "${SKILLS[@]}" "${RETIRED[@]}"
if git -C "$SKILLS_REPO" diff --cached --quiet; then
	printf 'Published skill files already match the monorepo.\n'
else
	git -C "$SKILLS_REPO" commit -m 'Sync skills from the Tiendu monorepo'
fi
git -C "$SKILLS_REPO" push origin "$BRANCH"
