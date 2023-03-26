#!/bin/sh
#set -e

failed=
skipped=
blacklisted=
rpkglist=
emptylog=
i=0

check_sv () {
# fixit sv in runit, upstream unreleased patch exist
# stat --> run | down
for n in 1 2 3 4 5 6 7 8 9 ; do
	[ "$n" = '9' ] && return 1 #failed
	if [ ! -p "/etc/sv/$service/supervise/ok" ]; then
		echo "ok pipe: not found"
		sleep 0.7 && continue
	fi
	if [ ! -e "/etc/sv/$service/supervise/stat" ]; then
		echo "stat: not found"
		sleep 0.7 && continue
	else
		stat=$(cat "/etc/sv/$service/supervise/stat")
		if [ "$stat" != run ]; then
			echo "stat: is down"
			sleep 0.7 && continue
		else
			echo "stat: run, 1st"
			stat=
			stat=$(cat "/etc/sv/$service/supervise/stat")
			sleep 0.5
			if [ "$stat" = run ]; then # twice in a row to reduce chance of racy 'run'
				return 0 # success!
                        else
				continue
                        fi
		fi
	fi
done
}

apt-get update
apt-get -y install runit-services runit-run
nfailed=0

pidof systemd || echo "systemd not running"

if ! systemctl status runit.service ; then
    echo "runsvdir service not running!"
fi
#touch /etc/runit/verbose

#test rsyslog and dbus first, many other services will fail if these two fails
if test -d /etc/sv/rsyslog ; then
	systemctl stop rsyslog syslog.socket || true
	systemctl disable rsyslog || true
	systemctl mask rsyslog || true
	update-service --add /etc/sv/rsyslog
else
	echo "FAIL: rsyslog: no service directory for /etc/sv/rsyslog"
	nfailed=1
fi
if test -d /etc/sv/dbus ; then
	systemctl stop dbus dbus.socket || true
	systemctl disable dbus || true
	systemctl mask dbus || true
#	echo "checking dbus status with sysvinit"
#	/etc/init.d/dbus status --force-sysv
#	echo $?
	echo "stopping dbus with sysvinit"
	/etc/init.d/dbus stop --force-sysv
	echo $?
	echo "chmod -x dbus" # override noreplace
	chmod -x /etc/init.d/dbus
	update-service --add /etc/sv/dbus
else
	echo "FAIL: dbus: no service directory for /etc/sv/dbus"
	nfailed=1
fi
pidof runsvdir  || true
[ ! -e /etc/service/.forced-rescan ] && echo " no forced rescan so far"
systemctl kill -s 14 runit.service # SIGALRM to force rescan
sleep 7
[ -e /etc/service/.forced-rescan ] && echo " forced rescan done "
pidof runsvdir  || true

echo "pstree output" && pstree

sleep 2 && echo "testing dbus and rsyslog.."
sv check rsyslog || echo "FAIL: rsyslog: status is not up"
sv check dbus || echo "FAIL: dbus: status is not up"
sv u dbus rsyslog
sv s dbus rsyslog

#systemd preset -- block all systemd services from being enabled automatically by APT
mkdir -p /etc/systemd/system-preset
echo 'disable *' > /etc/systemd/system-preset/99-default.preset

# test services now
for dir in sv/* ; do
	service=$(basename "$dir")
	if cat debian/tests/sv-blacklist | grep -E "^$service( |$)" ; then
		echo "INFO: $service: skipping, blacklisted"
		blacklisted=$(echo "$blacklisted $service")
		continue
	fi
	pkgname=$(apt-file search /etc/init.d/"$service" | grep -E "$service"$ | cut -d: -f1 | head -n 1)
	if [ -z "$pkgname" ]; then
		pkgname=$(apt-file search /lib/systemd/system/"$service".service | grep -E "$service.service"$ | cut -d: -f1 | head -n 1)
	fi
	if [ -z "$pkgname" ]; then
		echo "WARNING: can't find a deb package for $service service"
		echo "WARNING: can't perform test for $service, skipping .."
		skipped=$(echo "$skipped $service")
		continue
		#use bin file as fallback
	else
		rpkglist=$(echo "$rpkglist $pkgname")
		i=$((i + 1))
	fi
	apt-get -y install "$pkgname"
	
	if ! test -d /etc/sv/"$service" ; then
		echo "FAIL: $service: no service directory for /etc/sv/$service"
		nfailed=$((nfailed+1))
		failed=$(echo "$failed $service")
		continue
	fi

	systemctl stop "$service" # disable //mask
	update-service --add /etc/sv/"$service" #necessary to enable under systemd
	systemctl kill -s 14 runit.service # SIGALRM to force rescan
	sleep 7
	
	sv u "$service" # request status=up
	if ! check_sv ; then
		echo "FAIL: $service: status is not up"
		sv s "$service" || true # get sv output for debugging
		nfailed=$((nfailed+1))
		failed=$(echo "$failed $service")
		if [ -r /var/log/runit/"$service"/current ]; then
			echo " ------------------ $service LOG START ------------------------"
			tail -n 20  /var/log/runit/"$service"/current
			echo " ------------------ $service LOG END  --------------------------"
		fi
		continue
	else
		if [ -r /var/log/runit/"$service"/current ]; then
			[ ! -s  /var/log/runit/"$service"/current ] && emptylog=$(echo "$emptylog $service")
		fi
	fi
	sv s "$service"   # print sv status, should be up

	if [ "$i" = '5' ]; then
		apt-get -y purge $rpkglist
		i=0
		rpkglist=
		apt-get -y autoremove
		apt-get -y clean
	fi
done

rm /etc/systemd/system-preset/99-default.preset

echo "TEST RESULTS:"
if [ -n "$failed" ]; then
	echo "FAILED: $failed"
else
	echo "FAILED: none"
fi
if [ -n "$skipped" ]; then
	echo "SKIPPED: $skipped"
else
	echo "SKIPPED: none"
fi
if [ -n "$blacklisted" ]; then
	echo "BLACKLISTED: $blacklisted"
else
	echo "BLACKLISTED: none"
fi
if [ -n "$emptylog" ]; then
	echo "HAS EMPTY LOG: $emptylog"
else
	echo "EMPTY LOG: none"
fi

exit "$nfailed"
