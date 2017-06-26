#$language = "VBScript"
#$interface = "1.0"

crt.Screen.Synchronous = True

' This automatically generated script may need to be
' edited in order to work correctly.

const node = "172.29.132.210"
const load_server = "172.29.22.244"
const user = "zzhang2"
const groove_root_pwd = "e2e!Net4u#"

function get_date()
	get_date=CStr( Year(Date)) & Right("0" & Month(Date), 2) & Right("0" & Day(Date), 2) ' YYYYMMDD
end function

function sendl(x)
	'crt.Screen.Send(x & chr(13))
	crt.Screen.Send(x & vbCR)
end function

sub confirm_ssh()
	if crt.Screen.WaitForString("(yes/no)?", 10) then
		sendl("yes")
	end if
end sub

function get_shell_return(input)
	sendl(input)
	crt.Screen.WaitForString("dci-dev2")
	screenrow = crt.screen.CurrentRow - 1
	get_shell_return = split(crt.Screen.Get(screenrow, 1, screenrow, 40 )," ")(0)
end function

sub change_load()
	sendl("ssh administrator@" & node) 'ssh administrator@172.29.132.210
	confirm_ssh()
	crt.Screen.WaitForString("password")
	sendl(groove_root_pwd)
	crt.Screen.WaitForString("administrator") 'administrator@G30_04:c0:9c:b1:42:f3>
	crt.Screen.Send "download swimage sftp://groove@" & load_server & "/XTM2/G30_GROOVE_1.0.1_" & get_date() & chr(13)
	crt.Screen.WaitForString "PASSWORD"
	crt.Screen.Send "coriant"& chr(13)
	crt.Screen.WaitForString "Download Completed"
	crt.Screen.Send "activate swimage -f" & chr(13)
end sub

function make_load()
	'confirm path of the repo
	MsgBox "making load for " & get_shell_return("echo $REPO_CORIANTOS") & " & " & get_shell_return("echo $REPO_CORIANTPF")
	
	'start making load
	'crt.Screen.Send "groove;mk -j 16;mk load" & chr(13)
	make_result = get_shell_return("echo $?")
	if make_result <> 0 then
		MsgBox "make load failed"
		make_load = -1
		exit function
	end if
	'crt.Screen.WaitForString "Compilation took"
	sendl("rm /home/" & user & "/.ssh/known_hosts") 'rm /home/zzhang2/.ssh/known_hosts
	crt.Screen.Send "scp build_target/G30_GROOVE_1.0.1_" & get_date() &".* groove@" & load_server & ":~/XTM2" & chr(13)
	confirm_ssh()
	crt.Screen.WaitForString "password"
	crt.Screen.Send "coriant" & chr(13)
	make_load = 0
end function

Sub Main
	if make_load() <> 0 then
		exit sub
	end if
	
	change_load()
End Sub

