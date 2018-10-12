#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run with sudo"
  exit
fi

DEFAULT_URL=media.staging.sistercitynyc.com

echo "Updating..."
apt-get update

echo "Installing ffmpeg..."
apt-get -y install ffmpeg

echo "Creating configuration file..."
if [ ! -f /home/pi/.skycamrc ]; then
  read -e -p "> Enter URL [media.staging.sistercitynyc.com]: " url
  url=${url:-DEFAULT_URL}

  read -e -p "> Enter stream UUID: " id

  cat >/home/pi/.skycamrc <<EOL
STREAM_URL=${url}
STREAM_ID=${id}
EOL
fi

echo "Linking broadcast script..."
if [ ! -f /usr/local/bin/broadcast ]; then
  ln -s $(pwd)/broadcast /usr/local/bin/broadcast
fi

echo "Linking broadcast service..."
if [ ! -f /lib/systemd/system/broadcast.service ]; then
  ln -s $(pwd)/broadcast.service /lib/systemd/system/broadcast.service
fi

echo "Enabling broadcast service..."
systemctl enable broadcast

echo "The last step is to enable the camera module.\n"
echo "raspi-config will now launch, and you will need to\n"
echo "follow the prompts to enable the camera hardware\n"
echo "A reboot will be required to finish the installation."
read -rsp $'> Press any key to continue...\n' -n1 key
raspi-config
