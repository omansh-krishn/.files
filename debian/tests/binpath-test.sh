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
	# skip empty lines
	[ -z "$line" ] && continue
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
	bin=${binpath##*/}
#	echo "bin path is  ${binpath}"
	if apt-file search "$binpath" >/dev/null ; then
		echo "OK: $binpath found"
	elif apt-file search "$bin" | grep  '/bin/\|/sbin/\|/libexec/' ; then
		echo "ERROR: $bin found, but path is not $binpath"
		#this is really bad, like #1069075
		rc=$((rc+1))
	else
		echo "WARNING: $binpath not found in any package!"
		# package is not in archive or is arch specific, like amd64/i386 only
		# not really an issue but warning may help catching scripts with removed packages
	fi
done <  runit-services.runit

exit "$rc"

