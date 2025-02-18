#!/usr/bin/env bash

error() {
    echo -e "${red}Error: exiting" >&2
    exit 1
}

prerun_checks() {
    # Check for root by checking the UID of the running user
    if [ "$EUID" -ne 0 ]; then 
        echo -e "${red}Please run as root${reset}"
        error
    fi
}

update-kernel() {
    # Changing this since I run a depclean after updating packages, so old kernel versions automatically get removed.
    eselect kernel set 1
    pushd /usr/src/linux > /dev/null 2>&1
    zcat /proc/config.gz > .config
    make -j$(getconf _NPROCESSORS_CONF) && make modules_install && make install
    emerge @module-rebuild
    genkernel --kernel-config=/usr/src/linux/.config initramfs
    eclean-kernel -n 3
}

prerun_checks
update-kernel
