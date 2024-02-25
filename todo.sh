#!/usr/bin/env bash

todo_file="$HOME/todos.txt"
[ ! -e $todo_file ] && touch $todo_file

green=`tput setaf 2`
reset=`tput sgr0`

color_text_green() {
    echo "${green}$@${reset}"
}

# state
focused_todo_num=1
show_help=true

select_todo_above() {
    todos_number=$(wc -l $todo_file | cut -f1 -d' ')

    if [ "$focused_todo_num" -gt 1 ]
    then
        ((focused_todo_num--))
    else
        focused_todo_num=$todos_number
    fi
}

select_todo_below() {
    todos_number=$(wc -l $todo_file | cut -f1 -d' ')

    if [ "$focused_todo_num" -lt "$todos_number" ]
    then
        ((focused_todo_num++))
    else
        focused_todo_num=1
    fi
}

toggle_help() {
    if "$show_help"
    then
        show_help=false
    else
        show_help=true
    fi
}

add_todo() {
    clear
    read -p "$(color_text_green "TODO: ")" todo
    [ -n "$todo" ] && echo "$todo" >> "$todo_file";
}

delete_todo() {
    todos_number=$(wc -l $todo_file | cut -f1 -d' ')

    [ "$focused_todo_num" -lt 1 ] && return
    [ "$focused_todo_num" -gt "$todos_number" ] && return

    sed -i "${focused_todo_num}d" $todo_file

    ((todos_number--))
    if [ $focused_todo_num -gt $todos_number ]
    then
        focused_todo_num=$todos_number
    fi

    if [ $focused_todo_num -lt 1 ]
    then
        focused_todo_num=1
    fi
}

draw_interface() {
    clear

    if "$show_help"
    then
        echo "Use j/k keys to navigate"
        echo "Press a to add a new todo"
        echo "Press d to delete the todo under the cursor"
        echo "Press h to  the todo under the cursor"
        echo "Press q to quit"
    fi

    local count=1

    local selected_todo_prefix="* "
    local non_selected_todo_prefix="  "

    while read line
    do
        if [ "$count" -eq $focused_todo_num ] 
        then
            echo $(color_text_green "$selected_todo_prefix$line")
        else
            echo "$non_selected_todo_prefix$line"
        fi

        ((count++))
    done < $todo_file
    
}

while true
do
    draw_interface
    todos_number=$(wc -l $todo_file | cut -f1 -d' ')

    read -rsn1 key
    case "$key" in
        j)
            select_todo_below
            ;;
        k)
            select_todo_above
            ;;
        h)
            toggle_help
            ;;
        a)
            add_todo
            ;;
        d)
            delete_todo
            ;;
        q)
            clear
            exit
            ;;
    esac
done

