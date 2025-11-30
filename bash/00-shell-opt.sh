#################################################################################
#####                          SHELL OPTIONS                                #####
#################################################################################

# Set options
set -o noclobber # Prevent overwriting files
# set -o vi             # Set vi mode, Allows for vi keybindings in the terminal

# Shopt Options
shopt -s autocd         # change to named directory
shopt -s cdspell        # autocorrects cd misspellings
shopt -s dotglob        # include hidden files in globbing
shopt -s expand_aliases # expand aliases
shopt -s checkwinsize   # checks term size when bash regains control
shopt -s extglob        # extended pattern matching
shopt -s globstar       # recursive globbing
shopt -s histverify     # show command with history expansion to allow editing
shopt -s nullglob       # null globbing, no match returns null
