# steam.gpg key
/etc/apt/trusted.gpg.d/steam.gpg:
  file.managed:
    - source: salt://steam/steam.gpg
    
# steam.list for install
/etc/apt/sources.list.d/steam.list:
  file.managed:
    - source: salt://steam/steam.list

# need support for 32-bit
sudo dpkg --add-architecture i386:
  cmd.run

# update before installing steam
apt-get update:
  cmd.run

apt-get install:
  cmd.run

# suggested libraries from repo.steampowered
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
  
# steam lisenssin ehtojen hyväksyminen
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

# If xterm not installed, launching steam will not work and will give error line 42: xterm command not found
xterm:
  pkg.installed

steam:
  pkg.installed:
    - sources:
      - steam-launcher: https://steamcdn-a.akamaihd.net/client/installer/steam.deb
