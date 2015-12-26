HOST=$(uname -n)
KERNEL=$(uname -r)
UPTIME=$( uptime | sed 's/.* up //' | sed 's/[0-9]* us.*//' | sed 's/ day, /d /'\
      | sed 's/ days, /d /' | sed 's/:/h /' | sed 's/ min//'\
        |  sed 's/,/m/' | sed 's/  / /')
PACKAGES=$(pacman -Q | wc -l)
UPDATED=$(awk '/upgraded/ {line=$0;} END { $0=line; gsub(/[\[\]]/,"",$0); \
      printf "%s %s",$1,$2;}' /var/log/pacman.log)

MESSAGE=`( \
echo "Host: $HOST "; \
echo "Kernel: $KERNEL"; \
echo "Uptime: $UPTIME "; \
echo "Pacman: $PACKAGES packages"; \
echo "Last updated on: $UPDATED"; \
)`

notify-send "System Info" "$MESSAGE"

# "onstart=uncollapse" ensures that slave window is visible from start.