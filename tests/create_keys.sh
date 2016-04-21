#!/usr/bin/env bash

usage() {
    echo "Usage: $0"
    echo "       Create keys to be used by the oscap-user account."
    echo "       If you already have keys, put them in keys/id_rsa{,.pub}."
    echo "       Must be run in the same directory as test.yml playbook."
    exit 1
}

[ -f test.yml ] || usage
[ -d keys ] || mkdir keys
[ -f keys/id_rsa ] && usage

ssh-keygen -b 2048 -t rsa -P '' -f keys/id_rsa
ls -l keys
