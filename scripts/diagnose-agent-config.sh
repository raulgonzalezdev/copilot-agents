#!/usr/bin/env bash
set -euo pipefail

workspace_path="${1:-}"

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

vscode_user_dir="$(detect_vscode_user_dir)"
codex_home="${CODEX_HOME:-$HOME/.codex}"

echo "=== Codex ==="
echo "CODEX_HOME: $codex_home"
echo "config.toml: $([[ -f "$codex_home/config.toml" ]] && echo true || echo false)"
if [[ -f "$codex_home/config.toml" ]]; then
  sed 's/^/  /' "$codex_home/config.toml"
fi

echo
echo "skills path: $([[ -d "$codex_home/skills" ]] && echo true || echo false)"
if [[ -d "$codex_home/skills" ]]; then
  find "$codex_home/skills" -mindepth 1 -maxdepth 1 -type d -printf "  - %f\n"
fi
echo "super skill datqbox-super-orchestrator: $([[ -d "$codex_home/skills/datqbox-super-orchestrator" ]] && echo true || echo false)"

echo
echo "=== VS Code Global ==="
echo "prompts dir: $([[ -d "$vscode_user_dir/prompts" ]] && echo true || echo false) -> $vscode_user_dir/prompts"
echo "settings.json: $([[ -f "$vscode_user_dir/settings.json" ]] && echo true || echo false) -> $vscode_user_dir/settings.json"

if [[ -n "$workspace_path" && -d "$workspace_path" ]]; then
  echo
  echo "=== Workspace ==="
  echo "workspace: $workspace_path"
  for dir in agents instructions prompts; do
    if [[ -d "$workspace_path/.vscode/$dir" ]]; then
      count="$(find "$workspace_path/.vscode/$dir" -maxdepth 1 -type f | wc -l | tr -d ' ')"
      echo "$dir: true ($count archivos)"
    else
      echo "$dir: false (0 archivos)"
    fi
  done
  echo "settings.json: $([[ -f "$workspace_path/.vscode/settings.json" ]] && echo true || echo false)"
fi

echo
echo 'Cómo activar super agente en chat: $datqbox-super-orchestrator'
