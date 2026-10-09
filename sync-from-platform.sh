#!/usr/bin/env bash
set -euo pipefail

SKILLS_REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
PLATFORM_ROOT="$SKILLS_REPO/../platform"
COPY_ONLY=false
SKILLS=(tiendu-theme tiendu-manager tiendu-merchant-center tiendu-bash tiendu-functions tiendu-meta-ads)

usage() {
	cat <<'EOF'
Usage: ./sync-from-platform.sh [--platform PATH] [--copy-only]

Copy the canonical skills from ../platform, commit the exported skill folders,
and push the current branch to origin. Requires a clean skills checkout.

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

for command in git rsync; do
	command -v "$command" >/dev/null 2>&1 || {
		printf 'Missing required command: %s\n' "$command" >&2
		exit 1
	}
done

SOURCE="$PLATFORM_ROOT/apps/merchant-center/src/lib/server/modules/manu/skills"
for skill in "${SKILLS[@]}"; do
	if [[ ! -f "$SOURCE/$skill/SKILL.md" || -L "$SOURCE/$skill" || -L "$SKILLS_REPO/$skill" ]]; then
		printf 'Expected regular skill folders with SKILL.md: %s\n' "$skill" >&2
		exit 1
	fi
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
	rsync -a --delete "$SOURCE/$skill/" "$SKILLS_REPO/$skill/"
done

if [[ "$COPY_ONLY" == true ]]; then
	printf 'Copied skills from %s. Review with git diff; no commit or push was made.\n' "$SOURCE"
	exit 0
fi

git -C "$SKILLS_REPO" add -- "${SKILLS[@]}"
if git -C "$SKILLS_REPO" diff --cached --quiet; then
	printf 'Published skill files already match the monorepo.\n'
else
	git -C "$SKILLS_REPO" commit -m 'Sync skills from the Tiendu monorepo'
fi
git -C "$SKILLS_REPO" push origin "$BRANCH"
