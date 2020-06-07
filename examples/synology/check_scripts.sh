#!/bin/sh
# static code check to sripts and docker files via shellcheck and hadolint using native packages or docker images
set -euo pipefail
IFS=$'\n\t'
MYDIR=$(dirname "$0")
[ "$MYDIR" = "." ] && MYDIR=$(pwd)
# will not run native on synology as shellcheck missing but we can use docker image
if ! [ -x "$(command -v shellcheck)" ] && [ $# -eq 0 ] || [ "$1" != "docker" ]
then
	echo 'Error: shellcheck is not installed; run with parameter docker or use frontend https://www.shellcheck.net/.' >&2
	exit 1
fi
if [ $# -gt 0 ] && [ "$1" == "docker" ]
then
	echo "Switching in sudo mode for Docker. You may need to provide root password at initial call"
	echo "Starting shellcheck for $MYDIR/SPK-PKG/scripts.."
	echo "$(date '+%Y.%m.%d-%H:%M:%S') Starting shellcheck for $MYDIR/SPK-PKG/scripts.." > check_scripts.out
	SCRIPTS=$(ls -p "$MYDIR"/SPK-PKG/scripts/ | grep -v /)
	for S in $SCRIPTS ; do 
		echo "** check $(basename $S).." >> check_scripts.out
		# we allow for all SC2039: local Vars, SC2155 local straight assigned, SC1090 follow non-constant source, we set locally SC2034 unused, 
		sudo docker run -it -v "$MYDIR"/SPK-PKG/scripts/:/mnt \
			-e SHELLCHECK_OPTS="-e SC2039 -e SC2155 -e SC1090 -e SC1091" \
			--rm koalaman/shellcheck $(basename $S) >> check_scripts.out && echo "ok: $(basename $S)" || echo "warnings: $(basename $S)"
	done
	echo "Done for all see check_scripts.out."
else
	grep -rIl '^#![[:blank:]]*/bin/\(bash\|sh\|zsh\)' --exclude-dir=.git --exclude=*.sw? | xargs shellcheck > check_scripts.out
fi
exit 0
