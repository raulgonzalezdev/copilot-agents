#!/usr/bin/env bash
set -euo pipefail

bundle_path=""
workspace_path=""
install_scope="both"
apply_codex_agents="false"
apply_codex_skills="false"
restore_codex_config="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --bundle)
      bundle_path="${2:-}"
      shift 2
      ;;
    --workspace)
      workspace_path="${2:-}"
      shift 2
      ;;
    --scope)
      install_scope="${2:-}"
      shift 2
      ;;
    --apply-codex-agents)
      apply_codex_agents="true"
      shift
      ;;
    --apply-codex-skills)
      apply_codex_skills="true"
      shift
      ;;
    --restore-codex-config)
      restore_codex_config="true"
      shift
      ;;
    *)
      echo "Unknown arg: $1"
      exit 1
      ;;
  esac
done

if [[ -z "$bundle_path" || ! -d "$bundle_path" ]]; then
  echo "Invalid --bundle path"
  exit 1
fi

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

copy_children_if_exists() {
  local src="$1"
  local dst="$2"
  if [[ -d "$src" ]]; then
    mkdir -p "$dst"
    cp -R "$src"/. "$dst"/
    return 0
  fi
  return 1
}

copy_file_if_exists() {
  local src="$1"
  local dst="$2"
  if [[ -f "$src" ]]; then
    mkdir -p "$(dirname "$dst")"
    cp "$src" "$dst"
    return 0
  fi
  return 1
}

vscode_user_dir="$(detect_vscode_user_dir)"
codex_home="${CODEX_HOME:-$HOME/.codex}"

if [[ "$install_scope" == "workspace" || "$install_scope" == "both" ]]; then
  if [[ -z "$workspace_path" || ! -d "$workspace_path" ]]; then
    echo "--workspace is required for scope=$install_scope"
    exit 1
  fi

  copy_children_if_exists "$bundle_path/workspace/.vscode/agents" "$workspace_path/.vscode/agents" || true
  copy_children_if_exists "$bundle_path/workspace/.vscode/instructions" "$workspace_path/.vscode/instructions" || true
  copy_children_if_exists "$bundle_path/workspace/.vscode/prompts" "$workspace_path/.vscode/prompts" || true
  copy_file_if_exists "$bundle_path/workspace/.vscode/settings.json" "$workspace_path/.vscode/settings.json" || true
  echo "Workspace restored: $workspace_path/.vscode"
fi

if [[ "$install_scope" == "global" || "$install_scope" == "both" ]]; then
  copy_children_if_exists "$bundle_path/vscode/user/prompts" "$vscode_user_dir/prompts" || true
  copy_file_if_exists "$bundle_path/vscode/user/settings.json" "$vscode_user_dir/settings.json" || true
  echo "VS Code global restored: $vscode_user_dir"
fi

if [[ "$apply_codex_skills" == "true" ]]; then
  copy_children_if_exists "$bundle_path/codex/skills" "$codex_home/skills" || true
  echo "Codex skills restored: $codex_home/skills"
fi

if [[ "$apply_codex_agents" == "true" ]]; then
  copy_children_if_exists "$bundle_path/codex/agents" "$codex_home/agents" || true
  echo "Codex agent roles restored: $codex_home/agents"
fi

if [[ "$restore_codex_config" == "true" ]]; then
  copy_file_if_exists "$bundle_path/codex/config.toml" "$codex_home/config.toml" || true
  echo "Codex config restored: $codex_home/config.toml"
fi

echo "Import completed. Restart VS Code/Codex."
