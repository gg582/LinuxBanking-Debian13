#!/bin/bash
chmod +x apply_changes.sh
./apply_changes.sh -i IPinside-LWS.x86_64.deb -p changes.patch -o ipinside-lws-fixed.x86_64.deb
