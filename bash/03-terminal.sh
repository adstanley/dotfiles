#################################################################################
#####                           Terminal Title                              #####
#################################################################################

## Change title of terminals
case ${TERM} in
xterm* | rxvt* | Eterm* | aterm | kterm | gnome* | alacritty | st | konsole*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
    ;;

screen*)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
    ;;
esac

# IDK man left it in from the default bashrc
# If using debian, set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
