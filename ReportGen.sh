echo -e "Subject:ShadowXafe Weekly Report \n\n Here is your weekly Report\n" > /tmp/mail.txt
sudo -u stc-director psql -c " select machine.name,state,end_time,last_update,job_type from job join machine on machine.uuid=machine_uuid WHERE last_update BETWEEN NOW()::DATE-EXTRACT(DOW FROM NOW())::INTEGER-7 AND NOW()::DATE-EXTRACT(DOW from NOW())::INTEGER and job_type <> 'RETENTION' order by last_update desc">>/tmp/mail.txt
cat /tmp/mail.txt | sendmail jaydenthorup@jayfiles.com



