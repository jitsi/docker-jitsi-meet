#!/bin/bash
#----------------------------------------------------------------------------------------
# Scriptaufruf:
#----------------------------------------------------------------------------------------
# erstellt das SPK aus dem aktuellen master-branch vom Server:
# sh ./build_spk.sh
#
# erstellt das SPK aus dem als Parameter übergebenen Release vom Server:
# sh ./build_spk.sh 4.0.7
#
#----------------------------------------------------------------------------------------
# Ordnerstruktur:
#----------------------------------------------------------------------------------------
# ./APP --> Arbeitsumgebung (erstellen/editieren/verschieben)
# ./PKG  --> Archivordner zum Aufbau des SPK (Startscripte etc.)
#

set -euo pipefail
IFS=$'\n\t'

function finish {
	git worktree remove --force "$build_tmp" || true # do not fail here, workaround for travis
	rm -rf "$build_tmp"
}
trap finish EXIT

#######

project="kopano4s"

#######

if ! [ -x "$(command -v git)" ]; then
	echo 'Error: git is not installed.' >&2
	exit 1
fi

if ! [ -x "$(command -v fakeroot)" ]; then
	echo 'Fakeroot is not installed; using sudo, you might need to give pwd at initial call when archive wil be build..' >&2
	FAKEROOT="sudo"
else
	FAKEROOT=$(command -v fakeroot)
fi

# Arbeitsverzeichnis auslesen und hineinwechseln:
# ---------------------------------------------------------------------
# shellcheck disable=SC2086
APPDIR=$(cd "$(dirname $0)";pwd)
cd "${APPDIR}"

build_tmp=$(mktemp -d -t tmp.XXXXXXXXXX)
buildversion=${1:-latest}
taggedversions=$(git tag)

echo " - INFO: Erstelle den temporären Buildordner und kopiere Sourcen hinein ..."

git worktree add --force "$build_tmp" "$(git rev-parse --abbrev-ref HEAD)"
pushd "$build_tmp"
set_spk_version="$(date +%Y.%m.%d)-$(git log -1 --format="%h")"

if echo "$taggedversions" | grep -q "$buildversion"; then
	echo "git checkout zu $buildversion"
	git checkout "$buildversion"
	set_spk_version="$buildversion"
else
	echo "ACHTUNG: Die gewünschte Version wurde im Repository nicht gefunden!"
	echo "Die $(git rev-parse --abbrev-ref HEAD)-branch wird verwendet!"
fi

# fallback to old pkg and app dirs
if [ -d "$build_tmp"/PKG ]; then
	PKG=PKG
else
	PKG=SPK-PKG
fi
if [ -d "$build_tmp"/APP ]; then
	APP=APP
else
	APP=SPK-APP
fi

build_version=$(grep version "$build_tmp/$PKG/INFO" | awk -F '"' '{print $2}')
#set_spk_version=$build_version

echo " - INFO: Es wird foldende Version geladen und gebaut: $set_spk_version - BUILD-Version (INFO-File): $build_version"

# Ausführung: Erstellen des SPK
echo ""
echo "-----------------------------------------------------------------------------------"
echo "   SPK wird erstellt..."
echo "-----------------------------------------------------------------------------------"

# Falls versteckter Ordners /.helptoc vorhanden, diesen nach /helptoc umbenennen
if test -d "${build_tmp}/.helptoc"; then
	echo ""
	echo " - INFO: Versteckter Ordner /.helptoc wurde lokalisiert und nach /helptoc umbenannt"
	mv "${build_tmp}/.helptoc" "${build_tmp}/helptoc"
fi

# Packen und Ablegen der aktuellen Installation in den entsprechenden /Pack - Ordner
echo ""
echo " - INFO: Das Archiv package.tgz wird erstellt..."

# in non-fakeroot sudo mode change to root owner 
if [ "$FAKEROOT" = 'sudo' ] ; then sudo chown -R root.root "${build_tmp}"/"$APP" ; fi
cd "${build_tmp}"/"$APP"
$FAKEROOT tar -C "${build_tmp}"/"$APP" -czf "${build_tmp}"/"$PKG"/package.tgz .
#"$FAKEROOT" tar -cfvz "${build_tmp}"/"$PKG"/package.tgz *

# Wechsel in den Ablageort von package.tgz bez�glich Aufbau des SPK's
if [ "$FAKEROOT" = 'sudo' ] ; then sudo chown -R root.root "${build_tmp}"/"$PKG" ; fi
cd "${build_tmp}"/"$PKG"

# Erstellen des eigentlichen SPK's
echo ""
echo " - INFO: Das SPK wird erstellt..."

$FAKEROOT tar -cf "${project}"_"$set_spk_version".spk *
# in non-fakeroot sudo mode change back ownership
if [ "$FAKEROOT" = 'sudo' ]
then
	USR=$(whoami)
	sudo chown -R "$USR".users "${build_tmp}" 
fi
cp -f "${project}"_"$set_spk_version".spk "${APPDIR}"

echo ""
echo "-----------------------------------------------------------------------------------"
echo "   Das SPK wurde erstellt und befindet sich unter..."
echo "-----------------------------------------------------------------------------------"
echo ""
echo "   ${APPDIR}/${project}_$set_spk_version.spk"
echo ""

exit 0
