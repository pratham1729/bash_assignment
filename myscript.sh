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
    # n1=${#uid}
    # n2=${#key}
    # j=0
    # keys_array[$j]=${key:9:16}
    # start=0
    # end=0
    # for((i=0;i<$n1;i++));
    # do
    #     if [[ ${uid:i:1} == ']' ]] 
    #     then
    #         start=$i+1
    #     fi
    #     if [[ ${uid:i:1} == '>' ]] 
    #     then
    #         end=$i+1
    #         uid_array[$j]=${uid:$start:$end-$start-1}
    #         ((j++))
    #     fi
    # done
    j=0
    length_key=${#key}
    length_uid=${#uid}
    for((i=0;i<$length_key;i++));
    do
        if [[ ${key:$i:1} == '/' ]] 
        then
            keys_array[$j]=${key:$i+1:16}
            ((j++))
        fi
    done
    j2=0
    s=0
    e=0
    for((i=0;i<$length_uid;i++));
    do
        if [[ ${uid:$i:1} == ']' ]] 
        then
            s=$i+1
        fi
        if [[ ${uid:$i:1} == '>' ]] 
        then
            e=$i+1
            uid_array[$j2]=${uid:$s+1:$e-$s}
            ((j2++))
        fi
    done
    echo "Choose the user"
    for((i=0;i<j;i++));
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