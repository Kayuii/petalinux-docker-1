# petalinux-docker

Copy petalinux-v2018.3-final-installer.run file to this folder. Then run

`docker build --build-arg PETA_VERSION=2018.3 --build-arg PETA_RUN_FILE=petalinux-v2018.3-final-installer.run -t petalinux:2018.3 .`

After installation, launch petalinux with:

`/usr/bin/docker run -itv $(pwd):/work --env=DISPLAY --net=host -v $HOME/.Xauthority:/home/vivado/.Xauthority -v $HOME/.Xresources:/home/vivado/.Xresources -v $HOME/Projects/2018v3:/home/vivado/project petalinux:2018.3 /bin/bash`
