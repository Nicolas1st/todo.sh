#!/usr/bin/env bash

todo_file='todos.txt'
[ ! -e $todo_file ] && touch $todo_file

# errors
empty_todo=1
no_such_todo_number=1

show_todos() {
    nl -nln $todo_file;
}

add_todo() {
    todo="$@"
    [ -z "$todo" ] && return $empty_todo;

    echo "$todo" >> "$todo_file";
}

remove_todo() {
    local todo_number="$1";

    [ "$todo_number" -lt 0 ] && return $no_such_todo_number;

    todos_count="$(wc -l "$todo_file" | cut -f1 -d' ')";
    [ "$todo_number" -gt "$todos_count" ] && return $no_such_todo_number;

    local tmpfile=`mktemp`;

    cat $todo_file | head -$((todo_number-1)) > "$tmpfile";
    cat $todo_file | tail -$((file_len-todo_number)) > "$tmpfile";

    cat $tmpfile > $todo_file;
    rm $tmpfile;
}

show_todos
select option in "add" "remove" "quit"; do
    case "$option" in
        add)
            read -p "TODO: " todo
            add_todo $todo
            show_todos
            ;;
        remove)
            read -p "Number: " number
            remove_todo $number
            show_todos
            ;;
        quit)
            break
            ;;
        *)
            echo "Undefined command"
    esac
done

