#!/bin/bash

openbox-session &

xset s off
xset noblank
xset -dpms

while true
do
  killall chromium-browser
  rm -rf ~/.{config,cache}/chromium/

  # start browser in your web site: here, just plain old localhost
  # -test-type will ignore any warnings and
  # --ignore-certificate-errors will allow you to kiosk any https-page without displaying certificate errors
  chromium-browser -test-type --ignore-certificate-errors --kiosk --no-first-run --incognito https://yahoo.co.jp/
done