#!/bin/sh
set -e

# test that path in bin file remains consistent with the one
# used by packages; packages rarely changes path of executable
# but when they do, it breaks our services. see #1069075

rc=0

echo "importing dh-runit control file.."
cp debian/runit-services.runit "$AUTOPKGTEST_TMP"
echo "done"

apt-file update

cd "$AUTOPKGTEST_TMP"

while read line ; do
	firstchar="$(echo $line | head -c 1)"
	if [ "$firstchar" = '#' ]; then
		echo "skipping, line commented"
		continue
	fi
#	echo "$line"
	binpath=$(echo "$line" | sed 's/^.*bin=/bin=/')
#	echo "bin path is  ${binpath}"
	binpath=${binpath%%,*}  #just to be sure
	binpath=${binpath#*=} #strip bin=
#	echo "bin path is  ${binpath}"
	if apt-file search "$binpath" >/dev/null ; then
		echo "OK: $binpath found"
	else
		rc=$((rc+1))
		echo "ERROR: $binpath not found in any package!"
	fi
done <  runit-services.runit

exit "$rc"

