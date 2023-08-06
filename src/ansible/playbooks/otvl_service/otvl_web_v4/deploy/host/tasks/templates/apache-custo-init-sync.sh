echo $0 running $*
echo env
env | sort
if [ "$OTVL_WEB_CABRI_SYNC" ]; then
  if [ ! -d /data/obs_otvl_sites ] ; then
    mkdir /data/obs_otvl_sites
    echo "cabri cli dss make --obsrg $OVHRG --obsep $OVHEP --obsct $OVHCT --obsak $OVHAK --obssk $OVHSK obs:/data/obs_otvl_sites"
    cabri cli dss make --obsrg $OVHRG --obsep $OVHEP --obsct $OVHCT --obsak $OVHAK --obssk $OVHSK obs:/data/obs_otvl_sites
  else
    echo "cabri cli dss unlock obs:/data/obs_otvl_sites"
    cabri cli dss unlock obs:/data/obs_otvl_sites
  fi
fi
exec $*