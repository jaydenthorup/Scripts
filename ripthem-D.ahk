/*
========================================================================================
Script Constantly scans DVD drive for DVD. Upon Insertion it Rips/Compresses/Transcodes 
Utilizes DvdDecrypter & HandBrake, Download these and install them with default settings

*Modified 7/17/2012 by amsgwp
	-Converted to utilize MakeMKV instead of DVD Decrypter
	-Modified File Exist
	-Modified to work with bluray

http://www.autohotkey.com/community/viewtopic.php?f=2&t=49262&view=previous
========================================================================================
*/
#singleInstance
#NoEnv

 ;Storage Location Variables - no backslash!!
	dvddrive := "D:"
start:

;Watch For DVD Insertiond
driveget,dvdt,label,%dvddrive% 
if  errorlevel 
   {
   ;No DVD inserted
   sleep 100
   goto start   
   }
else
   {

   ;Check disk in drive is a DVD, if so then, Rip/Compress/Transcode Upon Insertion
 ;SET VARIABLES
      ;==================================================================================================================
     
         temp = S:\RipStaging\AutoRip ;SET PATH FOR TEMPORY STORAGE
         ripdest = %temp%\%dvdt% ;POPULATES ITSELF DON'T CHANGE
         encdest = S:\RipStaging\Encoding\%dvdt% ;SET PATH FOR MOVIES AFTER ENCODING(LEAVE VARIABLE %dvdt%)
      ;Dvd Decrypter Vars
         dvdd = makemkvcon64.exe --robot --minlength=2700 --directio=false --decrypt --messages=%ripdest%\%dvdt%Riplog.txt --progress=%ripdest%\%dvdt%Riplog.txt mkv disc:0 0 %ripdest% ;MakeMKV command line interface, change for 32bit. Additionally, includes CLI params.
         dvddl = C:\Program Files (x86)\MakeMKV ;Location of MAKEMKV directory
      ;Handbrake Vars
         hbcli = HandBrakeCLI.exe -i %ripdest% -o %encdest%\%dvdt%.mkv -F --subtitle scan -N eng -e x264 -q 20.0 -a 1,1 -E faac,copy:ac3 -B 160,160 -6 dpl2,auto -R Auto,Auto -D 0.0,0.0 -f mkv --detelecine --decomb --loose-anamorphic -m -x b-adapt=2:rc-lookahead=50 >%encdest%\%dvdt%encodelog.txt 2>&1;CAN BE LEFT THE SAME (WIN32) 
         hbclil = C:\Program Files\Handbrake ;CAN BE LEFT THE SAME (WIN32)
		 finalrest = S:\RipStaging\CompleteRips ;Do you need to move the file to some other location after encoding? If so, add something here
		 ejectdisk = 1 ;eject disk when completed?
		 ifttts = curl -X POST https://maker.ifttt.com/trigger/dvdstart/with/key/eWmcHBstYVk8MQSksJp59upRPp-Hpa1JFsA7DQDNhf6
		 iftttf = curl -X POST https://maker.ifttt.com/trigger/dvddone/with/key/eWmcHBstYVk8MQSksJp59upRPp-Hpa1JFsA7DQDNhf6
		 
		 
      ;==================================================================================================================
	if FileExist("D:\VIDEO_TS") ;CHANGE DRIVE LETTER TO YOUR DVD DRIVE
      {
	  Goto RipDVD
	  }
	if FileExist("D:\BDMV") ;CHANGE DRIVE LETTER TO YOUR DRIVE
	{
		Goto RipDVD
	}
	Goto start
	          
RipDVD:
      ;Notify
	  Runwait , %ifttts%
	  ;Create Directory and Rip
	  IfExist,%ripdest%
		  {
		  MsgBox, 4, , Destination directory exists: %ripdest%. Do you want to continue? (Press YES or NO)
			IfMsgBox No
			exit
		  }
		  

	  FileCreateDir,%ripdest%
	  Runwait ,%dvdd% ,%dvddl%, min
      sleep 1000
      ;Compress/Encode
	  ;FileCreateDir,%encdest%
      ;RunWait ,%hbcli% ,%hbclil%, min
      sleep 1000
	  Runwait , %iftttf%
	  ;Move file to final place
	  ;If finalrest <> ""
		;  {
		 ; FileCopyDir, %encdest%\%dvdt%, %finalrest%
		 FileMoveDir, %temp%\%dvdt%, %finalrest%
		 ; }
		
      ;Eject Disk?
		  If ejectdisk = 1
		  {
		  drive, eject
		  }
	  
      sleep 1000
      ;Delete Temp files
      ;SetWorkingDir %temp%
      ;FileRemoveDir, %dvdt% ,1
      ;Start entireprocess again
      goto start
      }
      
   
return