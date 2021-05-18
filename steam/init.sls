/etc/apt/trusted.gpg.d/steam.gpg:
  file.managed:
    - source: salt://steam/steam.gpg

/etc/apt/sources.list.d/steam.list:
  file.managed:
    - source: salt://steam/steam.list

sudo dpkg --add-architecture i386:
  cmd.run

apt-get update:
  cmd.run

apt-get install:
  cmd.run

apt-get install -y libgl1-mesa-dri:amd64:
  cmd.run

apt-get install -y libgl1-mesa-dri:i386:
  cmd.run
 
apt-get install -y libgl1-mesa-glx:amd64:
  cmd.run

apt-get install -y libgl1-mesa-glx:i386:
  cmd.run

apt-get install -y steam-launcher:
  cmd.run

dpkg_steam_license:
  cmd.run:
   - unless: which steam
   - name: '/bin/echo /usr/bin/debconf steam/license note | /usr/bin/debconf-set-selections'
   - require_in:
      - pkg: steam
      - cmd: dpkg_steam_question

dpkg_steam_question:
  cmd.run:
    - unless: which steam
    - name: '/bin/echo /usr/bin/debconf steam/question select "I AGREE" | /usr/bin/debconf-set-selections'
    - require_in:
      - pkg: steam

# If xterm not installed, launching steam with cmd.run will not work and will give error line 42: xterm command not found
xterm:
  pkg.installed

steam:
  cmd.run
