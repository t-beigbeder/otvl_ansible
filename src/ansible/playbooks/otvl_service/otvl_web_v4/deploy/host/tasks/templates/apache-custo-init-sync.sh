echo $0 running $*
if [ "$OTVL_WEB_CABRI_SYNC" ]; then
  if [ -z "$OTVL_WEB_CABRI_SYNC_REMOTE" ]; then
    if [ ! -d $HOME/obs_otvl_sites ] ; then
      mkdir $HOME/obs_otvl_sites
      echo "cabri cli dss make --obsrg $OVHRG --obsep $OVHEP --obsct $OVHCT --obsak $OVHAK --obssk xxx obs:$HOME/obs_otvl_sites"
      cabri cli dss make --obsrg $OVHRG --obsep $OVHEP --obsct $OVHCT --obsak $OVHAK --obssk $OVHSK obs:$HOME/obs_otvl_sites
    else
      echo "cabri cli dss unlock obs:/data/obs_otvl_sites"
      cabri cli dss unlock obs:$HOME/obs_otvl_sites
    fi
  else
    cabri cli config --put WebBasicAuth "$OTVL_WEB_CABRI_SYNC_WEB_USER" "$OTVL_WEB_CABRI_SYNC_WEB_PASSWORD"
    cabri cli lsns "$OTVL_WEB_CABRI_SYNC_REMOTE"
  fi
  if [ ! -d /data/assets ] ; then
    echo mkdir /data/assets
    mkdir /data/assets
  fi
fi
exec $*