#!/usr/bin/env bash

command -v luarocks >/dev/null 2>&1 || { 
  echo >&2 "luarocks needs to be installed to run this tests"; 
  exit 1
}

if [ -z $LUA ]; then
	export LUA="lua"
fi
command -v $LUA >/dev/null 2>&1 || { 
  echo >&2 "Lua needs to be installed to run this tests"; 
  exit 1
}
