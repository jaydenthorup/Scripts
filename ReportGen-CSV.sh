sudo -u stc-director psql -c "COPY (select machine.name,state,end_time,last_update,job_type from job join machine on machine.uuid=machine_uuid WHERE last_update BETWEEN NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7 AND NOW()::DATE-EXTRACT(DOW from NOW())::INTEGER and job_type <> 'RETENTION' order by last_update desc) To '/tmp/Weekly-Report.csv' with CSV DELIMITER ',' HEADER;"
sudo cp /tmp/Weekly-Report.csv /opt/StorageCraft/share/StorageCraft/static/
echo -e "Subject:ShadowXafe Weekly Report \n\n Here is your weekly Report\n" > /tmp/mail.txt
uuencode /tmp/Weekly-Report.csv Weekly-Report.csv >> /tmp/mail.txt
cat /tmp/mail.txt | sendmail jaydenthorup@jayfiles.com

