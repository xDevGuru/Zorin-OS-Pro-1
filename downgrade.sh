#!/usr/bin/env bash

set -o pipefail

trap 'exit 1' HUP INT PIPE QUIT TERM

# Check if running on Zorin OS
if ! grep -q "Zorin OS" /etc/os-release; then
	echo "Error: This script only supports Zorin OS."
	exit 1
fi

echo "██████╗  ██████╗ ██╗    ██╗███╗   ██╗ ██████╗ ██████╗  █████╗ ██████╗ ███████╗"
echo "██╔══██╗██╔═══██╗██║    ██║████╗  ██║██╔════╝ ██╔══██╗██╔══██╗██╔══██╗██╔════╝"
echo "██║  ██║██║   ██║██║ █╗ ██║██╔██╗ ██║██║  ███╗██████╔╝███████║██║  ██║█████╗  "
echo "██║  ██║██║   ██║██║███╗██║██║╚██╗██║██║   ██║██╔══██╗██╔══██║██║  ██║██╔══╝  "
echo "██████╔╝╚██████╔╝╚███╔███╔╝██║ ╚████║╚██████╔╝██║  ██║██║  ██║██████╔╝███████╗"
echo "╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝"
echo "|ZORIN-OS-PRO-DOWNGRADE| |Script v0.0.0.1| |Maintained By NamelessNanashi/NanashiTheNameless|"
echo ""
echo "(Please note this tool ONLY works on ZorinOS 18, ZorinOS 17, and ZorinOS 16)"
echo ""
echo "To use this script on:"
echo "ZorinOS 16 use the -6 flag"
echo "ZorinOS 17 use the -7 flag"
echo "ZorinOS 18 use the -8 flag"
echo ""
echo "If a version flag is not specified the script will try to guess"
echo ""
echo "(add -D for dry run mode to preview changes without applying them)"
echo ""
echo "THIS CODE AND THE ACCOMPANYING DOCUMENTATION WERE SIGNIFICANTLY OVERHAULED BY NamelessNanashi/NanashiTheNameless."
echo "https://github.com/NanashiTheNameless/Zorin-OS-Pro IS THE OFFICIAL SOURCE FOR THIS TOOL."
echo "IF YOU GOT THIS CODE ELSEWHERE KNOW THAT THE CODE SHOULD NOT BE FULLY TRUSTED."
echo ""

sleep 8

function fail() {
	echo ""
	echo "You are not running this script correctly, read the GitHub https://github.com/NanashiTheNameless/Zorin-OS-Pro/ for more info"
	echo ""
	exit 1
}

version=""
auto_version="false"
dry_run="false"
dry_run_short_delay=2
dry_run_long_delay=5

while getopts "678D" opt; do
	case $opt in
		6) version="16" ;;
		7) version="17" ;;
		8) version="18" ;;
		D) dry_run="true" ;;
		*) fail ;;
	esac
done

function dry_run_delay() {
	local delay="$1"

	if [ "$dry_run" = "true" ]; then
		echo "Dry Run: simulating timing delay (${delay}s)..."
		sleep "$delay"
	fi
}

# Automatic version detection if no flag provided
if [ -z "$version" ]; then
	version_id=$(grep "^VERSION_ID=" /etc/os-release | cut -d "=" -f2 | tr -d '"' | cut -d "." -f1)
	case "$version_id" in
		16) version="16" ;;
		17) version="17" ;;
		18) version="18" ;;
		*) fail ;;
	esac
	auto_version="true"
fi

if [ "$auto_version" = "true" ]; then
	echo ""
	echo "ZorinOS $version automatically selected. if this is not correct please stop the script with \"CTRL+C\" and re-run the script with the correct version flag."
	echo ""
	sleep 5
fi

if [ "$dry_run" = "true" ]; then
	echo ""
	echo "Dry run mode selected. No changes will be made."
	echo ""
	dry_run_delay "$dry_run_short_delay"
else
	echo ""
	echo "This script will downgrade the Pro repository access added by zorin.sh and purge Pro-specific packages."
	echo "It will not delete installed keys or optional extra packages."
	echo "Type DOWNGRADE to continue. (Case Sensitive)"
	echo ""
	read -r confirmation
	if [ "$confirmation" != "DOWNGRADE" ]; then
		echo "Downgrade cancelled."
		exit 1
	fi
fi

echo ""
echo "Updating the default sources.list for Zorin's standard resources..."
echo ""

function AddSources16() {
sudo cp -f /etc/apt/sources.list.d/zorin.list /etc/apt/sources.list.d/zorin.list.bak 2>/dev/null || true
sudo rm -f /etc/apt/sources.list.d/zorin.list
sudo touch /etc/apt/sources.list.d/zorin.list
sudo tee /etc/apt/sources.list.d/zorin.list > /dev/null << 'EOF'
deb https://packages.zorinos.com/stable focal main
deb-src https://packages.zorinos.com/stable focal main

deb https://packages.zorinos.com/patches focal main
deb-src https://packages.zorinos.com/patches focal main

deb https://packages.zorinos.com/apps focal main
deb-src https://packages.zorinos.com/apps focal main

deb https://packages.zorinos.com/drivers focal main restricted
deb-src https://packages.zorinos.com/drivers focal main restricted

EOF
}

function DryRunSources16() {
echo "Dry Run: would backup and replace /etc/apt/sources.list.d/zorin.list with:"
dry_run_delay "$dry_run_short_delay"
cat << 'EOF'
deb https://packages.zorinos.com/stable focal main
deb-src https://packages.zorinos.com/stable focal main

deb https://packages.zorinos.com/patches focal main
deb-src https://packages.zorinos.com/patches focal main

deb https://packages.zorinos.com/apps focal main
deb-src https://packages.zorinos.com/apps focal main

deb https://packages.zorinos.com/drivers focal main restricted
deb-src https://packages.zorinos.com/drivers focal main restricted

EOF
}

function AddSources17() {
sudo cp -f /etc/apt/sources.list.d/zorin.list /etc/apt/sources.list.d/zorin.list.bak 2>/dev/null || true
sudo rm -f /etc/apt/sources.list.d/zorin.list
sudo touch /etc/apt/sources.list.d/zorin.list
sudo tee /etc/apt/sources.list.d/zorin.list > /dev/null << 'EOF'
deb https://packages.zorinos.com/stable jammy main
deb-src https://packages.zorinos.com/stable jammy main

deb https://packages.zorinos.com/patches jammy main
deb-src https://packages.zorinos.com/patches jammy main

deb https://packages.zorinos.com/apps jammy main
deb-src https://packages.zorinos.com/apps jammy main

deb https://packages.zorinos.com/drivers jammy main restricted
deb-src https://packages.zorinos.com/drivers jammy main restricted

EOF
}

function DryRunSources17() {
echo "Dry Run: would backup and replace /etc/apt/sources.list.d/zorin.list with:"
dry_run_delay "$dry_run_short_delay"
cat << 'EOF'
deb https://packages.zorinos.com/stable jammy main
deb-src https://packages.zorinos.com/stable jammy main

deb https://packages.zorinos.com/patches jammy main
deb-src https://packages.zorinos.com/patches jammy main

deb https://packages.zorinos.com/apps jammy main
deb-src https://packages.zorinos.com/apps jammy main

deb https://packages.zorinos.com/drivers jammy main restricted
deb-src https://packages.zorinos.com/drivers jammy main restricted

EOF
}

function AddSources18() {
sudo cp -f /etc/apt/sources.list.d/zorin.list /etc/apt/sources.list.d/zorin.list.bak 2>/dev/null || true
sudo rm -f /etc/apt/sources.list.d/zorin.list
sudo touch /etc/apt/sources.list.d/zorin.list
sudo tee /etc/apt/sources.list.d/zorin.list > /dev/null << 'EOF'
deb https://packages.zorinos.com/stable noble main
deb-src https://packages.zorinos.com/stable noble main

deb https://packages.zorinos.com/patches noble main
deb-src https://packages.zorinos.com/patches noble main

deb https://packages.zorinos.com/apps noble main
deb-src https://packages.zorinos.com/apps noble main

deb https://packages.zorinos.com/drivers noble main restricted
deb-src https://packages.zorinos.com/drivers noble main restricted

EOF
}

function DryRunSources18() {
echo "Dry Run: would backup and replace /etc/apt/sources.list.d/zorin.list with:"
dry_run_delay "$dry_run_short_delay"
cat << 'EOF'
deb https://packages.zorinos.com/stable noble main
deb-src https://packages.zorinos.com/stable noble main

deb https://packages.zorinos.com/patches noble main
deb-src https://packages.zorinos.com/patches noble main

deb https://packages.zorinos.com/apps noble main
deb-src https://packages.zorinos.com/apps noble main

deb https://packages.zorinos.com/drivers noble main restricted
deb-src https://packages.zorinos.com/drivers noble main restricted

EOF
}

if [ "$version" = "16" ]; then
	if [ "$dry_run" = "true" ]; then
		DryRunSources16
	else
		AddSources16
	fi
elif [ "$version" = "17" ]; then
	if [ "$dry_run" = "true" ]; then
		DryRunSources17
	else
		AddSources17
	fi
elif [ "$version" = "18" ]; then
	if [ "$dry_run" = "true" ]; then
		DryRunSources18
	else
		AddSources18
	fi
else
	fail
fi

echo ""
if [ "$dry_run" = "true" ]; then
	echo "Dry Run: skipped updating the default sources.list for Zorin's standard resources."
else
	echo "Done updating the default sources.list for Zorin's standard resources..."
fi
echo ""

echo ""
echo "Removing premium flag..."
echo ""

if [ "$dry_run" = "true" ]; then
	echo "Dry Run: would remove /etc/apt/apt.conf.d/99zorin-os-premium-user-agent"
	dry_run_delay "$dry_run_short_delay"
else
	if ! sudo rm -f /etc/apt/apt.conf.d/99zorin-os-premium-user-agent; then
		echo "Non-Blocking Error: Failed to remove premium apt user-agent config."
	fi
fi

echo ""
if [ "$dry_run" = "true" ]; then
	echo "Dry Run: skipped removing premium flag. Installed gpg keys would be left in place."
else
	echo "Done removing premium flag. Installed gpg keys were left in place."
fi
echo ""

function apt_update_with_retry() {
	local max_attempts=3
	local attempt=1
	local delay=5

	while [ "$attempt" -le "$max_attempts" ]; do
		echo "Attempting apt-get update (attempt $attempt/$max_attempts)..."
		if sudo apt-get update; then
			return 0
		else
			if [ "$attempt" -lt "$max_attempts" ]; then
				echo "apt-get update failed, waiting ${delay}s before retry..."
				sleep "$delay"
				delay=$((delay * 2))
			fi
			attempt=$((attempt + 1))
		fi
	done
	echo "Warning: apt-get update failed after $max_attempts attempts. Continuing anyway..."
	return 1
}

if [ "$dry_run" = "true" ]; then
	echo "Dry Run: would run sudo apt-get update after removing premium repository access."
	dry_run_delay "$dry_run_long_delay"
else
	if ! apt_update_with_retry; then
		echo "Warning: Failed to refresh apt cache after removing premium repository access. Continuing anyway..."
	fi
fi

function purge_installed_packages() {
	local installed_packages=()
	local package

	for package in "$@"; do
		if dpkg -s "$package" >/dev/null 2>&1; then
			installed_packages+=("$package")
		else
			echo "$package is not installed; skipping removal."
		fi
	done

	if [ ${#installed_packages[@]} -eq 0 ]; then
		echo "No matching installed packages found."
		return 0
	fi

	if [ "$dry_run" = "true" ]; then
		echo "Dry Run: would purge the following packages:"
		printf '  %s\n' "${installed_packages[@]}"
		dry_run_delay "$dry_run_long_delay"
		return 0
	fi

	if ! sudo apt-get purge "${installed_packages[@]}"; then
		echo "Error: Failed to purge one or more Pro-specific packages."
		exit 1
	fi
}

echo ""
echo "Removing Pro-specific APT packages..."
echo ""

pro_packages=(
	zorin-appearance-layouts-shell-premium
	zorin-os-pro
	zorin-os-pro-creative-suite
	zorin-os-pro-productivity-apps
	zorin-os-pro-wallpapers
)

if [ "$version" = "16" ]; then
	pro_packages+=(zorin-os-pro-wallpapers-16)
elif [ "$version" = "17" ]; then
	pro_packages+=(zorin-os-pro-wallpapers-16 zorin-os-pro-wallpapers-17)
elif [ "$version" = "18" ]; then
	pro_packages+=(zorin-os-pro-wallpapers-16 zorin-os-pro-wallpapers-17 zorin-os-pro-wallpapers-18)
else
	fail
fi

purge_installed_packages "${pro_packages[@]}"

echo ""
if [ "$dry_run" = "true" ]; then
	echo "Dry Run: skipped removing Pro-specific APT packages."
else
	echo "Done removing Pro-specific APT packages..."
fi
echo ""

echo ""
echo ""
if [ "$dry_run" = "true" ]; then
	echo "Dry run complete! No changes were made."
	echo ""
	echo "Run this script again without -D to apply the downgrade."
	echo ""
	exit 0
fi

echo "All done!"
echo "If you have any questions or comments please see https://github.com/NanashiTheNameless/Zorin-OS-Pro/discussions/29 for more information on how to deal with them."
echo ""
echo "If you are using this tool and have issues please file a bug report about said issues on GitHub https://github.com/NanashiTheNameless/Zorin-OS-Pro/issues/new?template=bug_report.yml"
echo ""
echo 'Please Reboot your Zorin Instance... You can do so with "sudo reboot" or by pressing "reboot" in the Zorin menu in the bottom left.'
echo ""
echo ""
