#!/usr/bin/env bats

load check_dependencies

setup (){

    unset LUA_PATH
    unset LUA_CPATH
    unset LUA_PATH_5_2
    unset LUA_CPATH_5_2
    unset MOONBOX_CURRENT

    rm -rf BoxFile
    rm -rf .moonbox
    rm -rf config.make
}

@test "install/uninstall moonbox" {
    run ./configure
    run make install
    run make uninstall
}

@test "'moonbox help' command" {
    run bin/moonbox help
    [ "${lines[0]}" = "SYNOPSIS" ]

    run bin/moonbox h
    [ "${lines[0]}" = "SYNOPSIS" ]
}

@test "'moonbox version' command" {
    run bin/moonbox version
    [ "$output" = ">> moonbox v0.1" ]
}

@test "'moonbox install' command without BoxFile" {
    run bin/moonbox
    [ "$output" = ">> BoxFile file does not exist, You can create an example with 'moonbox init'" ]

    run [ -d ".moonbox" ]
    [ "$status" -eq 1 ]
}

@test "'moonbox init' check BoxFile creation" {
    run bin/moonbox init
    [ "$output" = ">> BoxFile successfuly created!" ]

    run cat BoxFile
    [ "${lines[1]}" = "#   WARNING: This file is an example, needs to be edited" ]

    run [ -d ".moonbox" ]
    [ "$status" -eq 1 ]
}

@test "'moonbox install' with empty BoxFile" {
    run bin/moonbox init
    run bin/moonbox install
    [ "$output" = ">> BoxFile file seems to be empty, If you already created one with 'moonbox init' needs to be edited" ]

    run [ -d ".moonbox" ]
    [ "$status" -eq 1 ]
}

@test "'moonbox install' with populated BoxFile - rockname" {
    echo "stacktraceplus # this is a comment, should be ignored" > BoxFile
    run bin/moonbox install
    last_line=${lines[${#lines[@]}-1]}
    [ "${lines[0]}" = ">> starting to install rocks at '`pwd`/.moonbox'" ]
    [ "$last_line" = ">> installation complete!" ]

    run [ -d ".moonbox" ]
}

@test "'moonbox install' with populated BoxFile - rockname && version" {
    echo "stacktraceplus 0.1.1-1" > BoxFile
    run bin/moonbox install
    last_line=${lines[${#lines[@]}-1]}
    [ "${lines[0]}" = ">> starting to install rocks at '`pwd`/.moonbox'" ]
    [ "$last_line" = ">> installation complete!" ]

    run [ -d ".moonbox" ]
}

@test "'moonbox install' with populated BoxFile - rockname && version && repo" {
    echo "stacktraceplus 0.1.1-1 http://luarocks.org/repositories/rocks/" > BoxFile
    run bin/moonbox install
    last_line=${lines[${#lines[@]}-1]}
    [ "${lines[0]}" = ">> starting to install rocks at '`pwd`/.moonbox'" ]
    [ "$last_line" = ">> installation complete!" ]

    run [ -d ".moonbox" ]
}

@test "'moonbox install' with populated BoxFile - rockspec" {
    echo "http://luarocks.org/repositories/rocks/uuid-0.2-1.rockspec" >> BoxFile
    run bin/moonbox install
    last_line=${lines[${#lines[@]}-1]}
    [ "${lines[0]}" = ">> starting to install rocks at '`pwd`/.moonbox'" ]
    [ "$last_line" = ">> installation complete!" ]

    run [ -d ".moonbox" ]
}

@test "'source moonbox env show' command without previous moonbox env setup" {
    cmd_output=">> could not find a moonbox env! You can start a new one with 'source moonbox env enter'"
    run source bin/moonbox env show
    [ "$output" = $cmd_output ]
    # check default env action
    run source bin/moonbox env 
    [ "$output" = $cmd_output ]
}

@test "'source moonbox env show' command with previous moonbox env setup" {
    echo "stacktraceplus" > BoxFile
    run bin/moonbox install
    run [ -d ".moonbox" ]
    . bin/moonbox env enter && . bin/moonbox env show >> env_status
    [ `head -n 1 env_status` = ">> env at '`pwd`/.moonbox'" ]
}

@test "'source moonbox env enter' command without moonbox install" {
    run source bin/moonbox env enter
    [ "$output" = ">> '.moonbox' directory not found. Run 'moonbox init' first." ]
}

@test "'source moonbox env enter' command" {
    echo "stacktraceplus" > BoxFile
    run bin/moonbox install
    run [ -d ".moonbox" ]

    . bin/moonbox env enter && $LUA -l StackTracePlus -e "print("test")"
}

@test "'source moonbox env leave' command" {
    echo "stacktraceplus" > BoxFile
    run bin/moonbox install
    run [ -d ".moonbox" ]

    # TO-DO: kind of a hack, I know.
    . bin/moonbox env enter && . bin/moonbox env leave >> env_status
    [ `tail -n 1 env_status` = ">> env at '`pwd`/.moonbox' has been removed." ]
    run rm -rf env_status
    
    # this needs to fail
    run $LUA -l StackTracePlus
    [ "$status" -eq 1 ]
}
