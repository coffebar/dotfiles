if [ -f .config/kindle/.profile ]; then
	# env variables ($PATH)
  . .config/kindle/.profile
fi
exec i3 --shmlog-size 0 -c .config/kindle/i3config
