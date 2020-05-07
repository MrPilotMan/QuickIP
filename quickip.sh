#!/bin/bash

allip() {
    case $1 in
        -m) pubip -m && locip -m ;;
        -M) pubip -m && locip -M ;;
        "") pubip && echo && locip ;;
        *) echo -e $__allip_usage ;;
    esac
}

__allip_usage="
Usage: allip [ -m ]\n
\t-m\tMinimal - Equivalent to \`pubip -m && locip -m\`.\n
\t-M\tExtra Minimal - Equivalent to \`pubip -m && locip -M\`."

pubip() {
    TITLE="\e[1mPublic IP Address:\e[0m"
    ip_address=`dig +short myip.opendns.com @resolver1.opendns.com`

    case $1 in
        -m) echo $ip_address ;;
        "")
            ip_location=`geoiplookup $ip_address | grep -oP ", \K.*"`
            echo -e "$TITLE\n\t$ip_address\t($ip_location)"
            ;;
        *) echo -e $__pubip_usage ;;
    esac
}

__pubip_usage="
Usage: pubip [ -m ]\n
\t-m\tMinimal - Only show IP address."

locip() {
    TITLE="\e[1mLocal IP Address(es):\e[0m"  # Bold header.
    GREEN="\e[32m"
    RED="\e[31m"
    ESC="\e[0m"

    ifjson=`ip -family inet -json address show`

    readarray -td ',' ifnames < <(printf '%s' "`echo $ifjson | jq --raw-output '[.[].ifname] | join(",")'`")
    readarray -td ',' localaddrs < <(printf '%s' "`echo $ifjson | jq --raw-output '[.[].addr_info[].local] | join(",")'`")
    readarray -td ',' operstates < <(printf '%s' "`echo $ifjson | jq --raw-output '[.[].operstate] | join(",")'`")

    ifmaxlen=0
    admaxlen=0
    stmaxlen=0

    # Find the length of the longest string in each array for use in formatting the printed table.
    for j in ${!ifnames[@]}; do
        iflen=${#ifnames[j]}
        adlen=${#localaddrs[j]}
        stlen=${#operstates[j]}

        if [[ $iflen -gt $ifmaxlen ]]; then ifmaxlen=$iflen; fi;
        if [[ $adlen -gt $admaxlen ]]; then admaxlen=$adlen; fi;
        if [[ $stlen -gt $stmaxlen ]]; then stmaxlen=$stlen; fi;
    done

    case $1 in
        -d)
            echo -e $TITLE
            for i in "${!ifnames[@]}"; do
                if [[ "${operstates[$i]}" == "DOWN" ]]; then
                    printf "\t%-"$ifmaxlen"s\t %-"$admaxlen"s\t "$RED"DOWN"$ESC"\n" ${ifnames[$i]} ${localaddrs[$i]}
                fi
            done
            ;;

        -m)
            for i in "${!ifnames[@]}"; do
                printf "%-"$ifmaxlen"s\t %-"$admaxlen"s\n" ${ifnames[$i]} ${localaddrs[$i]}
            done
            ;;

        -M)
            for address in ${localaddrs[@]}; do
                echo $address
            done
            ;;

        -u)
            echo -e $TITLE;
            for i in "${!ifnames[@]}"; do
                if [[ "${operstates[$i]}" == "UP" ]]; then
                    printf "\t%-"$ifmaxlen"s\t %-"$admaxlen"s\t "$GREEN"UP"$ESC"\n" ${ifnames[$i]} ${localaddrs[$i]}
                fi
            done
            ;;

        "")
            echo -e $TITLE;
            for i in "${!ifnames[@]}"; do
                STCOLOR=""
                case ${operstates[$i]} in
                    UP) STCOLOR=$GREEN ;;
                    DOWN) STCOLOR=$RED ;;
                esac
                printf "\t%-"$ifmaxlen"s\t %-"$admaxlen"s\t "$STCOLOR"%-"$stmaxlen"s"$ESC"\n" ${ifnames[$i]} ${localaddrs[$i]} ${operstates[$i]}
            done
            ;;

        *) echo -e $__locip_usage ;;
    esac
}

__locip_usage="
Usage: locip [ OPTION ]\n
\t-d\tDown - Only show interfaces that are currently down.\n
\t-m\tMinimal - Only show interface name and address.\n
\t-M\tExtra Minimal - Only show interface address(es).\n
\t-u\tUp - Only show interfaces that are up."
