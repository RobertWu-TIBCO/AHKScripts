;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
AutoTrim,On
#Hotstring O1 Z1 *0 ?0 ; this makes hotstring not appending extra space anymore ! take care if any hotstring relys on a space 2016-04-29   ;#Hotstring O0 ;default appending a space
; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;-------------------------------------------------------------------------------------
#h::  ; Win+H hotkey
; Get the text currently selected. The clipboard is used instead of
; "ControlGet Selected" because it works in a greater variety of editors
; (namely word processors).  Save the current clipboard contents to be
; restored later. Although this handles only plain text, it seems better
; than nothing:
;AutoTrim Off  ; Retain any leading and trailing whitespace on the clipboard.
AutoTrim On ;use this since /vimp gets vimpevimperator after double space pressed ;not helpping
ClipboardOld = %ClipboardAll%
Clipboard =  ; Must start off blank for detection to work.
Send ^c
ClipWait 1
if ErrorLevel  ; ClipWait timed out.
    return
; Replace CRLF and/or LF with `n for use in a "send-raw" hotstring:
; The same is done for any other characters that might otherwise
; be a problem in raw mode:
StringReplace, Hotstring, Clipboard, ``, ````, All  ; Do this replacement first to avoid interfering with the others below.
StringReplace, Hotstring, Hotstring, `r`n, ``r, All  ; Using `r works better than `n in MS Word, etc.
StringReplace, Hotstring, Hotstring, `n, ``r, All
StringReplace, Hotstring, Hotstring, %A_Tab%, ``t, All
StringReplace, Hotstring, Hotstring, `;, ```;, All
Clipboard = %ClipboardOld%  ; Restore previous contents of clipboard.
; This will move the InputBox's caret to a more friendly position:
SetTimer, MoveCaret, 10
; Show the InputBox, providing the default hotstring:
InputBox, Hotstring, New Hotstring, Type your abreviation at the indicated insertion point. You can also edit the replacement text if you wish.`n`nExample entry: :R:btw`::by the way,,,,,,,, :R:`::%Hotstring%
if ErrorLevel  ; The user pressed Cancel.
    return
IfInString, Hotstring, :R`:::
{
    MsgBox You didn't provide an abbreviation. The hotstring has not been added.
    return
}
; Otherwise, add the hotstring and reload the script:
FileAppend, `n%Hotstring%, %A_ScriptFullPath%  ; Put a `n at the beginning in case file lacks a blank line at its end.
Reload
Sleep 200 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
MsgBox, 4,, The hotstring just added appears to be improperly formatted.  Would you like to open the script for editing? Note that the bad hotstring is at the bottom of the script.
IfMsgBox, Yes, Edit
return
MoveCaret:
IfWinNotActive, New Hotstring
    return
; Otherwise, move the InputBox's insertion point to where the user will type the abbreviation.
Send {Home}{Right 3}
SetTimer, MoveCaret, Off
return
;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------
::sea1.2::TLS v1.2
::kb1.2::LBN 43418 for BW 5.12 and LBN 43938 for BW 5.11
::/tcptrace::
(
 So could you please use attached TcpTrace to capture what request is sent out and what response is sent back for the "Send HTTP Request" in "HTTPReceiverTranslate.process" ?
  Please save attach TcpTrace.exe, configure it like below and start capturing a trace:
Listen on Port : 9999
Destination Server : localhost
Destination Port : 8988
  Now start a test to reproduce your earlier error and see the job processes to "Send HTTP Request" in "HTTPReceiverTranslate.process". 
)
::/tcptrace2::
(
 Please use attached TcpTrace.exe and do the capturing.
  i.e, change the host in "send mail" to "localhost:9977".
  Then start TcpTrace with "Listen on Port" -> "9977", "Destination Server" -> "smtp.163.com" and "Destination Port" ->  "25".
  Now send a mail from BW and you could get the Tcp package.
  Do the same in .Net program and compare the out bound Tcp packages of BW and .Net.
  
  Attached screen shoots for your reference on how to configure and use TcpTrace(you could just check the send mail related screen shoots).
  
  E:\EasyOSLink\PCMasterMove\Pictures\work\mail
  G:\SRAll\AllMayDay\ToAttach\PickMailTcpTrace.PNG
  E:\EasyOSLink\PCMasterMove\Pictures\Life\PickmailTcpTrace\PickMailTcpTrace2.PNG
)
::vpnfail::
(
Ready to connect. Contacting vpn-cdc.tibco.com. Connection attempt has failed.
Ready to connect. Contacting  Connection attempt has failed.
)
::virtualbw::
(
We have searched our KB, unfortunately, we didn’t find any official tests for our products with Virtual layer, and there are no records for any customers having used VMware VMotion. While we have a document about TIBCO Products supporting virtualized OS, I think you can contact VMware support for some ideas, meanwhile you can refer to our document about VM support.
 
****************************************************************
Document:     LBN1-7058UQ
Product:        All Products
Version:
Abstract: Do TIBCO products support virtualized Operating Systems using such products as VMware, Solaris Containers, and IBM LPARs?
Description:  
TIBCO's approach to virtual systems is to treat each as a transparent layer. We build our products to the native operating system (e.g., Windows, Solaris, etc.) and provide customers support whether an approved virtual layer is present or they are running on the native OS. Since we do not test our products with the virtual layer, the support is based on the virtualization vendor providing complete transparency.
Based on use by TIBCO customers and field staff, TIBCO currently approves the following virtualization products:
 VMware
     Sun's Solaris Containers and Zones
     IBM's LPARs for z/OS and i5/OS (currently not supporting LPARs on AIX pSeries)
We do not currently support Linux virtualization systems such as Xen.
Service requests involving TIBCO products running on a supported operating system hosted by an approved virtualization system will be handled by TIBCO Support in the customary manner, as though the virtualization was not present. We will not require (but may request, if TIBCO feels it will help advance the SR analysis) customers to reproduce their issue on the native operating system. Issues that can be demonstrated on the virtualized system but cannot be reproduced by TIBCO or the customer on the native (unvirtualized) operating system will need to be escalated by the customer to the virtualization vendor (e.g., VMware, Sun, IBM) for resolution. As with other third-party issues, TIBCO Support will assist the customer with such escalations.
For service requests involving non-approved virtualization products TIBCO Support is more likely to require that the customer reproduce the issue on the native operating system and we will not be able to assist in the escalation to the virtualization vendor if such escalation is required.
TIBCO Support is not in a position to provide customers with recommendations on configuring virtual systems, or estimating the performance overhead that virtual systems may levy.
*******************************************************************
------------------------------------------------------------------------------------- 
)
::toomanyfiles::
(
   Also , please share the output of :
cat /proc/sys/fs/file-max
cat /etc/security/limits.conf
ulimit -n
ulimit -p
)
::itmail::ess_it@pactera.com
::babyname::伍航毅，伍睿哲，伍子航，伍子行（hang），伍子乐，伍毅航，
::onetab1::http://www.one-tab.com/page/33iUc54DRgCV_zCxihT3hA
::inouttrace::
(
Trace.Task.*=true
Trace.Log=true
Trace.Debug.*=true
bw.engine.showInput=true
bw.engine.showOutput=true
bw.plugin.http.server.debug:true
)
::simpletrace::
(
Trace.Task.*=true
Trace.Log=true
Trace.Debug.*=true
bw.engine.showInput=true
bw.engine.showOutput=true
bw.plugin.http.server.debug:true
)
::rdpclipfail::found it caused by temp folder using RAM disk but I have disabled RAM disk. ;once clipboard shred with mstsc session there comes an error. the same error with bcompare because of the incorrect tmp folder.
 ;-------------------------------------------------------------------------------------
 ::/info::TIBCO_HOME/_installInfo
::8vpn::No valid certificates available for authentication
::pavpn::160.101.0.60
::cdcvpn::202.106.55.138
::/icacls::
(
cmd.exe /c takeown /f "%1" /r /d y && icacls "%1" /grant administrators:F /t
cmd.exe /c takeown /f "%1" /r /d y && icacls "%1" /grant yawu@tibco-support.com:F /t
E:\EasyOSLink\Run\AdminWork\grant2.bat     add permissions
E:\EasyOSLink\Run\AdminWork\grant.bat   remove other permission and leave only new permission!
E:\EasyOSLink\Run\AdminWork\own.bat FolderName
)
;-------------------------------------------------------------------------------------
::secuset::jdk.tls.disabledAlgorithms=
::sslset::
send ^j
sleep 200
send jdk.tls.disabledAlgorithms=
return
;-------------------------------------------------------------------------------------
::/eve::everything.exe
::/c::cmd
/*
copy C:\Windows\System32\drivers\etc\hosts E:\EasyOSLink\Run\AdminWork\bakhosts
c copy E:\EasyOSLink\Run\AdminWork\oldhosts C:\Windows\System32\drivers\etc\hosts
c copy E:\EasyOSLink\Run\AdminWork\newhosts C:\Windows\System32\drivers\etc\hosts
*/
::/cancel:: jdbc:tibcosoftwareinc:sqlserver://<host>:<port#>;databaseName=<databaseName>;EnableCancelTimeout=true
::/ext::tibco.class.path.extended
::157sqlserver::jdbc:tibcosoftwareinc:sqlserver://192.168.68.157:1433;databaseName=test
/*
chkconfig
service vncserver stop
service vncserver start
ssh -l root localhost -p 49162
ps -ef
netstat LISTENING
*/ 
/*
伍
承宇
怀远
姓名：伍洋 性别：男血型：o 出生日期 （公历）：1992年2月21日 （农历）壬申（猴）年正月十八日，星期5 属相：猴 星座：双鱼座
承宇
*/ 
::/paste::send ^v;use this in cmd fails 
;::srun::{#}srun
::endof::{#}end of ahk
:o:ar::aristocrat
::/hib::hibernate ;fails
::/**::*******************************************************************
;-------------------------------------------------------------------------------------
::/run::E:\EasyOSLink\Run\AdminWork
::rxpe::rxpe03292010
;-------------------------------------------------------------------------------------
::/wensi::海淀区西二旗中关村软件园二期文思海辉大厦
::/bj::北京
::/decryptclass::java myDecryption #!NW9yV68pkM6yYyM03jVl2wWhswxQjcJx
::/decryptprocess::g:\SRAll\AllMayDay\20160322\POC_SENDRIDGE\;G:\SRAll\ToAttach\KB\DecryptAdminPass
::/weblogic::G:\SRAll\AllMayDay\ToAttach\QQDown\EMS Connect to Weblogic JMS Server\weblogic_conn_L3
::/wrongdecrypt::java -cp F:\tibco\tra\5.9\hotfix\lib\TibCrypt.jar -jar decrypt.jar #!NW9yV68pkM6yYyM03jVl2wWhswxQjcJx
::/adminpasshack::E:\tibco513\tra\domain\513Admin59
::莆田系医院的做法::
(
关系，暗门这些东西已经是在毒瘤中国。而不再是以往我们看到的简单地帮个忙，行个方便，有点人情味儿。人情味儿和毒瘤应经完全是两回事儿了！
)
::badmac::
(
Dear customer,
  Thanks for your update.
  We have seen the "Bad Record MAC" error in other tickets before and it is caused by the SSL server side only supporting SSLv3 while BW sends a TLSv1 ClientHello.
  We used below properties to fix the issue, which I have shared to you before:
   
   java.property.TIBCO_SECURITY_VENDOR=j2se
   java.property.com.sun.net.ssl.rsaPreMasterSecretFix=true
   Below KBs are just for your reference which shows the "j2se" and "rsaPreMasterSecretFix" properties help:
    KB 44965 , KB 37743 , KB 26803 , KB 43087 , KB 41062 , KB 36703
$formula($global.my_email_signature)
)
::/nosuchfielderror::
(
To identify this issue, we enabled the debug trace as following:
1 Enable the tomcat debug, appended below lines in  TIBCO_HOME/bw/BW_VERSION/lib/log4j.properties 
log4j.logger.com.tibco.bw.service.binding.bwhttp.tomcat.TomcatServer=DEBUG, tibco_bw_log
log4j.logger.org.apache.catalina.core.ContainerBase.[Catalina].[localhost]=DEBUG, tibco_bw_log
log4j.logger.org.apache.catalina.core=DEBUG, tibco_bw_log
log4j.logger.org.apache.catalina.session=DEBUG, tibco_bw_log
 
2 For BW engine,  added below properties into the deployed application tra file.
Trace.Task.*=true
Trace.JC.*=true
Trace.Startup=true
Trace.Engine=true
Trace.Debug.*=true
bw.plugin.http.server.debug=true
3 Then started the application from command line (with following line in the application.sh file)
--debug > $FilePath/debugout.txt 2>&1
From the log trace, we can get more error trace like the below, and we can see that the BW hotfix version also is different (working application: hotfix 12,  no-working application: hotfix 21).
<<<<
......
java.lang.NoSuchFieldError: j2seClassLoader
        at com.tibco.bw.service.binding.bwhttp.tomcat.BwWebAppClassLoader.loadClass(Unknown Source)
        at org.apache.catalina.loader.WebappClassLoader.loadClass(WebappClassLoader.java:1559)
        at java.lang.Class.forName0(Native Method)
        at java.lang.Class.forName(Unknown Source)
        at com.sun.naming.internal.VersionHelper12.loadClass(Unknown Source)
        at com.sun.naming.internal.ResourceManager.getFactory(Unknown Source)
        at javax.naming.spi.NamingManager.getURLObject(Unknown Source)
        at javax.naming.spi.NamingManager.getURLContext(Unknown Source)
        at javax.naming.InitialContext.getURLO
......
>>>>
 
4 To compare the difference for the loaded jars between in working machine and no-working machine, we also added the following property in application tra file.
java.extended.properties=-verbose:class
)
::/ahkf::F:\Program Files\AutoHotkey\Scripts
::/mouseahk::F:\Program Files\AutoHotkey\Scripts\Good\MoreFunctions\NumpadMouse.AHK
;"F:\Program Files\AutoHotkey\Scripts\Good\MoreFunctions\TextSelectCopy.ahk" 
;"F:\Program Files\AutoHotkey\Scripts\Good\MoreFunctions\DragKingCopy.ahk"
::/ahkm::F:\Program Files\AutoHotkey\Scripts\AHK Script Manager
;-----------------------------------------------------------------------------------
::/--debug::
(
If you go to the directory <TIBCO_home>\tra\domain\<domain_name>\application\<application_name> you'll see your deployed project here.
Ex: 
test-Process_Archive.cmd (or .sh on Unix)
test-Process_Archive.tra
Open the .cmd (or .sh in Unix) file, you'll see the following:
Ex:
"/Tibco-home/bw/BW-Version/bin/bwengine.exe" --run --propFile "/Tibco-home/tra/domain/<domain_name>/application/<projectName>/test-Process_Archive.tra"
Modify it as follows:
"/Tibco-home/bw/BW-Version/bin/bwengine.exe" --debug --propFile "/Tibco-home/tra/domain/<domain_name>/application/<projectName>/test-Process_Archive.tra" > "/Tibco-home/tra/domain/<domain_name>/application/<projectName>/debug.out" 2>&1
What we have done here is to start the application in debug mode, redirect the stdout and stderr to a file called debug.out. Save these changes and restart your BW engine from command line (manually run the .sh file), you'll get the engine debug output.
)
;-------------------------------------------------------------------------------------
::/gae::http://www.ccav1.me/chromegae.html  
::/bwallremainvacation::F:\GeekWorkLearn\SortGeekFiles\Shawn\FromServerPC\mail-v6\DBAdmin\ImproveNS\QueryAllRemainDaysCSS1112_baseOn0918_baseOnCalculateAllRemainDays_20160322SucceedSam.process
::/60allqueryvacation::F:\tibco\bw\5.12\examples\Project\UpdateBWVacation0120Morning\RealUpdateVacation0121\0812AfterRealUpdated\QueryAllMembers_notLocal\EveryoneQuery.process
::/updatevacation1::F:\tibco\bw\5.12\examples\Project\UpdateBWVacation0120Morning\RealUpdateVacation0121\HttpLogin_12348_TestGVString_AllNew0121.process
::/updatevacation2::F:\tibco\bw\5.12\examples\Project\UpdateBWVacation0120Morning\RealUpdateVacation0121\1542CSS1704_12349.process
;ctrl+1 for vimperator would go to the root of the web site
;-------------------------------------------------------------------------------------
::/econf::
openfile("F:\Program Files\Everything\Everything.ini")
return
;use open_file_command2=$exec("F:\Program Files\Notepad++\notepad++.exe" "%1") to open by pad but this applies to even exe files and cause trouble so disable this
;$exec("F:\Program Files\Notepad++\notepad++.exe" "%1")
;certmgr.msc
;SR_ID:691883 and SR_ID:691240
/*
open_folder_command2=$exec("C:\Program Files\TotalCMD64\Totalcmd64.exe" "%1")
open_file_command2=$exec("F:\Program Files\Notepad++\notepad++.exe" "%1")
open_path_command2=$exec("C:\Program Files\TotalCMD64\Totalcmd64.exe" "$parent(%1)")
explore_command2=$exec("C:\Program Files\TotalCMD64\Totalcmd64.exe" "%1")
explore_path_command2=$exec("C:\Program Files\TotalCMD64\Totalcmd64.exe" "%1")
;------------------------------------------------------------------------------------- 
open_folder_command2=$exec("C:\Program Files\TotalCMD64\Totalcmd64.exe" "%1")
open_file_command2=
open_path_command2=$exec("C:\Program Files\TotalCMD64\Totalcmd64.exe" "$parent(%1)")
;bad ones as there are ( inside !
explore_command2=$exec("X:\Program Files (x86)\Clover\clover.exe" "%1")
explore_path_command2=$exec("X:\Program Files (x86)\Clover\clover.exe" "%1")
;------------------------------------------------------------------------------------- 
explore_command2=$exec("C:\Program Files\Clover\clover.exe" "%1")
explore_path_command2=$exec("C:\Program Files\Clover\clover.exe" "%1")
explore_command2=$exec("C:\Program Files\Clover\clover.exe" "%1")
explore_path_command2=$exec("C:\Program Files\Clover\clover.exe" "%1")
;------------------------------------------------------------------------------------- 
win8
open_folder_command2=$exec("C:\Program Files\TotalCMD64\Totalcmd64.exe" "%1")
open_path_command2=$exec("C:\Program Files\TotalCMD64\Totalcmd64.exe" "$parent(%1)")
explore_command2=$exec("C:\Program Files\Clover\clover.exe" "%1")
explore_path_command2=$exec("explorer.exe" "%1")
win10
open_folder_command2=$exec("C:\Program Files\TotalCMD64\Totalcmd64.exe" "%1")
open_path_command2=$exec("C:\Program Files\TotalCMD64\Totalcmd64.exe" "$parent(%1)")
explore_command2=
explore_path_command2=
*/ 
;-------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------
::/br::" " 
::/[::[ ]
::/{::{{} { }}
::/(::( ) 
::/9::{( } { )}
::/"::" "
::/<::< >
;::/8::{*} 
::/8::
(
/*
*/
)
::/7::{&} 
::/6::{^} 
::/5::{%}
::/4::{$} 
::/3::{#} 
::/2::{@} 
::/1::{!} 
;::/.::.
::/'::' '
  
;------------------------------------------------------------------------------	
::/slowness::
a= If there is slowness even started from commandline, please append below lines to application.tra and restart by "nohup ./app.sh &" to see if it is better(change "HostName" to the real HostName of the running BW server). @@ @@ @@ bw.plugin.http.server.defaultHost=HostName @@ java.property.TIBCO_SECURITY_VENDOR=j2se @@ java.property.javax.net.debug=ssl,plaintext,record,handshake @@ java.net.preferIPv4Stack=true @@ java.property.java.security.egd=file:/dev/./urandom @@ @@   If further help needed, please share the nohup.out file.
ConvertAndPasteMailContent(a)
ConvertAndPasteMailContent(a)
{
StringReplace, clipboard, a, @@, `n, All
Send ^v
return
}
;-------------------------------------------------------------------------------------
::enablessl3::http://10.106.148.71/ka/000/45679.htm
::/ready::  Kindly let me know once you are ready for a webex.
::/des::designer
::soaptrace::
(
 Please append below lines to designer.tra and restart designer to test again:
Trace.Task.*=true
Trace.Log=true
Trace.Debug.*=true
bw.engine.showInput=true
bw.engine.showOutput=true
bw.plugin.http.server.debug=true
java.property.com.tibco.plugin.soap.trace.inbound=true
java.property.com.tibco.plugin.soap.trace.outbound=true
java.property.com.tibco.plugin.soap.trace.pretty=true
java.property.com.tibco.plugin.soap.trace.stdout=true
java.property.TIBCO_SECURITY_VENDOR=j2se
java.property.javax.net.debug=ssl,plaintext,record,handshake
  Kindly share designer console content once the issue repeates.
)
::r,::send Run,
:R:dese::deserialize
:R:shortly::We are checking this issue now and would update you shortly.
::invoker transformer::http://10.106.148.71/sr/704096
::fire::firefox
;-------------------------------------------------------------------------------------
;file
::wtm::  ;windows do not allow / when giving folder names
FormatTime, CurrentDateTime,, yyyy-MM-dd h:mm:ss ;tt means morning or afternoon
SendInput %CurrentDateTime%
return
::]t::  ; This hotstring replaces "]d" with the current date and time via the commands below.
FormatTime, CurrentDateTime,, yyyy/M/d h:mm tt  
SendInput %CurrentDateTime%
return
::/tm::
FormatTime, CurrentDateTime,, yyyy-MM-dd h:mm tt ; tt means morning or afternoon
;FormatTime, CurrentDateTime,, M/d/yyyy h:mm:ss tt
SendInput %CurrentDateTime%
return
::/day::
FormatTime, CurrentDateTime,, yyyy-MM-dd ; h:mm:ss ;tt means morning or afternoon
SendInput %CurrentDateTime%
return
::wday::
FormatTime, CurrentDateTime,, yyyy-MM-dd ; h:mm:ss ;tt means morning or afternoon
SendInput %CurrentDateTime%
return
::/time::
FormatTime, CurrentDateTime,, M/d/yyyy h:mm:ss tt
SendInput %CurrentDateTime%
return
;it prints current time!
;use to input time
-------------------------------------------------------------------------------------
::/mouse::http://58.30.31.213:9999/Synaptics_v17_0_19_C_XP32_Vista32_Win7-32_XP64_Vista64_Win7-64_Acme_Inc.zip
::ifwin::
CheckFile("F:\Program Files\AutoHotkey\Scripts\AHK Script Manager\scripts\gmailFireCloverPad_simple.ahk")
sendinput {#}IfWinActive ahk_exe
return
::ifwin2::
;send #IfWinActive ahk_exe
sendinput #IfWinActive ahk_exe
return
/*
*/
::/slash::
ReplaceSlash(clipboard)
return
::/cp::clipboard
::/clip::clipboard
::/slash2::
StringReplace, clipboard, clipboard, /, \, All
Send ^v
return
bra(a)
{
RegExReplace(clipboard, "^","{") ;not working . I just simuate that in vi 
RegExReplace(clipboard, "$","}")
Send ^v
return
}
::/bwhttp::"Send HTTP Request" activity
::/http::"Send HTTP Request" activity
::/comb::combination
::/act::activity
::/note::notepad{+}{+}.exe
::/excep::exception
::traxml::
(
Dear customer,
  This is Robert from BW team cooperating on this ticket.
  Here is a detail explanation on how to use property within an application or to all applications.
 1. Add the line to the application.tra if the application is already deployed. Then it takes effect once you restart this application. 
 
 2. Add the line to the bwengine.tra of the BW box then any application deployed later to that BW Box, would have the line in its application tra.
 
 3. You could put below lines inside the bwengine.xml file on the machine where you create EAR file in designer (i.e,mine is "F:\tibco\bw\5.12\lib\com\tibco\deployment\bwengine.xml")  :
<property>
           <name>java.property.com.tibco.tibjms.reconnect.attempts</name>
           <option>java.property.com.tibco.tibjms.reconnect.attempts</option>
           <default>20,5000</default>
           <description>Specify the reconnecting parameters for BW engine to EMS server</description>
    </property>
  Then recreate the EAR in designer.
  When you deploy the EAR in Admin GUI, you could now see and configure above property for the specific applications.
)
;-------------------------------------------------------------------------------------
::/quote::
;send ^c ;you can not copy it when you have override it
StringReplace, clipboard, clipboard, ”, ", All
Send ^v
return
;-------------------------------------------------------------------------------------
::cho::ClientHello
::sho::ServerHello
;-------------------------------------------------------------------------------------
:R:max::Maximum
:R:auto::automatically
;-------------------------------------------------------------------------------------
::/certs::certificates
::/proj::F:\tibco\bw\5.12\examples\Project
::iddown::E:\EasyOSLink\PCMasterMove\Downloads\Compressed
:R:incon::inconvenience
::"/::    ; 其实输出//本身，目的在于防止输入法将//变成、、
    sendbyclip("`""")
    return
::\/::    ; 其实输出//本身，目的在于防止输入法将//变成、、
    sendbyclip("\\")
    return	
	
/*
::./::
    SendbyClip("。")
    return
	
::./::
    SendbyClip(".")
    return
::`;/::   ;found it not really helping
    SendbyClip(";")
    return
*/	
::open2::
WinMenuSelectItem, A, , 1&,2& 
return 
;=====================================================================o
;------------------------------------------- 
/*
hotString
*/ 
::/cacert13::E:\tibco513\tibcojre64\1.8.0\lib\security\cacerts
::/v2::SSLv2 Hello
::/sep::Security Provider
::/tac::Instructions to Tac
::/update::Thanks for your update.
::/glad::Glad to know your good news.
::/confirm::Thanks for your confirm.
::/summary:: Thanks for your time in webex. Here is a summary.
::/secus:: "tibco_home\tibcojre64\1.7.0\lib\security\java.security"
::/bwxml::F:\tibco\bw\5.12\lib\com\tibco\deployment\bwengine.xml
::/secu::javasecurity
::/contact::Thanks for contacting TIBCO Support.
::/al::alias 
::/mail::yawu@tibco-support.com
::/pass::{!}VMD1kult
::/pass1::{!}VMD1kult1
::/pass11::{!}VMD1kult11
::/pss::{!}VMD1kult
::/j2se::java.property.TIBCO_SECURITY_VENDOR=j2se
::/ssltrace::java.property.javax.net.debug=ssl,plaintext,record,handshake
::/sorry::Sorry for the delay to update.
::/sslgv::BW_GLOBAL_TRUSTED_CA_STORE
::/verbose::java.extended.properties=-verbose:class
::/tacgp::TAC Workgroup
::/log4j::"tibco_home\bw\5.x\lib\log4j.xml" or "tibco_home\bw\5.x\hotfix\lib\log4j.xml"
::/ahk::autohotkey
::/fire::firefox
::.e::.exe
::/vimp::vimperator
::/caps::CapsLock & 
::/cps::CapsLock & 
::cps/::CapsLock & 
::/nego::renegotiation
::/78::192.168.78.
::/68::192.168.68.
::/1::192.168.1.
::/2::192.168.2.
::/70::192.168.70.
::/72::192.168.72.
::/pro::/etc/profile
::/zhen::真融宝	
::/bao::真融宝
::/ding::真融宝定期
::/comp::compatible
::/destra::designer.tra
::/tra::designer.tra
::/bwtra::bwengine.tra
::/apptra::application.tra
::/157thin::jdbc:oracle:thin:@192.168.69.157:1521:orcl
::/174dd::jdbc:tibcosoftwareinc:oracle://192.168.69.174:1521;SID=ORCL
::/157dd::jdbc:tibcosoftwareinc:oracle://192.168.69.157:1521;SID=ORCL
::/cooperate::This is Robert from BW team cooperating on this ticket.
::/coop::This is Robert from BW team cooperating on this ticket.
::/approot::"tibco_home\tra\domain\DomainName\datafiles\AppName_root\" 
::/appdata::"tibco_home\tra\domain\DomainName\datafiles\AppName_root\" 
::/appname::"tibco_home\tra\domain\DomainName\application\AppName\"
::/if::java.property.automatic_mapper_if_surround=true
;------------------------------------------- hotstring2
::/zjk::河北省张家口市万国汽配城(白云街)
::/shacheng::沙城客运站(公交站)
::/zjktrain::沙城张家口南 火车时刻表
::/wuyang::伍洋
::/wu::伍洋
::/company::文思海辉大厦
::/wen::文思海辉大厦
::/home::融泽嘉园一号院6号楼2单元
::/rong::融泽嘉园一号院6号楼2单元
::/hlg::回龙观新村西区
::/trace::-p G:\SRAll\AllMayDay\20160215\onlySOAPTrace.txt
::/emsd::tibemsd.exe
::/130::13041204920
::/185::18519103730
::/8567::01058858567
::/travel::https://axo.citsamex.com/onlineHEAD/citsamexOnlineSystemLoading.action?currTime=1458140924200
::pacmail::
Run,https://outlook.office365.com/owa/?path=/mail/inbox
return 
::/leave::support特殊上班时间
::/attend::http://attendance.pactera.com/index.aspx
::/153::15311439700
::/182::18201323266
::/421::421126199201183157
::/qq1::1533661890
::qqmail::1533661890@qq.com
::/qq2::1042367231
::/qq3::281815837
::/wufa::wufa1992love
::/app::application
::/apps::/application.sh
::/mq::java.property. com.ibm.mq.cfg.useIBMCipherMappings=false
::MQSSL::
Run,http://www-01.ibm.com/support/docview.wss?uid=swg21614686
return
::/ahkwhy::
Run,http://tieba.baidu.com/p/2828734233
return 
::/bw::TIBCO ActiveMatrix BusinessWorks
::/bwid::33
::/bwl3::BusinessWorksL3
::/sam::huang_jianfeng@pactera.com,jhuang@tibco-support.com
::/samp::huang_jianfeng@pactera.com
::/adminmail::huang_jianfeng@pactera.com,yang.wu0@pactera.com
::/admin::administrator
::/pu::普耐尔（Ployer）MOMO8W双系统 8英寸平板电脑
::/momo::普耐尔MOMO8W
;-------------------------------------------
::/-::-------------------------------------------------------------------------------------
::/#::################################################
::/`;::  ; good use !
(
;-------------------------------------------------------------------------------------
)
::`;-::  ; good use !
(
;-------------------------------------------------------------------------------------
)
::`;/::  ; good use !
(
;-------------------------------------------------------------------------------------
)
::/511tls::
(
Dear customer,
    Thanks for contacting TIBCO Support. 
	
	 I. Please check KB 43938 for more details.  I am posting the content for you here :
	 
	 TIBCO BusinessWorks 5.11 now supports TLS v1.2. Please note the following requirements for using TLS v1.2 :
1.  TRA 5.8.0 hotfix-08 must be installed.
2.  TLS 1.2 is not supported with Entrust hence security provider must be set to  "j2se" or "ibm" (for IBM JRE's only) . This can be done by adding the following property to deployed BW application .tra :
      java.property.TIBCO_SECURITY_VENDOR=j2se
	  
	  II. Note that whenever TRA 5.8 HF 06 or later applied, BW HF 10 or later must be applied. This is logged in KB 44661.
	  
	  Above content mentioned TRA 5.8.0 hotfix-08 must applied, but you had batter install the latest TRA and BW hotfix(or at least TRA 5.8.0 hotfix-08 + BW HF 10 should be applied).
	  
	  III. After applying the TRA and BW hotfixes , please change the lower "psp" to upper "psp" in bwengine.tra if it is a Linux server. 
	  
	  If designer is used, please manually add "%TRA_HOME%/hotfix/lib" to the beginning of "tibco.env.CUSTOM_CP_EXT " in designer.tra, otherwise, the hotfix jars are not loaded.
	   
	   (BW-16620: BW installer updates designer.tra and makes TRA hotfix files not get loaded)
	   (BW-16642: After installation of BW 5.11 Hotfix_12, it puts %psp% incorrectly in bwengine.tra, which should be %PSP%. This caused the TRA5.8 hotfix_07 couldn't work)
	   
)
::/Tibco::Tibco123
::/T123::Tibco123
::/Tpass::Tibco123
::/tpass::tibco123
::/t123::tibco123
::/team::Please transfer this to Designer team.
::/transfer::Please transfer this to Designer team.
::/tibco::tibco123
::/bwlib::
Run,F:/tibco/bw/5.12/lib/palettes/
return 
::/program::
Run,E:\EasyOSLink\PCMasterMove\Downloads\Programs
return 
::/yang::yang.wu0@pactera.com
::/pmail::yang.wu0@pactera.com
::/pacid::P0033374
::/pid::P0033374
::/pac::PACTERA
::/rain::shelleyloverain
::/rainmsn::shelleyloverain@msn.cn
::/msn::shelleyloverain@msn.cn
::/vpn::vpn-cdc.tibco.com
::/dear2::
(
Dear customer,
     Thanks for contacting TIBCO Support.
)
::/dear::
(
Dear customer,
   
)
::/soaphead::
( 
POST /Service/getBook HTTP/1.1
content-type: text/xml; charset="utf-8"
SoapAction: "/Service/getBook"
Connection: close
User-Agent: Jakarta Commons-HttpClient/3.0.1
Host: localhost:9091
Content-Length: 526
<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Header><ns:user xmlns:ns="http://xmlns.example.com/1102035516033/GetBookImpl" xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">DSS1</ns:user></SOAP-ENV:Header><SOAP-ENV:Body><ns0:Title xmlns:ns0="http://www.books.org">Babysteps1</ns0:Title></SOAP-ENV:Body></SOAP-ENV:Envelope>
) 
::/soapres::
( 
HTTP/1.1 200 OK
Server: Apache-Coyote/1.1
Content-Type: text/xml;charset=utf-8
Content-Length: 734
Date: Thu, 10 Mar 2016 17:26:02 GMT
Connection: close
<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Header><ns:transactionID xmlns:ns="http://xmlns.example.com/1102035516033/GetBookImpl/Service" xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="xs:string">1</ns:transactionID></SOAP-ENV:Header><SOAP-ENV:Body><ns0:Book xmlns:ns0="http://www.books.org"><ns0:Title>Babysteps1</ns0:Title><ns0:Author>Unknown</ns0:Author><ns0:Date>1-1-2002</ns0:Date><ns0:ISBN>1-2-3-4</ns0:ISBN><ns0:Publisher>Business Press</ns0:Publisher><ns0:Price>1000.00</ns0:Price></ns0:Book></SOAP-ENV:Body></SOAP-ENV:Envelope>
) 
::/testtls::tls1test.salesforce.com
::/local::localhost
::/soapkb::
(
1. To get SOAP outgoing messages, please check KB 46382. Below is he trace tha could help print SOAP messages.
Trace.Task.*=true
bw.engine.showInput=true
bw.engine.showOutput=true
bw.plugin.http.server.debug=true
java.property.com.tibco.plugin.soap.trace.inbound=true
java.property.com.tibco.plugin.soap.trace.outbound=true
java.property.com.tibco.plugin.soap.trace.filename=onlySOAPTrace.log
java.property.com.tibco.plugin.soap.trace.pretty=true
java.property.com.tibco.plugin.soap.trace.stdout=true
 )
;-------------------------------------------------------------------------------------
;use CapsLock & g to paste above trace lines at once ! now use soaptrace ,the string short !
::/soaptrace::
(
Trace.Log=true
Trace.JC.*=true
Trace.Task.*=true
Trace.Debug.*=true
Trace.Engine=true
bw.engine.showInput=true
bw.engine.showOutput=true
bw.plugin.http.server.debug=true
java.property.com.tibco.util.Debug.enabled=true
java.property.debug=true
java.property.com.tibco.plugin.soap.trace.inbound=true
java.property.com.tibco.plugin.soap.trace.outbound=true
java.property.com.tibco.plugin.soap.trace.pretty=true
java.property.com.tibco.plugin.soap.trace.stdout=true
java.property.com.tibco.plugin.soap.trace.filename=SOAPLog.log
)
::/soaptrace2::
;a=Trace.Log=true @@Trace.JC.*=true @@Trace.Task.*=true @@Trace.Debug.*=true
a=Trace.Log=true @@Trace.JC.*=true @@Trace.Task.*=true @@Trace.Debug.*=true @@Trace.Engine=true @@bw.engine.showInput=true @@bw.engine.showOutput=true @@bw.plugin.http.server.debug=true @@java.property.com.tibco.util.Debug.enabled=true @@java.property.debug=true @@java.property.com.tibco.plugin.soap.trace.inbound=true @@java.property.com.tibco.plugin.soap.trace.outbound=true @@java.property.com.tibco.plugin.soap.trace.pretty=true @@java.property.com.tibco.plugin.soap.trace.stdout=true @@java.property.com.tibco.plugin.soap.trace.filename=SOAPLog.log
;StringReplace, out, a, @@, `n, All
StringReplace, clipboard, a, @@, `n, All
;MsgBox, % out
;MsgBox, % clipboard
Send ^v
return
::/591hf4::
a=com.tibco.security.ssl.client/server.EnableTLSv1   @@com.tibco.security.ssl.client/server.EnableTLSv11   @@com.tibco.security.ssl.client/server.EnableTLSv12   @@com.tibco.security.ssl.server.EnableSSLv2Hello    
ConvertAndPasteMailContent(a)
::poss::possibilities
::ccbw::jhuang@tibco-support.com, vkhatri@tibco.com,bw-xsg@tibco.com 
::/slow::
a= If there is slowness even started from commandline, please append below lines to application.tra and restart by "nohup ./app.sh &" to see if it is better(change "HostName" to the real HostName of the running BW server). @@ @@ @@ bw.plugin.http.server.defaultHost=HostName @@ java.property.TIBCO_SECURITY_VENDOR=j2se @@ java.property.javax.net.debug=ssl,plaintext,record,handshake @@ java.net.preferIPv4Stack=true @@ java.property.java.security.egd=file:/dev/./urandom @@ @@   If further help needed, please share the nohup.out file.
ConvertAndPasteMailContent(a)
::/ssldebug::
(
  Please append below lines to application tra and restart by cmdline "nohup ./application.sh &":
java.property.TIBCO_SECURITY_VENDOR=j2se
java.property.javax.net.debug=ssl,plaintext,record,handshake
  Kindly share the nohup.out file once the issue repeates.
)
::/ssldebug2::
(
  Please confirm whether the issue happens in deployed application or designer tests.
  
  Please append below lines to application tra or designer.tra and restart by cmdline "nohup ./application.sh &" or restart designer to test again:
  
java.property.TIBCO_SECURITY_VENDOR=j2se
java.property.javax.net.debug=ssl,plaintext,record,handshake

  Kindly share the nohup.out file or designer console content once the issue repeates. 
)
::/hf4kb::http://10.106.148.71/ka/000/46722.htm
::/gc::java.extended.properties=-Xincgc -verbose\:gc -XX\:+PrintGCTimeStamps -XX\:+PrintGCDateStamps -XX\:+UseGCLogFileRotation -Xloggc\:/tmp/supportGC.log -XX\:+PrintGCDetails
::/gcperm::java.extended.properties=-Xincgc -verbose\:gc -XX\:+PrintGCTimeStamps -XX\:+PrintGCDateStamps -XX\:+UseGCLogFileRotation -Xloggc\:/tmp/supportGC.log -XX\:+PrintGCDetails -XX:PermSize=86m -XX:MaxPermSize=160m
-------------------------------------------------------------------------------------
::/httpwired::
(
  2. To get HTTP Header, please enable the following in files like "F:\tibco\bw\5.12\lib\log4j.properties"(if the bw hotfix folder has the same file then use that one):
log4j.logger.org.apache=DEBUG, tibco_bw_log
log4j.logger.httpclient.wire.header=DEBUG, tibco_bw_log
log4j.logger.org.apache.commons.httpclient.util.IdleConnectionHandler=WARN
  Then restart the application to check the trace. Please check KB 46754 and KB 45336 for more details.
 )
 
::/webexurl::https://tibcomc.webex.com/meet/yawu
::webex1::
Run,https://tibcomc.webex.com/meet/yawu
return 
::/webex::
(
Dear customer,
    Please join the webex now.   https://tibcomc.webex.com/meet/yawu
)
::/help:: Feel free to contact us whenever you need a hand.
::/feel:: Feel free to contact us whenever you need a hand.
::/hold::Shall we close this ticket or hold it for you for some time ?
::/bye::
(
Dear customer,
     Thanks for your confirm .
     We will close the ticket now. Feel free to contact us whenever you need a hand.
)
::/close::
(
    We will close the ticket now. Feel free to contact us whenever you need a hand.
)
::/welcome::
(
Dear customer,
    Thanks for contacting TIBCO Support.
)
::/ssl3:: ;needed if BW holds a server even if you changed javasecurity
(
java.property.com.tibco.security.ssl.client.EnableSSLv3=true 
java.property.com.tibco.security.ssl.server.EnableSSLv3=true
)
::/getfile::takeown /D /F * ; help to change all folder to mine owned
;bw 6 AppNode tra adds below lines and a line "jmx..local=false"
::/jmx2::
send java.property.com.sun.management.jmxremote=true
send {Space}{Enter}
send java.property.com.sun.management.jmxremote.port=50050
send {Space}{Enter}
send java.property.com.sun.management.jmxremote.authenticate=false
send {Space}{Enter}
send java.property.com.sun.management.jmxremote.ssl=false
send {Space}{Enter}
return
::/oralceout::set serveroutput on
::/157spy::jdbc:tibcosoftwareinc:oracle://192.168.69.157:1521;SID=ORCL;SpyAttributes=(log=(file)c:/spy.log;timestamp=yes);
::/pactera::
(
最近报销系统的改变着实带来了很多麻烦。
由于夜班本身也忙，新系统和老系统相比不仅完全摸不着边，加班餐费填写报销也是诸多不畅。多个同事的报销单被打回还需要额外精力去处理工作之外的事。
文思上线了很多方便的新系统，比如Hub用起来就挺方便。整合了诸多一起的系统，一个页面方便了所与人——不用保存那么多公司专用书签了！
我当然希望在更新新系统时不是为了更新而更新，而能考虑到其使用和方便之处。
文思本身挺大，对新系统的使用和熟悉需要额外精力，新系统越复杂，需要的时间就更长了，相反也耽误主要工作的效率了。
一直觉得文思的办公环境和团队之间的关系挺不错的。只是很少有机会和大家一起参与组织性的活动。与常看到的百度西二旗附近的活动相比，多少有点希望文思能在业余时间策划一些有意义，轻松开放的活动。毕竟，工作一周有时真的心态挺累的，需要些开放又有点组织性的活动。我们到底是在北京，首都，是工作成长也是生活成长，在玩中成长的一个难以让人忘记的地方。多结识些我们公司相处的来互相欣赏的朋友对人生一辈子都是一件有长远影响的事。
文思海辉员工满意度、敬业度调研 - 2016
)
::/jmx::
(
java.property.com.sun.management.jmxremote=true
java.property.com.sun.management.jmxremote.port=50050
java.property.com.sun.management.jmxremote.authenticate=false
java.property.com.sun.management.jmxremote.ssl=false
)
::/endmy::
(
 Regards & Thanks,
 Robert Wu
 TIBCO Support
)
::/end::
(
 Regards & Thanks,
 Robert Wu
 TIBCO Support
)
::/endf::$formula($global.my_email_signature) 
;------------------------------------------- 
/*
comment contents 
show or hide the title bar
*/ 
::/comm::
(
/*
*/
)
-------------------------------------------------------------------------------------
;I mean to use goodpasten_testThreeLine,.txt instead of the bak file but finally I notice that "IfInString" may get multiline back!
;then I use IfEqual and this helps a lot 
;IT SEEMS YOU CANNOT CALL a key combination again,i.e,CAPS G, IF THE FIRST CALL IS NOT FINISHED
;!PgUp::
!Home::
Send {ENTER}-------------------------------------------------------------------------------------{ENTER}
Send ^s
return
;!PgDn::
!End::
send {CTRLDOWN}a{CTRLUP}
send {right}
send {SHIFTDOWN}{ENTER}{SHIFTUP}
send -------------------------------------------------------------------------------------
send {ENTER}
send ^s
return
;-------------------------------------------SpecialSimualte
;$#u::UseClipBoardRunUse("as","end","MsgBox % ClipBoard")
/*
UseClipBoardRunUse(start,end,use)
{
current_clipboard = %Clipboard%
Send ^c
ClipWait, 1
clipboard = %start%%clipboard%%end%
Run %use%
Clipboard = %current_clipboard%
return
}
*/
;-------------------------------------------
::rec::receive
;------------------------------------------------------------------------------------- 
::greattls1.2::
(
Dear customer,
  Thanks for contacting TIBCO Support.
  1. It seems you succeed in BW 5.13 but fail when deploy to BW 5.11.
  There is a great chance that your server accepts TLSv1.2(sent by BW 5.13) but rejects TLSv1.0(sent by default BW 5.11 if no TRA hotfix applied).
  If you could get the ssl trace from server side, you should be able to see that server rejecting TLSv1 ClientHello.
  Please do share the server ssl trace if you could!
  2. If you are not to apply the hotfix first, please do get a server side ssl trace and append below lines to application tra and restart by cmdline "nohup ./application.sh &":
java.property.TIBCO_SECURITY_VENDOR=j2se
java.property.javax.net.debug=ssl,plaintext,record,handshake
  Kindly share the nohup.out file once the issue repeates so we could check in details.
  3. Kindly confirm if you could apply TRA and BW hotfix following below tips so the application should work:
-------------------------------------------------------------------------------------
I. Please check KB 43938 for more details.  I am posting the content for you here :
     
     TIBCO BusinessWorks 5.11 now supports TLS v1.2. Please note the following requirements for using TLS v1.2 :
1.  TRA 5.8.0 hotfix-08 must be installed.
2.  TLS 1.2 is not supported with Entrust hence security provider must be set to  "j2se" or "ibm" (for IBM JRE's only) . This can be done by adding the following property to deployed BW application .tra :
      java.property.TIBCO_SECURITY_VENDOR=j2se
     
II. Note that whenever TRA 5.8 HF 06 or later applied, BW HF 10 or later must be applied. This is logged in KB 44661.
     
  Above content mentioned TRA 5.8.0 hotfix-08 must applied, but you had batter install the latest TRA and BW hotfix(or at least TRA 5.8.0 hotfix-08 + BW HF 10 should be applied).
     
III. After applying the TRA and BW hotfixes , please change the lower "psp" to upper "psp" in bwengine.tra and application.tra if it is a Linux server.
     
  If designer is used, please manually add "%TRA_HOME%/hotfix/lib" to the beginning of "tibco.env.CUSTOM_CP_EXT " in designer.tra, otherwise, the hotfix jars are not loaded because of below defects.
      
  (BW-16620: BW installer updates designer.tra and makes TRA hotfix files not get loaded)
  (BW-16642: After installation of BW 5.11 Hotfix_12, it puts %psp% incorrectly in bwengine.tra, which should be %PSP%. This caused the TRA5.8 hotfix_07 couldn't work)       
  -------------------------------------------------------------------------------------
 Regards & Thanks,
 Robert Wu
 TIBCO Support
 )
 
 ;E:\EasyOSLink\PCMasterMove\Downloads\Compressed\SampleLogger\NewJar\SampleLogger>jar -cvf  SampleLogger.jar ./*
::/random::java.property.java.security.egd=file:/dev/./urandom
::/bisw::Biswajit
::/mft::
(
Could you please follow the steps below to upload large files to MFT:
----------------------------------------
How do customers upload files to TIBCO Support?
Once they have accessed the site, they need to cd into the directory Customer_FTP_Home-Upload  and transfer files to this location.
Sample Instructions:
Please upload the files to the TIBCO Support file transfer server- mft.tibco.com.
Server name: mft.tibco.com
Credentials: use your TSC (TIBCO Support Central website) login.
Browser:  https://mft.tibco.com
FTP: port 21
SFTP: port 22
FTP using your browser is not supported, please use an FTP client or command-line.  TIBCO employees must use a secure protocol. 
Once logged on you can upload the files into the Customer_FTP_Home-Upload  directory. 
Don’t forget to cd first before attempting to transfer:
>cd Customer_FTP_Home-Upload
-----------------------------------------
)
::/1950::6225768730111950
::/5727::6214830100585727
::/path::
(
C:\Windows\SysWOW64;C:\Windows\System32;F:\Program Files\Java\jdk1.8.0_102\bin;E:\Win10TH2Share\cygwin64\bin;E:\EasyOSLink\PCMasterMove\Downloads\Compressed\cmder_mini\vendor\conemu-maximus5;D:\Program Files (x86)\Git\bin\ssh;D:\Program Files (x86)\Git\bin;E:\Win10TH2Share\Program Files\VMware\VMware Workstation\openssl;%Run%\AdminWork;%Run%\CompanyBiz;%Run%\Folder;%Run%\LAN;%Run%\Online;%Run%\OS;%Run%\SR;%Run%\SysSoft;E:\Sort1113OldNote\UseOldDell\reusesoft\sim_linux\cygwin\bin\;E:\Sort1113OldNote\UseOldDell\reusesoft\OpenSSH\bin;D:\Program Files (x86)\Git\bin;E:\Sort1113OldNote\UseOldDell\reusesoft\sim_linux\Mxt85\bin;E:\EasyOSLink\Run\SSL;E:\tibco513\tibrv\8.4\bin;C:\Program Files (x86)\Common Files\NetSarang;C:\Program Files (x86)\MySQL\MySQL Server 5.5\bin;C:\ProgramData\Oracle\Java\javapath;C:\windows;C:\windows\System32\Wbem;C:\windows\System32\WindowsPowerShell\v1.0;G:\SRAll\AllMayDay\0815\NtTrace;F:\Program Files\YourKit Java Profiler 9.0.3\bin\win64;F:\tibco\tibcojre64\1.7.0\bin;f:\tibco\tibrv\8.4\bin;G:\SysManage\HelpSoft\btrace-bin-1.3.3\bin;%BTRACE_HOME%\bin;.;
)
::/path10::
(
E:\EasyOSLink\Run\AdminWork;F:\Program Files\Java\jdk1.7.0_09\bin;E:\EasyOSLink\Run\backup;E:\EasyOSLink\Run\SR;E:\EasyOSLink\Run\CompanyBiz;E:\EasyOSLink\Run\Folder;E:\EasyOSLink\Run\LAN;E:\EasyOSLink\Run\Online;E:\EasyOSLink\Run\OS;E:\EasyOSLink\Run\SSL;E:\EasyOSLink\Run\SysSoft;%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;E:\Win10TH2Share\Program Files\VMware\VMware Workstation;%SYSTEMROOT%\System32\WindowsPowerShell\v1.0\;E:\EasyOSLink\Run\Win10;D:\Program Files (x86)\Git\bin
)
;powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient). DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
::/nohup::Then restart by "nohup ./app.sh &" and share the nohup.out file.
::/vacationbody::
(
concat("Your vacation application:&lf;&lf;",$Start/input_details/mail_body,"&lf;&lf;has been successfully recorded in our system. Please do NOT reply this email.&lf;&lf;Your NS vacations remain: ",$Start/input_details/ns_remain,"&lf;Your Annual vacations remain: ",$Start/input_details/annual_remain,"&lf;Your total vacations remains: ",$Start/input_details/total_remain,"&lf;&lf;Thanks.&lf;&lf;This email is sent by system automatically")
)

::firejs::http://firefoxbar.github.io/{#}userscripts
::attachtcp::G:\SysManage\SoftFolders\TCPTraceLearn
;《精通正则表达式》
::/-/::---------------------------------------------
::/vmwareid::5A02H-AU243-TZJ49-GTC7K-3C61N
::/regtest::[{Hotkey=,p:p,v:v,h:h}{00000804}{1}][{Hotkey=,u:u}{00000804}{1}][{Hotkey=,u:u}{00000804}{1}][{Hotkey=,p:p,v:v,h:h}{00000804}{1}]
;-------------------------------------------------------------------------------------
::repemscrash::
(
  And for the JMS issue, after detail check with Alex and Jing, I have also repproduced the error on my local machine.

    Here are my steps to reproduce the error.

  1.  added below lines to "F:\tibco\ems\8.1\samples\config\tibemsd.conf" and use it to start a ems server .

server_heartbeat_client = 3

client_timeout_server_connection = 10
 
 2.  start my project "JMSMissingHeartbeat" in designer.
 start the processes SendMessages,GetMessages in the folder "/AlexJing_JMS_HeartbbeatMissing/AfterPhoneCall".
 
 3.  suspend ems server process by the tool "Process Explorer".
 
 4.  Error reproduced in designer console.

   I am attaching my project and designer console as well as the tool "Process Explorer".
)
;-------------------------------------------------------------------------------------
::runplay::
sendraw DisplayResult(RunAndGetOutput(tmp))
sendraw return
return
;-------------------------------------------------------------------------------------
/*
bw.plugin.security.strongcipher.minstrength=DISABLED_CIPHERS_BELOW_128
_BIT – would permit AES-128, 3DES, and AES-256 (but also - RC4/128 – NON-
COMPLIANT) 
bw.plugin.security.strongcipher.minstrength=DISABLED_CIPHERS_128BIT_AN
D_BELOW would permit 3DES and AES-256 (COMPLIANT, but missing AES-128) 
bw.plugin.security.strongcipher.minstrength=DISABLED_CIPHERS_BELOW_256
BIT – would permit only AES-256 (FUTURE-PROOF COMPLIANCE) 
*/
::paservers::
(
http://confluence.tibco.com/display/GS/9.+Creating+User-Provided-Service

a. TIBCO EMS Server 8.2.2
b. Spring Cloud Configuration Server
c. Microsoft SQL Server 2014 Express Edition
d. Oracle 11g R2 Enterprise Edition
e. MySQL Server 5.7.11 Community Edition
f. IBM DB2 10.5 Express Edition 
)
::/case::E:\EasyOSLink\PCMasterMove\Downloads\Compressed\722195\TestCase
::/mime::
(
<content-disposition>attachment;filename=BrokerageVoluntarySummaryCost.xls</content-disposition>

<content-type>application/msexcel</content-type>

<content-transfer-encoding>binary</content-transfer-encoding>
)
::/props::
(
    Please save below content to a file like f:\tibco\designer\5.9\properties.cfg and test in designer.
	 Select processes to test, before "Load Select",  click "Advanced" button and give "Test Engine User Args" value like "-p f:\tibco\designer\5.9\properties.cfg", that is the path you saved the "properties.cfg" file
)
::mqmore::
(

 

  1. From the "ldd" command, I could see below lib points to your "/opt/mqm/lib" :

 

  libmqmcs_r.so => /opt/mqm/lib/libmqmcs_r.so (0xf7d51000)

   While earlier, we only get below findings for the lib "libmqjbnd.so" :

   /apps/tibco/config/applications/mqm7.0.1.3/java/lib64/libmqjbnd.so

   /apps/tibco/config/applications/mqm7.0.1.3/java/lib/libmqjbnd.so

 

  Could you please confirm "/opt/mqm/java/lib/libmqjbnd.so" and "/opt/mqm/java/lib64/libmqjbnd.so" exist ?

  Also confirm if "/apps/tibco/config/applications/mqm7.0.1.3/" is a system link or you install/copy "MQ_HOM/java" folder there, since I see "/opt/mqm/java/lib" doesn't seem have the correct lib files.

 

  2. If above two ".so" files in above folder, please confirm below files exist(if not, search for the files "libmqz_r.so" and "libmqm_r.so" in your system):

  /opt/mqm/lib/libmqz_r.so

  /opt/mqm/lib64/libmqz_r.so

 /opt/mqm/lib/libmqm_r.so
 /opt/mqm/lib/compat/libmqm_r.so
 /opt/mqm/lib64/libmqm_r.so
 /opt/mqm/lib64/compat/libmqm_r.so


  3. As I could see below libs are missing from your ENV.

  

   libmqm_r.so => not found
   libmqz_r.so => not found

   

  I wonder if MQ has been correctly installed in your machine since I see those lib files in my "/opt/mqm/lib" and "/opt/mqm/lib64" folders like below.

  Please find out a folder where you have all "libmqjbnd.so","libmqz_r.so" and "libmqm_r.so".

  Then add the folder to

-------------------------------------------------------------------------------------

[root@inm1 opt]# pwd
/opt

[root@inm1 opt]# find . -name libmqjbnd.so
./mqm/java/lib/libmqjbnd.so
./mqm/java/lib64/libmqjbnd.so

[root@inm1 opt]# find . -name libmqm_r.so
./mqm/lib/libmqm_r.so
./mqm/lib/compat/libmqm_r.so
./mqm/lib64/libmqm_r.so
./mqm/lib64/compat/libmqm_r.so

[root@inm1 opt]# find . -name libmqz_r.so
./mqm/lib/libmqz_r.so
./mqm/lib64/libmqz_r.so

[root@inm1 opt]# find . -name libmqmcs_r.so
./mqm/lib/libmqmcs_r.so
./mqm/lib64/libmqmcs_r.so

-------------------------------------------------------------------------------------
  If any folder does, please change below line to a suitable value in application.tra and add the right folder to your system lib path(folder path like "/opt/mqm75/java/lib" if above three ".so" files found in such folder).


tibco.env.MQ_LIB=/opt/mqm75/

/opt/mqm/lib/libmqm_r.so
/opt/mqm/lib/compat/libmqm_r.so
/opt/mqm/lib64/libmqm_r.so
/opt/mqm/lib64/compat/libmqm_r.so
-------------------------------------------------------------------------------------
[root@inm1 opt]# pwd
/opt

[root@inm1 opt]# find . -name libmqjbnd.so
./mqm/java/lib/libmqjbnd.so
./mqm/java/lib64/libmqjbnd.so

[root@inm1 opt]# find . -name libmqm_r.so
./mqm/lib/libmqm_r.so
./mqm/lib/compat/libmqm_r.so
./mqm/lib64/libmqm_r.so
./mqm/lib64/compat/libmqm_r.so

[root@inm1 opt]# find . -name libmqz_r.so
./mqm/lib/libmqz_r.so
./mqm/lib64/libmqz_r.so

[root@inm1 opt]# find . -name libmqmcs_r.so
./mqm/lib/libmqmcs_r.so
./mqm/lib64/libmqmcs_r.so
)
;-------------------------------------------------------------------------------------
::/workmates::
(
Vincent
Jing
Robert
Mona
Oliver
Swat
Alvin
Parag
Jason
Steven
Clark
Sam
li_qinkai <li_qinkai@pactera.com>  ？

shengqi.shan 
艾明明

"Guo,Jingjing(BG1/BJ)" <jingjing.guo1@pactera.com>
"mai@tibco-support.com" <mai@tibco-support.com> 
"Chen,Min(BG1/BJ)" <min.chen6@pactera.com> 

郭晶晶
陈敏
李晨
)
/*
::/capstalk::
(
头上加一句 SetCapsLockState AlwaysOff
尾巴上加一句
^CapsLock::  ; control + capslock to toggle capslock.  alwaysoff/on so that the key does not blink
	GetKeyState t, CapsLock, T
	IfEqual t,D, SetCapslockState AlwaysOff
	Else SetCapslockState AlwaysOn
Return
然后就没了
【活跃】☆ez<coralsw@qq.com>  10:56:58
中间，如果想要，强烈建议一句caps作为esc
;将caps替换为esc
CapsLock::
)
*/
::/rent::
(
西二旗附近,回龙观新村,金域华府正北边小区,融泽嘉园一号院6号楼(正对着小区北门) 低价转租
由于朋友工作地点变动,需转租小区内整租下来的房子(大两局,二改三).
朝北次卧(大窗,视野好,面对华北电力大学) 1550元/月,15平米
朝北单间(大窗,视野好) 1300元/月,11平米.
水电费为小区标准,无其他费用. 租金支付方式灵活.
欢迎下班时间方便时看房
联系人: 伍先生.    电话 13041204920, 18519103730
)
;-------------------------------------------------------------------------------------
::/clob::jdbc:oracle:thin:@<host>:<port#>:<db_instancename>2oracle.jdbc.RetainV9LongBindBehavior=true
::list::listary
::syso::
sendinput System.out.println()
send {Left}
return
;------------------------------------------------------------------------------------- 
::goodhabits::Key/;:000[(ime_set:00000804-0)(Send_set:{;})(ime_set:00000804-1)(end_set:Enter)]
::goodhabit::Key/;:000[(ime_set:00000804-0)(Send_set:{;})(ime_set:00000804-1)(end_set:Enter-00000804-0-5)]
::runhabit::"F:\Program Files\AutoHotkey\AutoHotkeyU32.exe" G:\SRAll\AllMayDay\ToAttach\QQDown\Habit1625\Habit-1621-LiuMeng.ahk
::queuemon::"f:\tibco\ems\8.1\bin>tibemsmonitor -server tcp://localhost:7222 -m $sys.monitor.Q.*.sample" 
::zjk::人找车,下午3点半以后从;西二旗附近软件园二期文思海辉大厦走,回张家口桥东燕兴机械厂.一人 18519103730
::/now::人找车,现在从融泽嘉园一号院走,回张家口桥东燕兴机械厂.一人 18519103730, 13041204920
::zjkhome::人找车，今天下午4点以后从融泽嘉园一号院出发到张家口桥东区燕兴社区，一个人，13041204920

;-------------------------------------------------------------------------------------
::bwservers::
(
192.168.68.105 tibco/tibco  BW622("I:\bw622\studio\3.6\eclipse\TIBCOBusinessStudio.exe") 

192.168.68.105 tibco/tibco  BW5.11("G:\tibco\designer\5.8\bin\designer.exe")

192.168.72.233 tibco/tibco  BW622("C:\BW6.2.2\studio\3.6\eclipse") ﻿BW5.11,MQ7.4,Adapter For MQ 6.2
)
;-------------------------------------------------------------------------------------
::log4jemail::
(
Dear customer,

  We have the ERs as below :


   BW-16543 { Support <Bank of America Securities LLC>-Date format in BW Logs should be taken based on log4j.xml / log4j.properties file }

  BW-16533 { Support <Bank of America Securities LLC>-Change the date format in BW logs from "GMT +8"(or "GMT +0800") to "CST". }

  Below is a post of the comments:

-------------------------------------------------------------------------------------

  As confirmed by L3, loggers like BW-Core,BW-User have their coded Pattern for log.

 
  We could only change the format of other loggers like self defined “bw.logger” in java code or after enable "ws.security" logger,etc. That means we could only control the log lines which are not printed by default but printed after enabling more trace.

 To do this, change the "ConversionPattern" of the appenders "tibco_bw_log","tibco_bw_console" or "tibco_bw_log_console" in log4j.xml(log4j.properties is used if xml file is absent).


 You could see that "CST" is showing up.

-------------------------------------------------------------------------------------


$formula($global.my_email_signature)


PS: Please click here to login to TSC and update the SR. 
)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
::emsclass::
(
Dear customer,

    Thanks for contacting TIBCO Support.


    The issue is here because the EMS client library is not shipped with TRA any more in TRA 5.10 any more so you should add a line like below in the designer.tra:


  tibco.env.EMS_HOME F:/tibco/ems/8.1

    Then append ";%EMS_HOME%/lib" to "tibco.class.path.extended" in designer.tra or bwengine.tra


    Once appended in bwengibwengine.tra in the BW server, all applications deployed later would get the line in their applicatapplication.tra files .


    This would ensure designer/bwengine/application able to know EMS lib location once it is restarted.


    You could also copy the jars in the EMS lib folder,i.e,"tibjms.jar", to a separate folder and give that folder to "tibco.class.path.extended" in tra files. This is what you have used as a temp workaround.

   

    Creating a EMS related variable and use it to point to its lib(where all jars locate) is the suggested solution.

 

    Kindly let me know yourr news.


 Regards & Thanks,
 Robert Wu
 TIBCO Support
)
-------------------------------------------------------------------------------------
::emstimeout::
(
In one word, the issue happens when you set below properties to a low values and your EMS client happens to hang or unable to send heartbeat to EMS server for the time value used by "server_timeout_client_connection", then the session is closed due to time out :
  
   client_heartbeat_server=3
    server_timeout_client_connection=10
   
    Since client Ack used, your client fails to confirm the message and then the message redelivered as an expected behavior.
   
    As long as your client not hanging or failing to send heartbeat to EMS server within the time value used by "server_timeout_client_connection", you would not see the issue happen any more.
)
-------------------------------------------------------------------------------------