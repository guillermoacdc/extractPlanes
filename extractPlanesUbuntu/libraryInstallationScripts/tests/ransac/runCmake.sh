#!/bin/bash
# exit when any command fails
set -e
# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

usernamen=$(logname)
path_home_user="/home/${usernamen}/"
path_run=$(echo $PWD)
path_build_project="${path_home_user}/test/ransac/build"

mkdir -p "${path_build_project}" || true
cd "${path_build_project}"

cmake "${path_run}" -G "Eclipse CDT4 - Unix Makefiles"

echo "Go to ${path_build_project} and make the project :)"