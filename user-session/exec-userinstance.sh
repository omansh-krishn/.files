#! /bin/sh

##debug
#echo "" >> /run/runit-session.log
#date -R  >> /run/runit-session.log
#echo "pam environment is:" >> /run/runit-session.log
#env  >> /run/runit-session.log
#echo "" >> /run/runit-session.log
#
# PAM_SERVICE=login // name of the application that uses PAM
# PAM_RHOST= remote host  --> can we get if it's ssh login here?
# PAM_RUSER = remote user --> can we get if it's ssh login here?
# PAM_USER= current user     THIS <-- (the user to act upon)
# PAM_TYPE= open_session, or close_session  <-- THIS (it match login and logout)
# PAM_TYPE= (account, auth, password,)
# PAM_TTY=/dev/tty1 // current tty, in case of x11 is ":0"(sddm, lightdm,wdm) or ":0.0" (slim)
#exit 0
##end debug

test "$(id -u)" = 0 || exit 0 # no power to create or remove the symlinks
user="$PAM_USER"
[ "$user" = 'root' ] && exit 0 #root already has system runsvdir
uid="$(id -u "$user")"
[ "$uid" -ge '1000' ] || exit 0 # try to filter out system users, uid<1000 [sddm, lightdm and so on..)
[ -d "/home/$user" ] || exit 0 # no home directory to start runsvdir

#avoid clash with openrc user-session
[ -d "/run/user/$uid/openrc" ] && exit 0
#and with systemd --user
[ -d "/run/systemd/system" ] && exit 0

[ -z "$PAM_SERVICE" ] && exit 0
#continue on graphic session, exit on getty/pts/others (remote?) logins
#NOTE in future we may have to register sessions here
case "$PAM_SERVICE" in
    sddm|lightdm|slim|wdm)
      #ok continue, we support the above
   ;;
   login)
    #getty on /dev/ttyN, we don't support this for now (maybe also remote login?)
    exit 0
   ;;
   su-l)
    #always stop this, root on pts
    exit 0
   ;;
   *)
    #things we don't know yet, stop for now
    exit 0
   ;;
esac

#start/stop the runsvdir user instance
#LOGIN
if [ "$PAM_TYPE" = "open_session" ]; then #login event for $user
  #enable our runsvdir-user if it's not already enabled
  #prepare the instance
  [ -d /usr/share/runit/sv.now/runsvdir@default ] || exit 1 #should not happen, can't do much without the template
  #create instance of runsvdir for $user
  if [ ! -d "/etc/sv/runsvdir@$user" ]; then
      cpsv p runsvdir@default runsvdir@"$user"
  fi
  mkdir -p "/etc/sv/runsvdir@$user/xenv" # dir for graphic environment
  if [ ! -h "/etc/sv/runsvdir@$user/env" ] && [ ! -e "/etc/sv/runsvdir@$user/env" ] ; then
    ln -s  "/etc/sv/runsvdir@$user/xenv" "/etc/sv/runsvdir@$user/env"
  fi
  [ ! -e "/etc/sv/runsvdir@$user/run" ] && exit 1 # block if is symlink is dangling, template gone
  #set env and enable the user runsvdir
  if [ ! -e "/etc/service/runsvdir@$user" ] && [ ! -e "/etc/service/.runsvdir@$user" ]; then
      # set the env for the supervision tree #TODO: which one are really needed? trim the list
      #PATH
      echo "/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games" > "/etc/sv/runsvdir@$user/xenv/PATH"
      #XDG_RUNTIME_DIR
      echo "/run/user/$uid" >  "/etc/sv/runsvdir@$user/xenv/XDG_RUNTIME_DIR"
      #DBUS_SESSION_BUS_ADDRESS + runit-dbus-user-session
      if [ -e "/home/$user/.service/dbus" ]; then
        echo "unix:path=/run/user/$uid/bus" >  "/etc/sv/runsvdir@$user/xenv/DBUS_SESSION_BUS_ADDRESS"
      fi
      [ -n "$DISPLAY" ] && echo "$DISPLAY" >  "/etc/sv/runsvdir@$user/xenv/DISPLAY"
      [ -n "$XDG_VTNR" ] && echo "$XDG_VTNR" >  "/etc/sv/runsvdir@$user/xenv/XDG_VTNR"
      [ -n "$XDG_SEAT" ] && echo "$XDG_SEAT" >  "/etc/sv/runsvdir@$user/xenv/XDG_SEAT"
      [ -n "$XDG_SESSION_TYPE" ] && echo "$XDG_SESSION_TYPE" >  "/etc/sv/runsvdir@$user/xenv/XDG_SESSION_TYPE"
      [ -n "$XDG_CURRENT_DESKTOP" ] && echo "$XDG_CURRENT_DESKTOP" >  "/etc/sv/runsvdir@$user/xenv/XDG_CURRENT_DESKTOP"
      [ -n "$XDG_SESSION_ID" ] && echo "$XDG_SESSION_ID" >  "/etc/sv/runsvdir@$user/xenv/XDG_SESSION_ID"
      [ -n "$XDG_SESSION_PATH" ] && echo "$XDG_SESSION_PATH" >  "/etc/sv/runsvdir@$user/xenv/XDG_SESSION_PATH"
      [ -n "$XDG_SEAT_PATH" ] && echo "$XDG_SEAT_PATH" >  "/etc/sv/runsvdir@$user/xenv/XDG_SEAT_PATH"
      [ -n "$XDG_SESSION_CLASS" ] && echo "$XDG_SESSION_CLASS" >  "/etc/sv/runsvdir@$user/xenv/XDG_SESSION_CLASS"
      #[ -n "$" ] && echo "$" >  "/etc/sv/runsvdir@$user/xenv/"
      #finally, enable it
      ln -s "/etc/sv/runsvdir@$user"  "/etc/service/runsvdir@$user"  #TODO link to /etc/runit/runsvdir/default/
  fi
fi

#LOGOUT
if [ "$PAM_TYPE" = "close_session" ]; then #logout event for $user
  #check if it's a linger session
  [ -e "/home/$user/.runit/linger" ] && exit 0
  #disable (stop) our runsvdir-user if it's enabled
  if [ -h "/etc/service/runsvdir@$user" ]; then
    unlink "/etc/service/runsvdir@$user"
  fi
  # more convoluted things can be done here, for example
  # turn a graphic session into a non-graphic one, but require more work
fi

exit 0
