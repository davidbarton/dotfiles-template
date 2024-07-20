#!/bin/bash

# Use this script to safely checkout dotfiles git
# repository. It takes care of backing up any
# existing files that would be overwritten.

# Set git clone arguments to first script argument.
DOTFILES_GIT_CLONE_ARGS="$1"

# Exit with error if git clone arguments are empty.
if [ -z "$DOTFILES_GIT_CLONE_ARGS" ]; then
  echo "Error: repository URL not provided."
  exit 1
fi

# Define path for bare git repository.
DOTFILES_GIT_PATH=$HOME/.dotfiles/.git

# Exit with error if directory already exists.
if [ -d $DOTFILES_GIT_PATH ]; then
  echo "Error: directory $DOTFILES_GIT_PATH already exists."
  exit 1
fi

# Define path for work tree directory.
DOTFILES_WORK_TREE_PATH=$HOME

# Define function for dotfiles. Use git command with
# custom work tree and .git directory paths set.
function dotfiles {
  git --work-tree=$DOTFILES_WORK_TREE_PATH --git-dir=$DOTFILES_GIT_PATH "$@"
}

# Jump to work tree directory.
cd $DOTFILES_WORK_TREE_PATH

# Clone repository with --bare flag.
git clone --quiet --bare $DOTFILES_GIT_CLONE_ARGS $DOTFILES_GIT_PATH

# Don't show untracked files for "dotfiles status".
dotfiles config --local status.showUntrackedFiles no

# Try to quietly checkout files from repository.
dotfiles checkout > /dev/null 2>&1

# Run backup if checkout failed.
if [ $? -ne 0 ]; then

  # Define path for this backup.
  DOTFILES_BACKUP_PATH=$HOME/.dotfiles_backup_$(date +%s)

  # Inform user about backup.
  echo "Backing up existing files:"

  # Create backup directory structure.
  dotfiles checkout 2>&1 | grep -E "^\s+.+$" | xargs -I{} dirname $DOTFILES_BACKUP_PATH/{} | xargs -I{} mkdir -p {}

  # Move existing files to backup directory.
  dotfiles checkout 2>&1 | grep -E "^\s+.+$" | xargs -I{} mv {} $DOTFILES_BACKUP_PATH/{}

  # Inform user about backed up files.
  find $DOTFILES_BACKUP_PATH -type f

  # Try to checkout files from repository again.
  dotfiles checkout

  # Report error if checkout failed again.
  if [ $? -ne 0 ]; then
    # Inform user about backup failure.
    echo "Error: backup of existing files failed."
    exit 1
  fi
fi

# Inform user about success.
echo "Succesfully cloned dotfiles repository."
