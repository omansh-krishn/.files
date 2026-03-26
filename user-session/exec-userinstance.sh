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
# PAM_TTY=/dev/tty1 // current tty
#exit 0
##end debug

test "$(id -u)" = 0 || exit 0 # no power to create or remove the symlinks
user="$PAM_USER"
[ "$user" = 'root' ] && exit 0 #root already has system runsvdir
uid="$(id -u $user)"
[ $uid -ge '1000' ] || exit 0 # try to filter out system users, uid<1000 [sddm, lightdm and so on..)
[ -d "/home/$user" ] || exit 0 # no home directory to start runsvdir

#avoid clash with openrc user-session
[ -d "/run/user/$uid/openrc" ] && exit 0
#and with systemd --user
[ -d "/run/systemd/system" ] && exit 0


#   graphic or vt session?  this need to be accurate:
# stopping the user session on getty/vt logout will be a problem for the graphic session
# starting graphic session for a getty/vt login could be a problem
#TODO: the following filter for graphic only [sddm, lightdm and the like], vt/remote neds more work
#NOTE: this means that we are NOT catching things like "startx" on vt
[ -z "$XDG_SESSION_TYPE" ] && exit 0 # login on xterm or the like
[ "$XDG_SESSION_TYPE" = 'tty' ] && exit 0 #getty login TODO: but what about startx from tty?
# other possible ways to filter out non graphic logins
#[ -z "$XDG_VTNR" ] && exit 0
#[ -z "$DISPLAY" ] && exit 0 #this is not set for wayland, so we can't use it
[ -z "$DESKTOP_SESSION" ] && exit 0 #is this ok? works with openbox and the like?
#TODO: distinguish between xorg and wayland (any use for this?)
#XDG_SESSION_TYPE=x11  --> this is xorg
#XDG_SESSION_TYPE=wayland  --> this is wayland

#start/stop the runsvdir user instance
#LOGIN
if [ "$PAM_TYPE" = "open_session" ]; then #login event for $user
  #enable our runsvdir-user if it's not already enabled
  #prepare the instance
  [ -d /usr/share/runit/sv.now/runsvdir@default ] || exit 1 #should not happen, can't do much without the template
  #TODO replace the following with cpsv p, but needs a versioned depends on runit >= 2.2.0-7
  # START of cpsv replace block ##cpsv p runsvdir@default runsvdir@$user
  [ -d "/etc/sv/runsvdir@$user" ] || mkdir -p  "/etc/sv/runsvdir@$user"
  mkdir -p "/etc/sv/runsvdir@$user/xenv" # dir for graphic environment
  ln -s  "/etc/sv/runsvdir@$user/xenv" "/etc/sv/runsvdir@$user/env"
  mkdir -p "/etc/sv/runsvdir@$user/control"
  mkdir -p "/etc/sv/runsvdir@$user/log"
  mkdir -p "/etc/sv/runsvdir@$user/.meta"
  for target in run finish log/run control/t .meta/bin .meta/onupgrade .meta/enable .meta/pkg; do
    if [ ! -e /etc/sv/runsvdir@$user/$target ] && [ ! -h /etc/sv/runsvdir@$user/$target ]; then
      ln -s /usr/share/runit/sv.now/runsvdir@user/$target  /etc/sv/runsvdir@$user/$target
    fi
  done
  #END of cpsv p replace block
  [ ! -e /etc/sv/runsvdir@$user/run ] && exit 1 # block if is symlink is dangling, template gone
  #set env and enable the user runsvdir
  if [ ! -e /etc/service/runsvdir@$user ] && [ ! -e /etc/service/.runsvdir@$user ]; then
      # set the env for the supervision tree #TODO: which one are really needed? trim the list
      [ -n "$PATH" ] && echo "$PATH" > "/etc/sv/runsvdir@$user/xenv/PATH"
      [ -n "$XDG_RUNTIME_DIR" ] && echo "$XDG_RUNTIME_DIR" >  "/etc/sv/runsvdir@$user/xenv/XDG_RUNTIME_DIR"
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
