#$language = "VBScript"
#$interface = "1.0"

crt.Screen.Synchronous = True

' This automatically generated script may need to be
' edited in order to work correctly.

' YYYYMMDD
function getDateStr()
	getDateStr=CStr( Year(Date)) & Right("0" & Month(Date), 2) & Right("0" & Day(Date), 2)
end function

Sub Main
	crt.Screen.Send("reboot")
	crt.Screen.WaitForString("uboot")
	crt.Screen.Send("uboot")
	crt.Screen.Send("run bcmode" & chr(13))
	crt.Sleep 10000
	crt.Screen.Send chr(13)
	crt.Screen.WaitForString("/ #", 1)
	crt.Screen.Send chr(13)
	crt.Screen.WaitForString("/ #", 1)
	crt.Screen.Send chr(13)
	crt.Screen.WaitForString("/ #", 1)
	crt.Screen.Send("mkdir /mnt/flashdisk; mount -t jffs2 -o ro,noatime /dev/mtdblock1 /mnt/flashdisk" & chr(13))
	crt.Screen.WaitForString("/ #")
	crt.Screen.Send("cd /mnt/flashdisk" & chr(13))
	crt.Screen.Send("./bcm.init" & chr(13))
	crt.Screen.WaitForString("bcm.init COMPLD")
	crt.Screen.Send("./ed_ip 172.29.132.210 255.255.255.0 LCI 172.29.132.1" & chr(13))
	crt.Screen.WaitForString("ed_ip COMPLD")
	crt.Screen.Send("./copy_rfile_ext4 172.29.22.244 21 groove coriant /home/groove/XTM2 G30_GROOVE_1.0.1_" & getDateStr() & chr(13))
	crt.Screen.WaitForString("copy_rfile COMPLD")
	crt.Screen.Send("./install_sw; sync; ./init_sys" & chr(13))
End Sub