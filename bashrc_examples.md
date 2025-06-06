# bashrc - Basic

```bash
#!/usr/bin/env bash
# shellcheck disable=SC2034
# shellcheck disable=SC2162

######################################################################
#
#
#           ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗
#           ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔════╝
#           ██████╔╝███████║███████╗███████║██████╔╝██║     
#           ██╔══██╗██╔══██║╚════██║██╔══██║██╔══██╗██║     
#           ██████╔╝██║  ██║███████║██║  ██║██║  ██║╚██████╗
#           ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
#
#
######################################################################

set -o vi

HISTTIMEFORMAT="%F %T "

HISTCONTROL=ignoredups

HISTSIZE=2000

HISTFILESIZE=2000

shopt -s histappend

blk='\[\033[01;30m\]'   # Black
red='\[\033[01;31m\]'   # Red
grn='\[\033[01;32m\]'   # Green
ylw='\[\033[01;33m\]'   # Yellow
blu='\[\033[01;34m\]'   # Blue
pur='\[\033[01;35m\]'   # Purple
cyn='\[\033[01;36m\]'   # Cyan
wht='\[\033[01;37m\]'   # White
clr='\[\033[00m\]'      # Reset

alias gs='git status'

alias ga='git add'

alias gaa='git add --all'

alias gc='git commit'

alias gl='git log --oneline'

alias gb='git checkout -b'

alias gd='git diff'

alias ..='cd ..;pwd'

alias ...='cd ../..;pwd'

alias ....='cd ../../..;pwd'

alias c='clear'

alias h='history'

alias tree='tree --dirsfirst -F'

alias mkdir='mkdir -p -v'

alias jan='cal -m 01'
alias feb='cal -m 02'
alias mar='cal -m 03'
alias apr='cal -m 04'
alias may='cal -m 05'
alias jun='cal -m 06'
alias jul='cal -m 07'
alias aug='cal -m 08'
alias sep='cal -m 09'
alias oct='cal -m 10'
alias nov='cal -m 11'
alias dec='cal -m 12'

function hg() {
    history | grep "$1";
}

function find_largest_files() {
    du -h -x -s -- * | sort -r -h | head -20;
}

function git_branch() {
    if [ -d .git ] ; then
        printf "%s" "($(git branch 2> /dev/null | awk '/\*/{print $2}'))";
    fi
}

# Set the prompt.
function bash_prompt(){
    PS1='${debian_chroot:+($debian_chroot)}'${blu}'$(git_branch)'${pur}' \W'${grn}' \$ '${clr}
}

bash_prompt

function git_init() {
    if [ -z "$1" ]; then
        printf "%s\n" "Please provide a directory name.";
    else
        mkdir "$1";
        builtin cd "$1";
        pwd;
        git init;
        touch readme.md .gitignore LICENSE;
        echo "# $(basename $PWD)" >> readme.md
    fi
}

function weather_report() {

    local response
    response=$(curl --silent 'https://api.openweathermap.org/data/2.5/weather?id=5128581&units=imperial&appid=<YOUR_API_KEY>') 

    local status
    status=$(echo $response | jq -r '.cod')

    case $status in
		
        200) printf "Location: %s %s\n" "$(echo $response | jq '.name') $(echo $response | jq '.sys.country')"  
             printf "Forecast: %s\n" "$(echo $response | jq '.weather[].description')" 
             printf "Temperature: %.1f°F\n" "$(echo $response | jq '.main.temp')" 
             printf "Temp Min: %.1f°F\n" "$(echo $response | jq '.main.temp_min')" 
             printf "Temp Max: %.1f°F\n" "$(echo $response | jq '.main.temp_max')" 
            ;;
        401) echo "401 error"
            ;;
        *) echo "error"
            ;;

    esac

}

clear

printf "\n"
printf "   %s\n" "IP ADDR: $(curl ifconfig.me)"
printf "   %s\n" "USER: $(echo $USER)"
printf "   %s\n" "DATE: $(date)"
printf "   %s\n" "UPTIME: $(uptime -p)"
printf "   %s\n" "HOSTNAME: $(hostname -f)"
printf "   %s\n" "CPU: $(awk -F: '/model name/{print $2}' | head -1)"
printf "   %s\n" "KERNEL: $(uname -rms)"
printf "   %s\n" "PACKAGES: $(dpkg --get-selections | wc -l)"
printf "   %s\n" "RESOLUTION: $(xrandr | awk '/\*/{printf $1" "}')"
printf "   %s\n" "MEMORY: $(free -m -h | awk '/Mem/{print $3"/"$2}')"
printf "\n"
```


# bashrc - Another one to take from

```bash
##################
# bashrc - Basic #
##################

#Last updated: 2023/07/17

# This file is essentially designed so you can just copy and paste to
# your ~/.bashrc file. Many of these aliases and functions are included
# with the latest version of PsychOS (https://psychoslinux.gitlab.io)
# and a few of them are not but may be in the next release. If you have
# a suggestion or something needs corrected, let me know. USE AT YOUR
# OWN RISK.

# Find out what is taking so much space on your drives
alias diskspace="du -S | sort -n -r | less"

# Easy way to extract archives.
# Technically you can just use '7z x' for just about everything if
# 'p7zip' is installed, but the following are just in case.
extract () {
   if [ -f "$1" ] ; then
       case "$1" in
           *.tar.bz2)   tar xvjf "$1"    ;;
           *.tar.gz)    tar xvzf "$1"    ;;
           *.bz2)       bunzip2 "$1"     ;;
           *.rar)       unrar x "$1"     ;;
           *.gz)        gunzip "$1"      ;;
           *.tar)       tar xvf "$1"     ;;
           *.tbz2)      tar xvjf "$1"    ;;
           *.tgz)       tar xvzf "$1"    ;;
           *.zip)       unzip "$1"       ;;
           *.Z)         uncompress "$1"  ;;
           *.7z)        7z x "$1"        ;;
           *)           echo "I don't know how to extract $1..." ;;
       esac
   else
       echo "'$1' is not a valid file!"
   fi
}

#Create a .7z compressed file; though, I am not saying '7z a...' is not
#easy enough to do but for some people, maybe not because of putting
#the output file before the input.
#Use as: 7zip "/path/to/folder_or_file" "/path/to/output.7z"
function 7zip() { 7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on -mhe=on "$2" "$1"; }

#Create password protected .7z compressed file and hide file-list
#Use as: 7zp "/path/to/output.7z" "/path/to/folder_or_file"
alias 7zp='7z a -bd -bb1 -y -p -mhe=on -mx=7'

# Add color in manpages for less
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Move 'up' so many directories instead of using several cd ../../, etc.
# Use as: up #
up() { cd $(eval printf '../'%.0s {1..$1}) && pwd; }

#Another variation of the one above
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."


# Common variations of 'ls' command
alias ll="ls -l"
alias lo="ls -o"
alias lh="ls -lh"
alias la="ls -la"
alias sl="ls"
alias l="ls"
alias s="ls"

#List people in a Twitch channel chat
function twitch_list() { curl -s "https://tmi.twitch.tv/group/user/$1/chatters" | less; }

#Nano for writing and help with spell-checking
alias nano="nano -m -u -c -W --tabsize=4 --autoindent"
alias writer="nano -m -u -c -W -l --tabsize=4 --fill=85 --autoindent --smooth"
function spellcheck() { aspell -c "$1"; }
function spell() { echo "$1" | aspell -a; }

#The following is for spellchecking SGML/XML-like documents of project
#files. 'Scribus' is a free and open-source desktop publishing program.
function spellchecksgml() { aspell --lang=en --encoding=utf-8 --mode=sgml --add-sgml-check=ch check "$1" ; }
alias spellcheckxml=spellchecksgml
alias spellcheckscribus=spellchecksgml

# Print a word from a certain column of the output when piping.
# Example: cat /path/to/file.txt | fawk 2
#    This example prints every 2nd word on each line of file.txt
function fawk {
    first="awk '{print "
    last="}'"
    cmd="${first}\$${1}${last}"
    eval $cmd
}

#Print the last line of all logs within the "/var/log" directory
alias logs="find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"

# Colors for all grep commands such as grep, egrep and zgrep
export GREP_OPTIONS='--color=auto'

# Git related
alias gs='git status'
alias gc='git commit'
alias ga='git add'
alias gd='git diff'
alias gb='git branch'
alias gl='git log'
alias gsb='git show-branch'
alias gco='git checkout'
alias gg='git grep'
alias gk='gitk --all'
alias gr='git rebase'
alias gri='git rebase --interactive'
alias gcp='git cherry-pick'
alias grm='git rm'

# 'cd' to the most recently modified directory in $PWD
cl()
{
        last_dir="$(ls -Frt | grep '/$' | tail -n1)"
        if [ -d "$last_dir" ]; then
                cd "$last_dir"
        fi
}

# Directory bookmarking (one at a time)
rd(){
    pwd > "$HOME/.lastdir_$1"
}

crd(){
        lastdir="$(cat "$HOME/.lastdir_$1")">/dev/null 2>&1
        if [ -d "$lastdir" ]; then
                cd "$lastdir"
        else
                echo "no existing directory stored in buffer $1">&2
        fi
}

# 'cd' into a directory and then list contents
cdls() { cd "$1"; ls;}

#For when you've spent too much time in DOS
alias cls="clear"
alias dir="ls"
alias deltree="rm -r"
alias rmdir="rm -r"
alias rd="rm -r"
alias rename="mv"
alias cd..="cd .."
alias chdir="pwd"
alias cmd="bash"
function edit() { nano -m -u -c -b -l --tabsize=4 --fill=72 --atblanks --autoindent "$1" && unix2dos "$1" ; }
alias erase="rm"
alias del="rm"
alias delete="rm"
alias expand="extract"
diskcopy(){ dd if="$1" of="$2" ; }
alias tasklist="htop"
alias tracert="traceroute"

#Generate a random, "strong" (hopefully) password
alias genpasswd="strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo"

#HOWEVER, if you are using an older/lighter operating system, such as a
#Raspberry Pi 3, you may want to get over it and try the following
#function to generate a random password instead; uncomment to prefer its
#use. Change the "-n8" part to a higher number if you want it to be 
#longer.
#alias genpasswd="echo $(shuf -er -n8 {A..Z} {a..z} {0..9}| tr -d '\n')"

#Expand current directory structure in tree form
alias treed="ls -R | grep ":$" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"

#List directories by in order of size in current directory
sbs() { du -b --max-depth 1 | sort -nr | perl -pe 's{([0-9]+)}{sprintf "%.1f%s", $1>=2**30? ($1/2**30, "G"): $1>=2**20? ($1/2**20, "M"): $1>=2**10? ($1/2**10, "K"): ($1, "")}e';} 

#Show active ports
alias activeports='netstat -tulanp'

#Uses 'nmap' to scan all of the connected devices on your router
#You may need to change the '192.168.0.*' part to better match how your 
#router gives addresses. This will most likely not give you hostnames, 
#only MAC addresses.
alias lanscan='sudo nmap -sn 192.168.0.*'

#Kill any lingering SSH processes
function sshkill() { ps aux | grep ssh | grep -v grep | grep -v sshd | awk {'print $2'} | xargs -r kill -9; }

#Rough function to display the number of unread emails in your gmail;
#HOWEVER, I am Google-free these days, so I have no idea if this still
#works...
#
#    Usage: gmail [user name]
#
gmail() { curl -u "$1" --silent "https://mail.google.com/mail/feed/atom" | sed -e 's/<\/fullcount.*/\n/' | sed -e 's/.*fullcount>//'; }

#Use one of the following for when the boss comes around to look busy...
#But remember, as mentioned before, the /dev/urandom may cause some
#serious slow-down issues on older/lighter hardware.
alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"
function busytext() { while true; do sleep .15; head /dev/urandom | tr -dc A-Za-z0-9; done; }

#Print last value returned from previous command
lastvalue='RET=$?; if [[ $RET -eq 0 ]]; then echo -ne "\033[0;32m$RET\033[0m ;)"; else echo -ne "\033[0;31m$RET\033[0m ;("; fi; echo -n " "'

#Translator; requires Internet
#
#    Usage: translate <phrase> <output-language> 
#    Example: translate "Bonjour! Ca va?" en 
#
#See this for a list of language codes: 
#http://en.wikipedia.org/wiki/List_of_ISO_639-1_codes
#
function translate(){ wget -U "Mozilla/5.0" -qO - "http://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=$2&dt=t&q=$(echo $1 | sed "s/[\"'<>]//g")" | sed "s/,,,0]],,.*//g" | awk -F'"' '{print $2, $6}'; }


#-----------------------------------------------------------------------
#Prints (or creates if not there) a task list when a terminal is opened
#
#    Usage taskadd: taskadd 'Make sure to water the flowers'
#    Usage taskin:  taskin 'Insert a task on line 3' 3
#    Usage taskrm:  taskram 4 #Removes fourth item on the list
#    Usage taskcl:  taskcl #Clear all tasks 
#
TASKFILE="$HOME/.bashtask" #Hidden for neatness
NC='\033[0m' # No Color
LIGHTRED='\e[1;31m'
LIGHTBLUE='\e[1;34m'
if [ -f "$TASKFILE" ] && [ $(stat -c %s "$TASKFILE") != 0 ] #Check if file has content
then
    echo -e "${LIGHTRED}Task List${NC} as of ${LIGHTBLUE}$(date -r "$TASKFILE")${NC}"
    echo ""
    cat "$TASKFILE"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "-"
else
    echo "Yay! No tasks :)"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' "-"
    touch "$TASKFILE"
fi
alias tasklist="bash"
function taskadd() { echo "- $1" >> "$TASKFILE"; } #Example: taskadd "Go grocery shopping"
function taskin() { sed -i "$1i- $2" "$TASKFILE"; } #Insert a task between items
function taskrm() { sed -i "$1d" "$TASKFILE"; } #Example: taskrm 2 --> Removes second item in list
function taskcl() { rm "$TASKFILE"; touch "$TASKFILE"; } #Delete and create a new taskfile
#-----------------------------------------------------------------------


#Converting audio and video files using ffmpeg and eyeD3 
#(sudo pip install eyeD3). Album art is removed in the '2ogg' function 
#because if you are using ogg, you probably either do not need it or 
#want to save as much space as possible. The '2voc' is very useful when 
#dealing with DOOM WADS or certain DOS software. If you need to cancel a
#conversion that uses FFmpeg, use CTRL+C as 'q' will still delete the 
#original and then leave you with a partially converted file. If you
#hate the idea of deleting the original file, remove the '&& rm "$1"'
#parts at the end.
#
#    Usage example: 2ogg '/path/to/file.ext'
#
function 2ogg() { eyeD3 --remove-all-images "$1"; echo "" && echo "Converting using SoX..." && sox "$1" "${1%%.*}.ogg" && rm "$1" ; }
function 2wav() { ffmpeg -hide_banner -threads 0 -i "$1" "${1%%.*}.wav" && rm "$1"; }
function 2doswav() { ffmpeg -hide_banner -threads 0 -i "$1" -ar 11025 -acodec pcm_u8 -ac 1 "${1%%.*}_DOS.WAV" && rm "$1"; }
function 2doswav8() { ffmpeg -hide_banner -threads 0 -i "$1" -ar 8000 -acodec pcm_u8 -ac 1 "${1%%.*}_DOS.WAV" && rm "$1"; }
function 2doswav11() { ffmpeg -hide_banner -threads 0 -i "$1" -ar 11025 -acodec pcm_u8 -ac 1 "${1%%.*}_DOS.WAV" && rm "$1"; }
function 2voc() { ffmpeg -hide_banner -threads 0 -i "$1" -ar 11025 -acodec pcm_u8 -ac 1 "${1%%.*}.voc" && rm "$1"; }
function 2voc8() { ffmpeg -hide_banner -threads 0 -i "$1" -ar 8000 -acodec pcm_u8 -ac 1 "${1%%.*}.voc" && rm "$1"; }
function 2voc11() { ffmpeg -hide_banner -threads 0 -i "$1" -ar 11025 -acodec pcm_u8 -ac 1 "${1%%.*}.voc" && rm "$1"; }
function 2opus() { ffmpeg -hide_banner -threads 0 -i "$1" "${1%%.*}_temp.wav" && opusenc --bitrate 2K --hard-cbr --downmix-mono "${1%%.*}_temp.wav" "${1%%.*}.opus" && rm "${1%%.*}_temp.wav" "$1" ; }
function 2aif() { ffmpeg -hide_banner -threads 0 -i "$1" "${1%%.*}.aif" && rm "$1"; }
function 2mp3() { ffmpeg -hide_banner -threads 0 -i "$1" "${1%%.*}.mp3" && rm "$1"; }
function 2mov() { ffmpeg -hide_banner -threads 0 -i "$1" "${1%%.*}.mov" && rm "$1"; }
function 2mp4() { ffmpeg -hide_banner -threads 0 -i "$1" "${1%%.*}.mp4" && rm "$1"; }
function 2avi() { ffmpeg -hide_banner -threads 0 -i "$1" "${1%%.*}.avi" && rm "$1"; }
function 2webm() { ffmpeg -hide_banner -threads 0 -i "$1" -c:v libvpx "${1%%.*}.webm" && rm "$1"; }
function 2h265() { ffmpeg -hide_banner -threads 0 -i "$1" -c:v libx265 "${1%%.*}_h265.mp4" && rm "$1"; }
function 2flv() { ffmpeg -hide_banner -threads 0 -i "$1" "${1%%.*}.flv" && rm "$1"; }
function 2mpg() { ffmpeg -hide_banner -threads 0 -i "$1" "${1%%.*}.mpg" && rm "$1"; }

#The following are for converting a video to a DVD-ready MPEG format
#for faster use with DVD creation programs. Use the "sub" versions
#below to permanently overlay subtitles (*.srt) onto the video. The
#output is automatically handled for you by placing the file in the same
#directory with the same name but with "_NTSC" or "_PAL" appended to the
#end. The original is deleted when finished so make shure to use Ctrl+c
#if canceling the conversion to prevent deleting the original as
#previously mentioned in the above other "2[format]" video conversions.
#
# Normal usage example: 2mpgNTSC input.ext
# Usage for subtitle overlay example: 2mpgNTSCsub input.ext input.srt
#
function 2mpgNTSC() { ffmpeg -hide_banner -threads 0 -i "$1" -i "$1" -map 1:0 -map 0:1 -y -target ntsc-dvd -sn -g 12 -bf 2 -strict 1 -ac 2 -aspect 1.7777777777777777 -trellis 0 -mbd 0 -b:a 224k -b:v 9000k -passlogfile "${1%%.*}_NTSC.mpg" -pass 1 "${1%%.*}_NTSC.mpg" && rm "$1" ; }
function 2mpgNTSCsub() { ffmpeg -hide_banner -threads 0 -i "$1" -i "$1" -map 1:0 -map 0:1 -y -vf subtitles="$2" -target ntsc-dvd -sn -g 12 -bf 2 -strict 1 -ac 2 -aspect 1.7777777777777777 -trellis 0 -mbd 0 -b:a 224k -b:v 9000k -passlogfile "${1%%.*}_NTSC.mpg" -pass 1 "${1%%.*}_NTSC.mpg" && rm "$1" ; }
function 2mpgPAL() { ffmpeg -hide_banner -threads 0 -i "$1" -i "$1" -map 1:0 -map 0:1 -y -target pal-dvd -sn -g 12 -bf 2 -strict 1 -ac 2 -aspect 1.7777777777777777 -trellis 0 -mbd 0 -b:a 224k -b:v 9000k -passlogfile "${1%%.*}_PAL.mpg" -pass 1 "${1%%.*}_PAL.mpg" && rm "$1" ; }
function 2mpgPALsub() { ffmpeg -hide_banner -threads 0 -i "$1" -i "$1" -map 1:0 -map 0:1 -y -vf subtitles="$2" -target pal-dvd -sn -g 12 -bf 2 -strict 1 -ac 2 -aspect 1.7777777777777777 -trellis 0 -mbd 0 -b:a 224k -b:v 9000k -passlogfile "${1%%.*}_NTSC.mpg" -pass 1 "${1%%.*}_NTSC.mpg" && rm "$1" ; }

#Converting documents and images using soffice 
#(installed along with LibreOffice)
#
#    Usage example: 2pdf '/path/to/file.html'
#
function 2txt() { soffice --headless --convert-to txt "$1"; }
function 2pdf() {
    if [ ${1: -4} == ".html" ]
    then
        soffice --headless --convert-to odt "$1"
        soffice --headless --convert-to pdf "${1%%.*}.html"
    else
        soffice --headless --convert-to pdf "$1"
    fi
}
function 2doc() { soffice --headless --convert-to doc "$1"; }
function 2odt() { soffice --headless --convert-to odt "$1"; }

#Convert images using ImageMagick
#
#    Usage example: 2jpg '/path/to/image.ext'
#
function 2pcx() { convert "$1" -colors 256 "${1%%.*}.pcx" && rm "$1"; }
function 2lbm() { convert "$1" -remap "/PATH/TO/DPAINT/LORES/THEPAINT.BMP" -colors 4 -depth 2 -resize 320x200 "${1%%.*}.lbm" && rm "$1"; echo "$1 was converted to LBM format, but do not forget to convert again using PICTVIEW"; }
function 2jpeg() { convert "$1" "${1%%.*}.jpg" && rm "$1"; }
function 2jpg() { convert "$1""${1%%.*}.jpg" && rm "$1"; }
function 2png() { convert "$1" "${1%%.*}.png" && rm "$1"; }
function 2png8() { convert "$1" "${1%%.*}.png8" && mv "${1%%.*}.png8" "$fname.png" && rm "$1"; }
function 2bmp() { convert "$1" "${1%%.*}.bmp" && rm "$1"; }
function 2dosbmp() { convert "$1" -colors 16 -depth 4 -dither none -resize 640x480 BMP3:"${1%%.*}_DOS.bmp" && rm "$1"; }
function 2dosgif() { convert "$1" -colors 256 -dither none -resize 320x200\! GIF87:"${1%%.*}_DOS.gif" && rm "$1"; }
function 2tiff() { convert "$1" "${1%%.*}.tiff" && rm "$1"; }
function 2ico() { convert -background transparent "$1" -define icon:auto-resize=16,32,48,64,128 "${1%%.*}.ico" && rm "$1"; }

#If input is a video, convert use '2gif' to created an animated 
#(89a) GIF; otherwise, use ImageMagick to create a still (87a) GIF.
#
#    Usage example: 2gif '/path/to/image/or/video.ext'
#
function 2gif() {
    if [ ! -d "/tmp/2gif" ]; then mkdir "/tmp/2gif"; fi
    if [ ${1: -4} == ".mp4" ] || [ ${1: -4} == ".mov" ] || [ ${1: -4} == ".avi" ] || [ ${1: -4} == ".flv" ] || [ ${1: -4} == ".mpg" ] || [ ${1: -5} == ".webm" ]
    then
        ffmpeg -hide_banner -threads 0 -i "$1" -r 10 -vf 'scale=trunc(oh*a/2)*2:480' /tmp/2gif/out%04d.png
        convert -delay 1x10 "/tmp/2gif/*.png" -fuzz 2% +dither -coalesce -layers OptimizeTransparency +map "${1%%.*}.gif"
    else
        convert "$1" GIF87:"${1%%.*}.gif"
        rm "$1"
    fi
    if [ -d "/tmp/2gif" ]; then rm -r "/tmp/2gif"; fi
}

#Tonvid is a YouTube frontend and this helps for when copy/paste text 
#isn't possible as you only need to type the video ID.
#
#    Usage: tonvid [video ID]
#
function tonvid() { mpv --vo=opengl,x11,drm,tct,caca --ao=pulse,alsa --ytdl-format="[ext=mp4][height<=?720]" https://tonvid.com/info.php?video_id=$1; }

#Grab a pretty ascii forecast picture for anywhere; without arguments, 
#uses ISP location to print your weather. Example: weather New York, NY
function weather() { curl -s http://wttr.in/$1; }

#Grab weather information from USAirNet and have a pretty Wttr.in ascii 
#output. Example: weather 02118 boston
function weatherus() { echo ""; w3m http://www.usairnet.com/weather/forecast/local/?pands=$1 | grep -A 10 "${2^^}"; echo ""; curl -s http://wttr.in/$2; }

#Convert hex data file to a binary
function hex2bin() { s=${@^^}; for i in $(seq 0 1 $((${#s}-1))); do printf "%04s" `printf "ibase=16; obase=2; ${s:$i:1};\n" | bc` ; done; printf "\n"; }

#Create a randomized playlist for audio and video recursively
#
#    Usage: cd '/path/to/music/or/video/directory' && playlist
#
alias playlist="find -D tree . | sort -R --random-source=/dev/urandom > playlist.m3u"

#Play Twitch streams with MPV in GUI or TTY
#
#    Usage: twitch username
#        You may have to add "1080p" to the function if for whatever
#        reason the stream does not have a 720p or lower option; keeping
#        it low helps on older/lighter hardware.
#        Use 'sudo pip install streamlink' to install 'streamlink'.
#
function twitch() { streamlink -p "mpv --vo=opengl,x11,drm,tct,caca --ao=pulse,alsa,jack --user-agent='Mozilla'" https://twitch.tv/$1 720p,720p_alt,480p,360p,160p,audio_only ; }

#Or, if you have a live stream's full URL (use with Twitch, YouTube, 
#etc.)... Usage: stream https://examplestreamservice.tv/user
function stream() { streamlink -p "mpv --vo=opengl,x11,drm,tct,caca --ao=pulse,alsa,jack --user-agent='Mozilla'" $1 720p,720p_alt,480p,360p,160p,audio_only ; }

#Play just about anything web related that youtube-dl supports
#You can also replace 'youtube-dl' with 'yt-dlp'
function webplay() { ffplay -vf scale=720x480 "$(youtube-dl -g $1)"; }
function webplayer() { ffplay -vf scale=720x480 "$(youtube-dl -g $1)"; }

#Optimize mpv for playing just about anything without having to think
#too much; 720p is chosen because of older hardware
alias mpv="mpv --vo=opengl,x11,drm,tct,caca --ao=pulse,alsa,jack --user-agent='Mozilla' --ytdl-format='best[ext=mp4][height<=?720]'"

#Play last viewed, or attempted to view video from Kodi using mpv; may 
#not work due to CDNs (Content Delivery Networks).
function mpvkodi() { URL="$(grep 'mp4' ~/.kodi/temp/kodi.log | awk '{print $6}' | cut -d '|' -f1 | tail -n 1)"; mpv "$URL"; }

#If playback on Kodi is slow, download last viewed, or attempted to view
#video using axel; may not work do to CDNs (Content Delivery Networks).
function axelkodi() { URL="$(grep 'mp4' ~/.kodi/temp/kodi.log | awk '{print $6}' | cut -d '|' -f1 | tail -n 1)"; axel -n 10 "$URL"; }

#Do a fuzzy search using 'fzy' for an installed program in the 
#"/usr/share/applications/" and "$HOME/.local/share/applications" 
#directories and run it; you can replace the 'fzy' with 'fzf' if it is
#installed. Also, you may have to replace 'xdg-open' with 'exo-open'.
#If nothing is selected and 'CTRL+C' is used to exit, 'xdg-open' and
#'exo-open' will print the --help; it is what it is.
function run() { xdg-open $(find '/usr/share/applications/' "$HOME/.local/share/applications" -type f | fzy); }
alias appsearch='run' #...because 'run' may not quite make sense...

#Quickly use QEMU, if installed, to boot a 64-bit, i686/i586, or i486 
#operating system from an ISO. Add -hda "/path/to/created.img" if 
#planning to install the system booted from the ISO.
#
#    Usage: bootiso '/path/to/distro.iso' 2048M
#
#...in which "2048M" is the maximum amount of RAM qemu will use with the
#distro.iso.
#
function bootiso() { qemu-system-x86_64 -cdrom "$1" -boot d -m "$2"; }
function boot32() { qemu-system-i386 -cdrom "$1" -boot d -m "$2" ; }
function boot486() { qemu-system-i386 -cpu 486 -cdrom "$1" -boot d -m "$2" ; }

#Nerd humor; use 'zardoz' instead of 'sudo'
alias zardoz='sudo'

#Use curl and "https://cht.sh/" to quickly search how to do things
#Examples: 'howin html do I view an image'
#          'howin python do I add numbers'
howin() {
    where="$1"; shift
    IFS=+ curl "https://cht.sh/$where/$*"
}

#Create comma-separated, single-quoted, lists from multi-line output
#    Usage example: cat '/path/to/multi-lineList.txt' | commalist
function commalist() { awk 'BEGIN { ORS="" } { print p"'"'"'"$0"'"'"'"; p=", " } END { print "\n" }' ; }

#Potentially lower an image's file size using ImageMagick by lowering
#the amount of colors, using dithering, increasing contrast, etc...
#
#    Usage: optimg '/path/to/image.ext'
#
function optimg() { convert "$1" -dither FloydSteinberg -colors 256 -morphology Thicken:0.5 '3x1+0+0:1,0,0' -remap netscape: -ordered-dither o8x8,6 +contrast "$1_converted" ; }

#Potentially lower a PDF's file size using Ghostscript
#
#    Usage: optpdf '/path/to/file.pdf'
#
function optpdf() { gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -sOutputFile="${1%%.*}_small.pdf" "$1" ; }

#Use 'pdftoppm' and 'img2pdf' to lower DPI of PDFs to 72, 96, or 300
#
#    Usage example for 96 DPI: optpdf96 '/path/to/file.pdf'
#
function optpdf72() { mkdir -p "./temppdf" && cd "./temppdf" && pdftoppm -jpeg -r 72 "$1" pg && img2pdf *.jpg --output "${1%%.*}_small.pdf" && cd .. && rm -rf "./temppdf" ; } "$fname"_small.pdf && rm -rf "$dir/temppdf" && cd .. ; }
function optpdf96() { mkdir -p "./temppdf" && cd "./temppdf" && pdftoppm -jpeg -r 96 "$1" pg && img2pdf *.jpg --output "${1%%.*}_small.pdf" && cd .. && rm -rf "./temppdf" ; } "$fname"_small.pdf && rm -rf "$dir/temppdf" && cd .. ; }
function optpdf300() { mkdir -p "./temppdf" && cd "./temppdf" && pdftoppm -jpeg -r 300 "$1" pg && img2pdf *.jpg --output "${1%%.*}_small.pdf" && cd .. && rm -rf "./temppdf" ; } "$fname"_small.pdf && rm -rf "$dir/temppdf" && cd .. ; }

#Convert a PDF to a different version; pdfto11 = 1.1; pdfto12 = 1.2; etc...
#
#    Usage Example: pdfto13 input.pdf output.pdf
#
function pdfto11() { gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.1 -sOutputFile="$2" "$1" ; }
function pdfto12() { gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.2 -sOutputFile="$2" "$1" ; }
function pdfto13() { gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 -sOutputFile="$2" "$1" ; }
function pdfto14() { gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -sOutputFile="$2" "$1" ; }
function pdfto15() { gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -sOutputFile="$2" "$1" ; }
function pdfto16() { gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.6 -sOutputFile="$2" "$1" ; }
function pdfto17() { gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.7 -sOutputFile="$2" "$1" ; }

#Use the following functions to create an encrypted PDF from all of the
#the images in the current directory. Start with 'img2pdfenc' and if
#you get an "Invalid" error, use the 'img2pdfcheck' function to go
#through each image and print the file-names associated with the error
#as 'img2pdf' annoying does not do this for you; echo "$i" helps; the
#'img2pdfcheck' function will take a long time if you have a lot of
#images; it uses a FOR-LOOP, so it does not check recursively. If you
#already have a PDF you want to encrypt, run the 'pdf2enc' function.
#
#    Usage Example: img2pdfcheck
#    Usage Example: img2pdfench output.pdf
#    Usage Example: pdf2enc input.pdf output.pdf
#    Usage Example: pdf2decrypt input.pdf output.pdf
#
function img2pdfcheck(){ echo '' && echo 'Checking rotation of JPF images... Please be patient...' && n=0 && TOTAL="$(ls *.jpg | wc | awk '{print $1}')" && for i in *.jpg; do (( n++ )) && echo "Checking file $i, which is $n out of $TOTAL" && if [ "$(img2pdf "$i" | grep 'Invalid')" != '' ]; then echo "$i - Rotation is bad"; fi ; done ; }
function img2pdfenc(){ find . -type f -iname "*.jpg" -exec img2pdf --output "$1" "{}" + && exiftool -overwrite_original_in_place -all= "$1" && pdftk "$1" output "${1%.*}_enc.pdf" user_pw PROMPT && rm -f "$1" && mv "${1%.*}_enc.pdf" "$1" ; }
function pdf2enc(){ pdftk "$1" output "$2" user_pw PROMPT ; }
function pdf2decrypt(){ pdftk "$1" input_pw PROMPT output "$2" ; }

#Potentially lower an animated GIF's (89a) file size using gifsicle
#
#    Usage: optgif input.gif output.gif
#
function optgif() { gifsicle -i "$1" -O3 -o "$2" ; }

#Append line numbers to the beginning of each line
#
#    Usage: addlinenumbers '/path/to/file.txt'
#    Make permanent: addlinenumbers input.txt | tee output.txt
#
function addlinenumbers() { awk '{printf("%01d %s\n", NR, $0)}' "$1" ; }

#Displaying a #hex or rgb(#,#,#) color using ImageMagick; this is so you
#do not have to do an Internet search or open a heavy program just to 
#find out what the color looks like. Do not forget the quotes.
#
#    Usage HEX: dispcolor '#hex'
#    Usage RGB: dispcolor 'rgb(#,#,#)'
#
dispcolor { display -size 300x300 xc:"$1" ; }
displaycolor { dispcolor "$1" ; }

#Use webcam as a timelapse camera
#Defaults to 30 seconds but you can use 'timelapse [seconds]' for your 
#own time.
function timelapse() { timelapsedir="$(date)" && mkdir "$timelapsedir" && cd "$timelapsedir" && if [ "$1"  = "" ]; then while [ true ]; do sleep 30; ffmpeg -y -hide_banner -err_detect ignore_err -threads 0 -f video4linux2 -s 640x480 -i /dev/video0 -vf drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf:text=%{localtime\:%T}:x=20:y=20:fontcolor=white -vframes 1 $(date +%Y-%m-%d-%H-%M).jpg; done; else while [ true ]; do sleep "$1"; ffmpeg -y -hide_banner -err_detect ignore_err -threads 0 -f video4linux2 -s 640x480 -i /dev/video0 -vf drawtext=fontfile=/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf:text=%{localtime\:%T}:x=20:y=20:fontcolor=white -vframes 1 $(date +%Y-%m-%d-%H-%M).jpg; done; fi ; }

#Day-mode...Ooooh aaaAAAh! Enemy of the nightmode... Ooooh aaaAAAh!
#Use daymode/nightmode to toggle the a red screen tint on/off for doing 
#things such as Astronomy.
# alias daymode="xgamma -gamma 1 && echo -en "\\033[37m\\033[8]""


function nightmode() { xgamma -rgamma 1 -ggamma 0.3 -bgamma 0.3; }

#If you are encrypting/decrypting files using OpenSSL...
#
#    Usage encrypt: encrypt normalFile.ext encryptedFile.enc public.key
#    Usage decrypt: decrypt encryptedFile.enc private.key
#
function encrypt() { openssl smime -encrypt -binary -aes-256-cbc -in "$1" -out "$2" -outform DEM "$3" ; } #"$3" is path to public key
function decrypt() { openssl smime -decrypt -in "$1" -binary -inform DEM -inkey "$2" ; } #"$2" is path to private key

#Sorts out unique lines in text file in alphabetical order
#
#    Usage: unique '/path/to/file.txt'
#
function unique() { sort "$1" | uniq -u ; }

#Internet speed test using cURL and Python
function int-speed() { curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python - ; }

#Grab a copy of an entire website or starting from whichever URL you use
#in place of "$1". It doesn't always work 100% of the time and do not 
#get made at me if a server bands you for using it.
#
#    Usage: grabindex https://example.org
#
function grabindex() { wget  -e robots=off -r -k -nv -nH -l inf -R --reject-regex '(.*)\?(.*)'  --no-parent "$1" ; }

#Quickly open a color picker using 'GPick' that copies clicked color to 
#the clipboard. Though, you could argue that it isn't much of a shortcut
#based on text length...
alias cgrab="gpick -s"

#Use 'axel' download accelorator with youtube-dl to grab YouTube videos
#
#    Usage: axelyt https://youtube.com/watch?v=???????????
#
#HOWEVER, instead, you may want to consider using 'yt-dlp'
#
function axelyt() { youtube-dl -c -i --user-agent 'Mozilla' --external-downloader-args '-n 10' --external-downloader /usr/bin/axel $1 ; }

#Download "nicely embedded" images from a site page; this function does 
#not work if lynx gives JS errors. Or, you can use 'gallery-dl' via 
#'sudo pip install gallery-dl' for more complex sites.
#
#    Usage: grabimg https://example.org
#
function grabimg() { lynx -dump -image_links $1 | awk '/(jpg|png)$/{system("wget " $2) }' ; }

#Use this as a way to get nano to create a text file that is a bit more 
#DOS-friendly. Make sure your file name has no spaces and is only 8 
#characters long and does not have more than 3 characters for the file-
#extension.
#
#    Usage doswrite /path/to/new/file.txt
#
function doswrite(){ nano -m -u -c -b -l --tabsize=4 --fill=72 --atblanks --autoindent "$1" && unix2dos "$1" ; }

#Mount a raw image (IMG) file containing an installation of FreeDOS
#
#    Usage: fdsomount '/path/to/fdos.img' '/path/to/mount/point'
#
function fdosmount() { sudo mount -o loop,offset=32256 "$1" "$2" ; }

#Look for files within current directory and all sub directories that 
#were modified between two dates; $1 and $2 are as follows: yyyy-mm-dd
#
#    Usage: cd /path/to/directory && findbetween yyyy-mm-dd yyyy-mm-dd
#
function findbetween() { find . -type f -newermt $1 ! -newermt $2 ; }

#Zip all files in current directory INDEpendently from each other; in
#other words, each file gets its own zip.
#
#    Usage: cd /path/to/directory && indezip
#
function indezip(){ for file in *; do zip "${file%.*}.zip" "$file"; done ; }

#Zip all files in current directory independently from each other AND 
#delete the originals when finished.
#
#    Usage: cd /path/to/directory && indeziprm
#
function indeziprm(){ for file in *; do zip "${file%.*}.zip" "$file" && rm "$file"; done ; }

#Get the mime information (file-type) of a file
#For example, a plain text file would have 'text/plain' as the mime
#
#    Usage: mime /path/to/file.ext
#
function mime(){ file --mime-type "$1" ; }

#Convert an image to a 10 second MP4 video
#
#    Usage: img2vid 'input.jpg' 640 480 'output.mp4'
#
#The numbers above are for WxH in pixels
function img2vid(){ ffmpeg -hide_banner -threads 0 -loop 1 -i "$1" -c:v libx264 -t 10 -pix_fmt yuv420p -vf scale="$2":"$3" "$4" ; }

#Merge video and audio together; replaces current audio if it exists
#
#    Usage: avmerge 'video.ext' 'audio.ext' [output.ext]
#
function avmerge(){ if [ "$3" = "" ]; then OUTPUT="output_$RANDOM.mp4"; else OUTPUT="$3";fi && ffmpeg -hide_banner -threads 0 -i "$1" -i "$2" -map 0:v -map 1:a -c:v copy -shortest "$OUTPUT" ; }

#Add an image (album cover) to an MP3 using the Python program 'eyeD3'
#
#    Usage: addimage '/path/to/image.jpg' '/path/to/audio.mp3'
#
function addimage() { eyeD3 --to-v2.4 --add-image "$1":FRONT_COVER "$2" ; }

#Copy the contents of a CD-ROM to an ISO if /dev/sr0 is your device,
#to which is usually the case for external disc drives.
#
#    Usage: cpcd output.iso
#
function cpcd(){ isoinfo -d -i /dev/cdrom && blocks=$(isosize -d 2048 /dev/sr0) && dd if=/dev/sr0 of="$1" bs=2048 count=$blocks status=progress ; }

#Move up by a number of specified directories
function up(){
    local d=""
    local limit="$1"
    if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
        limit=1
    fi
    for ((i=1;i<=limit;i++)); do
        d="../$d"
    done
    if ! cd "$d"; then
        echo "Could not go up $limit directories.";
    fi
}

#Grab audio only from YouTube
#    Usage: yta-mp3 https://youtube.com/watch?v=???????????
#
# You could also replace youtube-dl with 'yt-dlp' as they both more or
# less use the same arguments.
#
alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias yta-opus="youtube-dl --extract-audio --audio-format opus "
alias yta-vorbis="youtube-dl --extract-audio --audio-format vorbis "
alias yta-wav="youtube-dl --extract-audio --audio-format wav "

#Grab the highest quality of video+audio from YouTube
alias ytv-best="youtube-dl -f bestvideo+bestaudio "

#Because I got tired of typing 'w3m https://duckduckgo.com'...
alias ddg='w3m duckduckgo.com'

#Add some flags to some basic commands that probably should be default
#The aliases below with '-i' refer to asking for confirmation before
#doing things with files; rm needs to have three or more files or have
#the '-r' flag involved before asking for confirmation to delete.
alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"
alias ln="ln -i"
alias df='df -h' 
alias free="free -m"
alias mkdir="mkdir -pv"

# Some 'ps' command aliases...
alias psa="ps auxf"
alias psgrep="ps aux | grep --v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

#Have the 'mocp' command-line music player use the nightly_theme
#Default themes are located within "/usr/share/moc/themes/"
alias='mocp -T nightly_theme'

#Create an empty audio file for n amount of seconds.
#This is useful for DVD authoring software (DevedeNG, DVD Styler, etc.) 
#in which you need an audio layer for menus, even if it is an empty one;
#some older DVD players and game consoles notice when this is missing 
#and may create a short (or long) "chirp" noise during certain menus, 
#especially those with background video or animated chapter selection. 
#Sometimes these menus are loopable but only loop based on whether the 
#video layer or audio layer, if separate, have the smallest amount of 
#time. Hopefully this makes sense.
#
#Usage: emptyaudio [seconds] output.mp3
#
function emptyaudio(){ ffmpeg -hide_banner -threads 0 -ar 48000 -t "$1" -f s16le -i /dev/zero "$2" ; }

#This function lists the most used commands and how many times in a simplistic way
function top-history(){ history | awk 'BEGIN {FS="[ \t]+|\\|"} {print $3}' | sort | uniq -c | sort -nr | head -10 | less ; }

#Convert a video to a bunch of JPEG's and convert a bunch of PNG's or 
#JPEG's to video. I have two separate functions for JPG and JPEGs, even
#though they are the same format. Someone out there may be taking 
#advantage of this and have JPGs that "stand for" one thing and then use
#the JPEG extension for some other purpose.
#
#    Usage example A: video2jpg /path/to/video.mp4 [framerate]
#    Usage example B: cd /path/to/PNG/directory && png2video [framerate] output.mp4
#    Usage example C: cd /path/to/JPG/directory && jpg2video [framerate] output.mp4
#    Usage example D: cd /path/to/JPEG/directory && jpeg2video [framerate] output.mp4
#
function video2jpg(){ ffmpeg -hide_banner -threads 0 -i "$1" -r "$2" "$(basename $1)"_%05d.jpg ; }
function png2video() { ffmpeg -hide_banner -threads 0 -framerate "$1" -pattern_type glob -i "*.png" -r "$1" "$2" ; }
function jpg2video() { ffmpeg -hide_banner -threads 0 -framerate "$1" -pattern_type glob -i "*.jpg" -r "$1" "$2" ; }
function jpeg2video() { ffmpeg -hide_banner -threads 0 -framerate "$1" -pattern_type glob -i "*.jepg" -r "$1" "$2" ; }

#Lists URLs that start with 'http' or 'https' on a webpage using cURL
#
#    Usage: listurls https://example.org
#
function listurls() { curl -s -f -L "$1" | grep -Eo '"(http|https)://[a-zA-Z0-9#~.*,/!?=+&_%:-]*"' | sed 's/"//g' ; }

#Use wget to download everything listed within a plain-text file
#
#    Usage: grablist /path/to/URL_List.txt
#
function grablist(){ wget -c --content-disposition --trust-server-names -i "$1" ; }

#Use this to grab all of the ZIP files recursively from a website
function dlzips(){ wget -r -np -l 1 -A zip "$1" ; }

#Use this to grap all of the files with the "$2" extension recursively 
#from a website, or at least the sensible ones that let you crawl around
#in directories.
#
#    Example: dlext https://example.org mp3
#
function dlext(){ wget -r -np -l 1 -A "$2" "$1" ; }

#Use this to send random numbers to the clipboard every five seconds; it
#is very useful if selectively saving a bunch of long-named files from a 
#website but could care less about the name of the files. Just use 
#CTRL+v like usual in the SAVE-AS area of the file-saving dialog to 
#paste the number. I guess it could also help with those paranoid about
#certain software having clipboard access, though I have no idea why 
#anyone would voluntarily run that sort of thing.
function randomclip(){ while true; do echo $RANDOM | xsel -b && sleep 5; done ; }

#Need a simple espeak timer? Values can be things like 10s, 30m, 1h.
#However, because of how simplistic this is, you cannot combine times so
#if you need something like "1h 30m," then you need to use "90m" 
#instead, without the quotes. The second argument will need quotes.
#
#    Example: espeaktimer 30m "Go check your oven!"
#
function espeaktimer(){ sleep "$1" && for i in 1 2 3; do espeak "$2" ; done }

#I did not like how the 'ebook-convert' program from 'Calibre' converts
#comic books to whatever with automatic grayscale, especially when the
#CBR or CBZ file in question is not a typical comic and is full-color.
#
#    Usage: ebook-convert-cbz input.cb[r,z] output.ext
#
function ebook-convert-cbz(){ ebook-convert "$1" "$2" --dont-grayscale --no-process --dont-normalize ; }
```