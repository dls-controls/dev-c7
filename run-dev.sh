#!/bin/bash

# A script for launching 'RHEL 7 in a Box' on a DLS workstation

# NOTE that changes to this file should also be propgated to .devcontainer.json

image=ghcr.io/dls-controls/dev-c7:latest

environ="-e DISPLAY -e HOME"
volumes="-v /dls_sw/prod:/dls_sw/prod \
        -v /dls_sw/work:/dls_sw/work \
        -v /dls_sw/epics:/dls_sw/epics \
        -v /dls_sw/targetOS/vxWorks/Tornado-2.2:/dls_sw/targetOS/vxWorks/Tornado-2.2 \
        -v /dls_sw/apps:/dls_sw/apps \
        -v /dls_sw/etc:/dls_sw/etc \
        -v /scratch:/scratch \
        -v ${HOME}:${HOME} \
        -v /dls/science/users/:/dls/science/users/"

devices="-v /dev/ttyS0:/dev/ttyS0 -v /dev/dri:/dev/dri"
opts="--net=host --rm -ti --hostname dev-c7 --storage-opt ignore_chown_errors=true"
# this should keep original groups assignment but does not (so we cant write in work)
identity="--security-opt=label=type:container_runtime_t --annotation run.oci.keep_original_groups=1 --userns=keep-id"

# this enables secondary groups assuming crun is installed
if which crun > /dev/null ; then 
    runtime="--runtime /usr/bin/crun"
fi

# -l loads profile and bashrc
command="/bin/bash -l"

podman run ${runtime} ${environ} ${identity} ${volumes} \
    ${devices} ${@} ${opts} ${image} ${command}
