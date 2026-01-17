
#!/usr/bin/env bash

# git-tmux-worktree.sh
# Script to create/remove git worktrees and corresponding tmux sessions

set -e

REPO_ROOT=$(git rev-parse --show-toplevel)
WORKTREE_ROOT="${REPO_ROOT}/../worktrees"

function usage() {
    echo "Usage:"
    echo "  $0 create [<branch-name>]  - Create a new worktree and tmux session (uses current branch as base)"
    echo "  $0 remove [<branch-name>]  - Remove the worktree and tmux session (defaults to current branch)"
    exit 1
}

function copy_gitignored_files() {
    local source_dir="$1"
    local dest_dir="$2"
    
    # List of files to copy (gitignored files)
    local files=(".env" ".npmrc" ".env.local" ".env.development" ".env.production" ".prettierrc.local" ".eslintrc.local")
    
    for file in "${files[@]}"; do
        local source_file="${source_dir}/${file}"
        if [ -f "${source_file}" ]; then
            cp "${source_file}" "${dest_dir}/" 2>/dev/null || true
        fi
    done
}

function create_worktree() {
    local branch="$1"
    local base_branch="${2:-staging}"  # Default to 'staging' if no base branch specified
    local worktree_path="${WORKTREE_ROOT}/${branch}"
    
    # Create worktree directory if it doesn't exist
    mkdir -p "${WORKTREE_ROOT}"
    
    # Check if branch exists
    if git show-ref --verify --quiet "refs/heads/${branch}"; then
        # Branch exists, create worktree from it
        echo "Creating worktree for existing branch '${branch}'..."
        git worktree add "${worktree_path}" "${branch}"
    else
        # Branch doesn't exist, create it from base branch
        echo "Creating new branch '${branch}' from '${base_branch}' and setting up worktree..."
        git worktree add -b "${branch}" "${worktree_path}" "${base_branch}"
    fi
    
    # Copy gitignored files
    copy_gitignored_files "${REPO_ROOT}" "${worktree_path}"
    
    # Create tmux session with specific window layout
    create_tmux_session "${branch}" "${worktree_path}"
    
    echo "Worktree and tmux session for branch '${branch}' created successfully!"
    echo "To attach to the tmux session, run: tmux attach-session -t ${branch}"
}

function create_tmux_session() {
    local branch="$1"
    local worktree_path="$2"
    
    # Kill existing session if it exists
    tmux kill-session -t "${branch}" 2>/dev/null || true
    
    # Create new session with nvim as the first window
    tmux new-session -d -s "${branch}" -c "${worktree_path}" -n "vim"
    tmux send-keys -t "${branch}:vim" "nvim ." C-m
    
    # Create server window
    tmux new-window -t "${branch}" -c "${worktree_path}" -n "server"
    
    # Create lazyGit window
    tmux new-window -t "${branch}" -c "${worktree_path}" -n "lazyGit"
    tmux send-keys -t "${branch}:lazyGit" "lazygit || git status" C-m
    
    # Create randomDataLog window
    tmux new-window -t "${branch}" -c "${worktree_path}" -n "randomDataLog"
    tmux send-keys -t "${branch}:randomDataLog" "/tmp" C-m
    
    # Select the first window (nvim)
    tmux select-window -t "${branch}:1"
}

function remove_worktree() {
    local branch="$1"
    local worktree_path="${WORKTREE_ROOT}/${branch}"
    
    # Check if worktree exists
    if [ ! -d "${worktree_path}" ]; then
        echo "Worktree for branch '${branch}' not found at ${worktree_path}"
        exit 1
    fi
    
    # Kill tmux session if it exists
    tmux kill-session -t "${branch}" 2>/dev/null || true
    
    # Remove worktree
    echo "Removing worktree for branch '${branch}'..."
    git worktree remove --force "${worktree_path}"
    
    # Optionally delete the branch
    read -p "Do you want to delete the branch '${branch}' as well? [y/N] " delete_branch
    if [[ "${delete_branch}" =~ ^[Yy]$ ]]; then
        git branch -D "${branch}"
        echo "Branch '${branch}' deleted."
    fi
    
    echo "Worktree and tmux session for branch '${branch}' removed successfully!"
}

# Main script
if [ $# -lt 1 ]; then
    usage
fi

ACTION="$1"
# Get current branch name (this will be both the branch and base branch by default)
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
BRANCH=${2:-$CURRENT_BRANCH}  # Use provided branch name or current branch if none provided
BASE_BRANCH=$CURRENT_BRANCH   # Use current branch as base branch

# Execute requested action
case "${ACTION}" in
    create)
        create_worktree "${BRANCH}" "${BASE_BRANCH}"
        ;;
    remove)
        # For remove, allow specifying branch to remove or use current branch
        REMOVE_BRANCH=${2:-$CURRENT_BRANCH}
        remove_worktree "${REMOVE_BRANCH}"
        ;;
    *)
        usage
        ;;
esac
