function tailSysLog {
    tail -f /var/log/syslog -n 100
}

function listCDs {
    wodim --devices
}

function getPidByProcessName {
    pidof $1
}

function killProcessThatKeepsFile {
    fuser -k $1
}

function countThreadsForProcessByName {
    ps uH p `pidof $1` | wc -l
}

function getNetworkActivity {
    lsof -r 2 -p `pidof $1` -i -a
}

function getFilesOpenedByProcess {
    lsof -c $1
}

function whoKeepsFile {
    fuser -v $1
}

function mountIso {
    mount $1 /mnt/cdrom -oloop
}

function listFilesInCurrentDir {
    sudo du -sh * | sort -n
}

function downloadWholeSite {
    get --random-wait -r -p -e robots=off -U $1 $2
}

function whoListenPort {
    lsof -i :$1
}

function shareCurrentFolder {
    python -m SimpleHTTPServer
}

function getExternalIp {
    curl ifconfig.me
}

function takeScreenVideo {
    ffmpeg -f x11grab -s wxga -r 25 -i :0.0 -sameq ~/temp/desktop.mpg
}

function shareShellOutput {
    # nc -k - live after client disconnect 
    # nc -l by default
    SHELL=/bin/bash
    mkfifo /tmp/fifo;(nc -q0 -l 5000 < /tmp/fifo > /dev/null &);script -f /tmp/fifo && rm /tmp/fifo
}

function listAllOpenPortsAndTheirOwningExecutables {
    lsof -i -P | grep -i "listen"
}

function findPPARepository {
    # ppasearch utility
    [ -z "$1" ] && echo "usage: `basename $0` \"search string\"" 1>&2 && exit 1
 
    wget -qO- "https://launchpad.net/ubuntu/+ppas?name_filter=$1" |\
    sed -ne 's/^.\+=\"\(.\+\)\">.\+<\/a><\/td>.*$/https:\/\/launchpad.net\1/p'
}

function diffRemoteSites {
    diff <(wget -q -O - $1) <(wget -q -O - $2)
}
#bind a key with function
#bind -x '"\C-l":ls -l'

function viewDeviceInformation {
    sudo file -s /dev/sd*
}

function changePrimaryDisplay {
    xrandr --output DVI1 --primary
}

function changePrimaryDisplayX {
    xrandr --output DVI1 --primary --mode 1440x900
}

function findDefaultMonitor {
    xrandr --prop | grep "[^dis]connected" | cut --delimiter=" " -f1
}

function makeVirtualDisplay {
    xrandr --output DVI1 --primary --mode 1440x900 --left-of VGA1
}

function logBash {
    script /tmp/log.txt
}

function downloadYoutubeVideo {
    wget "$1" -qO- | awk '/fmt_url_map/{gsub(/[\|\"]/,"\n");print}' | sed -n "/^fmt_url_map/,/videoplayback/p" | sed -e :a -e '$q;N;2,$D;ba' | tr -d '\n' | sed -e "s/\(.*\),\(.\)\{1,3\}/\1/;s/\\\//g" | wget -i - -O $2
}
function med {
    git ls-files --modified | grep $1 | xargs -i{} $2 {};
}

function showInterfaceRateInKbPerSec {
    while [ /bin/true ]; do OLD=$NEW; NEW=`cat /proc/net/dev | grep eth0 | tr -s ' ' | cut -d' ' -f "3 11"`; echo $NEW $OLD | awk '{printf("\rin: % 9.2g\t\tout: % 9.2g", ($1-$3)/1024, ($2-$4)/1024)}'; sleep 1; done
}

function showResourcesForProcess {
    if [ -z "${1}" ]; then
        echo "show CPU usage, RSS and VSZ memory for processes by name";
        echo "usage: pxr <process_name>";
        return;
    fi;
    for i in `ps -aef|grep ${1}|grep -v grep|grep -v ps|awk '{print $2}'`;
    do
        ps -o pid -o pcpu -o rss -o vsz -o cmd ${i};
    done
}

# monitor memory usage
function monitorMemoryUsage {
    watch vmstat -sSM
}

function file_charset {
    file -i $0
}

function grepMp3Links {
    grep -o "http://[^[:space:]]*.mp3"
}

function reloadXdefaults {
    xrdb ~/.Xdefaults
}

function showInternetActivityAtTheMoment {
    lsof -P -i -n
}

# siege - stress testing for the web site
# ngrep - light-weight wireshark
function makeSnapshotOfPipe {
    ipconfig | convert label:@- ip.png
}

function trueuniq {
    awk '{ if (!h[$0]) { print $0; h[$0]=1 } }'
}

function playPianoramaRadio {
    mplayer http://188.127.226.185:80/
}

# youtube-dl has this functionality built in. If you're running an older version
# of youtube-dl, you can update it using `youtube-dl -U`
function convertUtubeVideoToMp3 {
    youtube-dl -t --extract-audio --audio-format mp3 $0
}

# start command and kill it if still running after 5 secs
# > timeout 5s <command>

# fc opens the last command in $EDITOR and runs the altered version afterwards)
# parralel

function monitorPortConnections {
    while true ; do sleep 1 ; clear ; (netstat -tn | grep -P ':22s+d') ; done
}

function transmitFileLikeHttpServer {
    # Allow to launch nc like a daemon, in background until you still
    # stop it.
    # You can stop it with kill %1 (jobs method) or kill PID.
    # The -k option can force nc to listen another connection, but if
    # you use redirection, it will work only one time.
    # The loop's inside doesn't do anything, but we can imagine to
    # send a message to screen when a connection is established

    while ( nc -l 80 < $1 > : ) ; do : ; done &
}

function printTcpConnectionStatistic {
    netstat -npat|grep ESTABLISHED | awk 'BEGIN{counter=0;} {split($5,a,":");ip=a[1];if(ip in ips)ips[ip]+=1;else ips[ip]=1;counter++;} END{for(i in ips)print i" = "ips[i]"\n"}'| sort | grep -vP '^\s*$'
}
