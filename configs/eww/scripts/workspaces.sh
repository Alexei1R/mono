#!/bin/bash

get_workspaces() {
    active=$(hyprctl activeworkspace -j | jq -r '.id')
    workspaces=$(hyprctl workspaces -j | jq -r '.[].id' | sort -n)
    
    echo "["
    for i in {1..10}; do
        [ $i -ne 1 ] && echo ","
        
        active_status="false"
        occupied_status="false"
        
        [ "$i" -eq "$active" ] && active_status="true"
        echo "$workspaces" | grep -q "^$i$" && occupied_status="true"
        
        echo "  {\"id\": $i, \"active\": $active_status, \"occupied\": $occupied_status}"
    done
    echo "]"
}

get_workspaces

socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | \
while read -r line; do
    case $line in
        workspace*|createworkspace*|destroyworkspace*)
            get_workspaces
            ;;
    esac
done
