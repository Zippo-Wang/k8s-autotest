#!/bin/bash


name='"xxx"'
echo $name
name=$(echo ${name} | sed 's/"//g')
echo $name
