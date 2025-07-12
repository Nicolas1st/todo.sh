# Todos on the command line

Bash is fun to use if one accepts its quirk of course.

![A gif showing what it looks like](./todo.sh.gif)

# Controls
```sh
Use j/k keys to navigate
Press a to add a new todo
Press d to delete the todo under the cursor
Press h to  the todo under the cursor
Press q to quit
```

# Bash version
GNU bash, version 5.1.16
Maps were added to bash not that long ago,
so potentially it's very likely to be the issue when running the script
on machines with older versions.

# Comfortable cli experience
Add this to your .bashrc, .zshrc or the like
```sh
alias t="bash ~/path-to-repo/todo.sh"
```

