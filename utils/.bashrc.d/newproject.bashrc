#!/usr/bin/env bash

# Configure these in your .bashrc if needed:
#   export PROJECTS_BASE_PATH="$HOME/projects"
#   export TMUXINATOR_CONFIG_PATH="$HOME/.config/tmuxinator"
PROJECTS_BASE_PATH="${PROJECTS_BASE_PATH:-$HOME/programming}"
TMUXINATOR_CONFIG_PATH="${TMUXINATOR_CONFIG_PATH:-$HOME/.config/tmuxinator}"

newproject() {
  local name="$1"
  local no_git=false

  # Parse flags
  shift
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --no-git)
        no_git=true
        shift
        ;;
      *)
        echo "Unknown option: $1"
        return 1
        ;;
    esac
  done

  if [[ -z "$name" ]]; then
    echo "Usage: newproject <project-name> [--no-git]"
    return 1
  fi

  local project_path="${PROJECTS_BASE_PATH}/${name}"

  # Create project directory
  if [[ -d "$project_path" ]]; then
    echo "Error: Directory already exists: $project_path"
    return 1
  fi

  mkdir -p "$project_path"
  echo "Created: $project_path"

  # Initialize git
  if [[ "$no_git" == false ]]; then
    git -C "$project_path" init
    echo "Initialized git repository"
  fi

  # Create tmuxinator config
  local tmux_config="${TMUXINATOR_CONFIG_PATH}/${name}.yml"
  if [[ -f "$tmux_config" ]]; then
    echo "Warning: tmuxinator config already exists: $tmux_config"
  else
    cat > "$tmux_config" << EOF
name: ${name}
root: ${project_path}

windows:
  - editor: nvim
  - shell: ''
  - git: ''
EOF
    echo "Created tmuxinator config: $tmux_config"
  fi

  echo ""
  echo "Project ready! Start with: tmuxinator start ${name}"
}

# Delete a project and its tmuxinator config
rmproject() {
  local name="$1"

  if [[ -z "$name" ]]; then
    echo "Usage: rmproject <project-name>"
    return 1
  fi

  local project_path="${PROJECTS_BASE_PATH}/${name}"
  local tmux_config="${TMUXINATOR_CONFIG_PATH}/${name}.yml"

  echo "This will delete:"
  [[ -d "$project_path" ]] && echo "  - $project_path"
  [[ -f "$tmux_config" ]] && echo "  - $tmux_config"

  read -p "Are you sure? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    [[ -d "$project_path" ]] && rm -rf "$project_path" && echo "Removed: $project_path"
    [[ -f "$tmux_config" ]] && rm "$tmux_config" && echo "Removed: $tmux_config"
  fi
}

# List projects
lsprojects() {
  ls -1 "$PROJECTS_BASE_PATH"
}
