# Dotfiles

## How to use this repository?

1. Fork this repository
2. Clone your new fork

   ```bash
   # First download clone script
   curl -fsSLJO https://raw.githubusercontent.com/davidbarton/dotfiles-template/main/.dotfiles/scripts/clone.sh

   # Make it executable
   chmod +x clone.sh

   # Execute clone script, do not forget to use path to your fork
   ./clone.sh <repository>

   # You can delete clone script now
   rm clone.sh
   ```

3. Add an alias to your .zshrc (or .bashrc)

   ```bash
   alias dotfiles='git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'
   ```

4. Source updated .zshrc

   ```bash
   source .zhsrc
   ```

5. You are all setup and can start using it as any other git repo

   ```bash
   dotfiles add .gitconfig
   dotfiles commit -m "Add .gitconfig"
   ```
