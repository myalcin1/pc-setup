#!/bin/bash

set -ex

add_to_file_if_not_in () {
	local FILE=$1
	local LINE=$2
	grep ${FILE} -e "^${LINE}$" 1>/dev/null || echo "${LINE}" >> ${FILE}
}

preliminary_downloads () {
	dnf -y install crudini
}

dnf_settings () {
	local FILE="/etc/dnf/dnf.conf"
	crudini --ini-options=nospace --set ${FILE} daemon "fastestmirror" "True"
	crudini --ini-options=nospace --set ${FILE} daemon "max_parallel_downloads" "10"
}

rpmfusion_settings () {
	dnf -y update
	dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
	dnf -y install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	dnf -y install fedora-workstation-repositories
	dnf -y config-manager --enable google-chrome
	dnf -y update
}

bashrc_settings () {
	local USER_HOME=$(getent passwd ${SUDO_USER} | cut -d: -f6)
	local FILE=${USER_HOME}/.bashrc
	add_to_file_if_not_in ${FILE} "unset rc"
	add_to_file_if_not_in ${FILE} "export HISTFILESIZE="
	add_to_file_if_not_in ${FILE} "export HISTSIZE="
}

nvidia_settings () {
	# https://rpmfusion.org/Howto/NVIDIA?highlight=%28%5CbCategoryHowto%5Cb%29#x86_64_.2864bit.29_users
	dnf install -y akmod-nvidia	xorg-x11-drv-nvidia-cuda
}

x11_settings () {
	local FILE="/etc/gdm/custom.conf"
	crudini --ini-options=nospace --set ${FILE} daemon "WaylandEnable" "false"
	crudini --ini-options=nospace --set ${FILE} daemon "DefaultSession" "gnome-xorg.desktop"
}

mouse_settings () {
	# https://github.com/Brian-Lam/Logitech-MX-Master-Key-Mapper-Linux
	x11_settings
	local USER_HOME=$(getent passwd ${SUDO_USER} | cut -d: -f6)
	local FILE=${USER_HOME}/.xbindkeysrc
	dnf install -y xbindkeys xautomation xdotool
	cp .xbindkeysrc ${FILE}
	pkill xbindkeys
	xbindkeys
	mkdir -p ${USER_HOME}/.config/autostart
	cp xbindkeys.desktop ${USER_HOME}/.config/autostart
}

reboot_on_input () {
	read -p "Reboot now? (Y/n): " ${confirm} \
		&& [[ ${confirm} == [nN] || ${confirm} == [nN][oO] ]] \
		|| echo "Rebooting" \
		&& sleep 3 \
		&& reboot
}

main () {
	preliminary_downloads
	dnf_settings
	rpmfusion_settings
	bashrc_settings
	nvidia_settings
	mouse_settings
	reboot_on_input
}

if [ `id -u` -ne 0 ]
then
	sudo bash $0
else
	main
fi

