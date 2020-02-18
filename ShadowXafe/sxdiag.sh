#! /bin/bash
journalctl -u stc-director --no-pager > /opt/StorageCraft/share/StorageCraft/static/stc-director-setup.txt

sudo -u stc-director pg_dump | sudo tee -a /opt/StorageCraft/share/StorageCraft/static/db.txt

echo download at 
echo https://$HOSTNAME/stc-director-setup.txt or pull from /opt/StorageCraft/share/StorageCraft/static/
echo https://$HOSTNAME/db.txt or pull from /opt/StorageCraft/share/StorageCraft/static/db.txt
