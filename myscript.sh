#!/bin/bash

echo "Welcome to GPG Key Portal"
echo "Choose from the options given below"
echo "1: Use existing Key"
echo "2: Generate a new Key"
echo "3: Quit"

read val

if [ $val -eq 1 ];
then
    uid=$(gpg --list-secret-keys --keyid-format=long|awk '/uid/')
    key=$(gpg --list-secret-keys --keyid-format=long|awk '/sec/{if (length($2)>0) print $2}')
    declare -a uid_array=()
    declare -a keys_array=()
    key_count=0
    length_key=${#key}
    length_uid=${#uid}
    for((i=0;i<$length_key;i++));
    do
        if [[ ${key:$i:1} == '/' ]] 
        then
            keys_array[$key_count]=${key:$i+1:16}
            ((key_count++))
        fi
    done
    uid_count=0
    start=0
    end=0
    for((i=0;i<$length_uid;i++));
    do
        if [[ ${uid:$i:1} == ']' ]] 
        then
            start=$i+1
        fi
        if [[ ${uid:$i:1} == '>' ]] 
        then
            end=$i+1
            uid_array[$uid_count]=${uid:$start+1:$end-$start-2}
            ((uid_count++))
        fi
    done
    echo "Choose the user"
    for((i=0;i<key_count;i++));
    do
        echo $((i+1)) ${uid_array[$i]}
    done
    read val
    echo ${#keys_array}
    x=${keys_array[$((val-1))]}
    echo $x
    gpg --armor --export $x
	git config --global user.signingkey $x
	git config --global commit.gpgsign true
    [ -f ~/.bashrc ] && echo 'export GPG_TTY=$(tty)' >> ~/.bashrc

    echo "Copy this key and paste this in your GPG section of your Github Account"
elif [ $val -eq 2 ];
    then
        gpg --full-generate-key
elif [ $val -eq 3 ];
    then
        echo "Bye for now"
else
    echo "Try Again"
fi