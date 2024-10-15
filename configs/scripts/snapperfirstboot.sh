#!/usr/bin/env bash
#Snapper doesnt run in chroot due to dbus errors
#Also copying over a snapper config doesn't seem to work correctly
#In order to setup our snapshots correctly, we make a one time boot script
#Create our snapper config
snapper -c root create-config /
#Change snapper backups to keep to 8
sed "s,NUMBER_LIMIT=\"50\",NUMBER_LIMIT=\"10\",g" -i /etc/snapper/configs/root
sed "s,NUMBER_LIMIT_IMPORTANT=\"10\",NUMBER_LIMIT_IMPORTANT=\"5\",g" -i /etc/snapper/configs/root
#Disable all timeline snapshots
sed "s,TIMELINE_LIMIT_HOURLY=\"10\",TIMELINE_LIMIT_HOURLY=\"0\",g" -i /etc/snapper/configs/root
sed "s,TIMELINE_LIMIT_DAILY=\"10\",TIMELINE_LIMIT_DAILY=\"0\",g" -i /etc/snapper/configs/root
sed "s,TIMELINE_LIMIT_WEEKLY=\"0\",TIMELINE_LIMIT_WEEKLY=\"0\",g" -i /etc/snapper/configs/root
sed "s,TIMELINE_LIMIT_MONTHLY=\"10\",TIMELINE_LIMIT_MONTHLY=\"0\",g" -i /etc/snapper/configs/root
sed "s,TIMELINE_LIMIT_YEARLY=\"10\",TIMELINE_LIMIT_YEARLY=\"0\",g" -i /etc/snapper/configs/root
sed "s,TIMELINE_CREATE=\"yes\",TIMELINE_CREATE=\"no\",g" -i /etc/snapper/configs/root
sed "s,TIMELINE_CLEANUP=\"yes\",TIMELINE_CLEANUP=\"no\",g" -i /etc/snapper/configs/root
#Enable snapper system services for cleanup
systemctl enable --now snapper-cleanup.timer
#Disable the snapper config script and timeline timer if it was enabled
systemctl disable snapper-firstboot.service snapper-timeline.timer