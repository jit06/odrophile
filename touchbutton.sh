#!/bin/bash

GPIO_PIN=/sys/class/gpio/gpio75/value

values=(0 0 0 0 0 0)
elapsed=(0 0 0 0 0 0)
orderedValues=(0 0 0 0 0 0)
orderedElapsed=(0 0 0 0 0 0)
turn=0
touched=0
len=5
i=0


# get value from gpio and store elpased time since last call
function readValue() {
    if [ $i -gt $len ]; then
        i=0
    fi

    read newValue < $GPIO_PIN
    
    if [ $newValue -ne ${values[$((i-1))]} ]; then 
        read values[$i] < $GPIO_PIN
        read up rest < /proc/uptime; elapsed[$i]="${up%.*}${up#*.}"           
    
        i=$((i+1))
    fi
}

# reverse order all read values for easy detection of event
function readOrdered() {
    lastindex=$((i-1)) 
    
    for j in `seq 1 $len`;
    do
        orderedValues[$j]=${values[$lastindex]}
        orderedElapsed[$j]=${elapsed[$lastindex]}
        if [ $lastindex -lt 0 ]; then
            lastindex=$len
        fi    
        
        lastindex=$((lastindex-1))
    done    
}


# main : poll gpio as inotify does not work on c1/c0 even with edge detection set to "both"
while true
do
    readValue
    readOrdered

    # check for double touch        
    if [ ${orderedValues[1]} -eq 1 ] &&
       [ ${orderedValues[3]} -eq 1 ] && 
       [ $((orderedElapsed[1]-orderedElapsed[3])) -lt 30 ] && 
       [ $((orderedElapsed[1]-orderedElapsed[3])) -gt 10 ] ; then
       touched=1
    fi
    
    # check for triple touch        
    if [ ${orderedValues[1]} -eq 1 ] &&
       [ ${orderedValues[3]} -eq 1 ] &&
       [ ${orderedValues[5]} -eq 1 ] && 
       [ $((orderedElapsed[1]-orderedElapsed[5])) -lt 80 ] && 
       [ $((orderedElapsed[1]-orderedElapsed[5])) -gt 35 ] ; then
        touched=2
        continue
    fi
    
    # triple touch action
    if [ $touched -eq 2 ] ; then
        echo "triple touch"
        node /opt/lib2queue
        touched=0
    fi
    
    # double touch action : wait some turns in case we are in triple touch situation 
    if [ $touched -eq 1 ];then 
        if [ $turn -le 17 ]; then # 17 x 0.05 = 0.85 > max tripple touch timer
            turn=$((turn+1))
        else
            echo "double touch"
            volumio toggle
            touched=0
            turn=0
        fi
    fi
    
    sleep 0.05
done

