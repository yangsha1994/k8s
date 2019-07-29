#!/bin/bash

dir=../images
function LoadDockerFiles(){
    for files in `find  $dir -name "*.tar"`;
    do
    docker load -i  $files
    done
}

LoadDockerFiles
