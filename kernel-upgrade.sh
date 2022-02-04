#!/usr/bin/env bash
prerun_checks() {
    if [ "$EUID" -ne 0 ]; then 
        echo -e "${red}Please run as root${reset}"
        error
}
error() {
    echo -e "${red}Error: exiting${reset}" >&2
    exit 1
}
update-kernel() {
	pushd /usr/src/linux > /dev/null 2>&1
	[[ ! -e .config ]] && zcat /proc/config.gz > .config
	
	make -j$(getconf _NPROCESSORS_CONF) && make modules_install && make install
	emerge --ask @module-rebuild
	grub-mkconfig -o /boot/grub/grub.cfg
}
prerun_checks
update_kernel
