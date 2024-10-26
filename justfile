#!/usr/bin/env -S just --justfile
# just reference  : https://just.systems/man/en/

@default:
    just --list

sync-push:
    git add .
    git commit -m "sync with monolith.nvim"
    git push

