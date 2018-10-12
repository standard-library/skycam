#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run with sudo"
  exit
fi

DEFAULT_URL=media.staging.sistercitynyc.com

apt-get update
apt-get -y install ffmpeg

echo "Creating configuration file..."
if [ ! -f ~/.skycamrc ]; then
  read -e -p "Enter URL [media.staging.sistercitynyc.com]:\n> " url
  url=${url:-"media.staging.sistercitynyc.com"}

  read -e -p "Enter UUID:\n> " id

  cat >~/.skcamrc <<EOL
STREAM_URL=${url}
STREAM_ID=${id}
EOL
fi

echo "Linking broadcast script..."
if [ ! -f /usr/local/bin/broadcast ]; then
  ln -s ./broadcast /usr/local/bin/broadcast
fi

echo "Linking broadcast service..."
if [ ! -f /lib/systemd/system/broadcast.service ]; then
  ln -s ./broadcast.service /lib/systemd/system/broadcast.service
fi

echo "Enabling broadcast service..."
systemctl enable broadcast

echo "The last step is to enable the camera module.\n"
echo "raspi-config will now launch. A reboot will be required\n"
echo "to finish the installation."
read -rsp $'> Press any key to continue...\n' -n1 key
