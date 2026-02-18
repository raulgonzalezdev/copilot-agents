#!/usr/bin/env bash
set -euo pipefail

workspace_path=""
output_root=""
create_tar="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --workspace)
      workspace_path="${2:-}"
      shift 2
      ;;
    --output-root)
      output_root="${2:-}"
      shift 2
      ;;
    --tar)
      create_tar="true"
      shift
      ;;
    *)
      echo "Unknown arg: $1"
      exit 1
      ;;
  esac
done

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

detect_vscode_user_dir() {
  if [[ -n "${VSCODE_USER_DIR:-}" ]]; then
    echo "$VSCODE_USER_DIR"
    return
  fi

  case "$(uname -s)" in
    Darwin)
      echo "$HOME/Library/Application Support/Code/User"
      ;;
    Linux)
      echo "${XDG_CONFIG_HOME:-$HOME/.config}/Code/User"
      ;;
    *)
      if [[ -n "${APPDATA:-}" ]]; then
        echo "$APPDATA/Code/User"
      else
        echo "${XDG_CONFIG_HOME:-$HOME/.config}/Code/User"
      fi
      ;;
  esac
}

copy_if_exists() {
  local src="$1"
  local dst="$2"
  if [[ -e "$src" ]]; then
    mkdir -p "$(dirname "$dst")"
    cp -R "$src" "$dst"
    return 0
  fi
  return 1
}

if [[ -z "$output_root" ]]; then
  output_root="$repo_root/exports"
fi

vscode_user_dir="$(detect_vscode_user_dir)"
codex_home="${CODEX_HOME:-$HOME/.codex}"

stamp="$(date +%Y%m%d-%H%M%S)"
bundle_dir="$output_root/agent-config-$stamp"
mkdir -p "$bundle_dir"

copy_if_exists "$vscode_user_dir/prompts" "$bundle_dir/vscode/user/prompts" || true
copy_if_exists "$vscode_user_dir/settings.json" "$bundle_dir/vscode/user/settings.json" || true

if [[ -n "$workspace_path" && -d "$workspace_path" ]]; then
  copy_if_exists "$workspace_path/.vscode/agents" "$bundle_dir/workspace/.vscode/agents" || true
  copy_if_exists "$workspace_path/.vscode/instructions" "$bundle_dir/workspace/.vscode/instructions" || true
  copy_if_exists "$workspace_path/.vscode/prompts" "$bundle_dir/workspace/.vscode/prompts" || true
  copy_if_exists "$workspace_path/.vscode/settings.json" "$bundle_dir/workspace/.vscode/settings.json" || true
fi

copy_if_exists "$codex_home/config.toml" "$bundle_dir/codex/config.toml" || true
copy_if_exists "$codex_home/agents" "$bundle_dir/codex/agents" || true

if [[ -d "$codex_home/skills" ]]; then
  mkdir -p "$bundle_dir/codex/skills"
  while IFS= read -r -d '' d; do
    name="$(basename "$d")"
    if [[ "$name" == ".system" ]]; then
      continue
    fi
    cp -R "$d" "$bundle_dir/codex/skills/$name"
  done < <(find "$codex_home/skills" -mindepth 1 -maxdepth 1 -type d -print0)
fi

cat > "$bundle_dir/manifest.json" <<EOF
{
  "createdAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "workspacePath": "$(printf '%s' "$workspace_path" | sed 's/"/\\"/g')",
  "codexHome": "$(printf '%s' "$codex_home" | sed 's/"/\\"/g')",
  "vscodeUserDir": "$(printf '%s' "$vscode_user_dir" | sed 's/"/\\"/g')"
}
EOF

if [[ "$create_tar" == "true" ]]; then
  tar_path="$bundle_dir.tar.gz"
  tar -czf "$tar_path" -C "$bundle_dir" .
  echo "Bundle TAR: $tar_path"
fi

echo "Bundle folder: $bundle_dir"
echo "Export completed."
