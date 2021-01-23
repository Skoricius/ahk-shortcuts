
/*
	Script covering the basic commands I want to have on every computer running all the time. It includes:
	
		makes NumLock always on and CapsLock always off
		
		Makes the taskbar transparent just for fun
		
		Holding the right mouse button activates the middle button
		
		RAlt+t makes the current window always on top and transparent
		
		RAlt+h changes the audio output
		
		Maps RAlt & Left/Right to LAlt & Left/Right (for convenience in browsers)
		
		Maps AppsKey & Left/Right to Home/End (mainly for convenience on some keyboards)
		
		Maps AppsKey & Up/Down to Pgup/Pgdn (again, for convenience on some keyboards)
		
		Maps LAlt & X to LAlt & F4 (closing a program)
		
		Runs NoSleep on RAlt & N
		
		Runs KeyboardMouse on RAlt & M
*/

; skips the dialog box and replaces the old instance automatically
#SingleInstance force
#Persistent

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#include VA.ahk


+#^F22::mouseclick, middle

WinSet, Transparent, 150, ahk_class Shell_TrayWnd

; Default state of lock keys
SetNumlockState, AlwaysOn
SetCapsLockState, AlwaysOff


; Alt+t makes the window transparent and always on top
RAlt & t::
{
	WinGet, currentWindow, id, A
	WinGet, ExStyle, ExStyle, ahk_id %currentWindow%
	if (ExStyle & 0x8) ; 0x8 is WS_EX_TOPMOST.
	{
		WinSet, AlwaysOnTop, Toggle, ahk_id %currentWindow%
		WinSet, Transparent, 255, ahk_id %currentWindow%
		WinSet, Transparent, off, ahk_id %currentWindow%
	}
	else
	{
		WinSet, AlwaysOnTop, Toggle, ahk_id %currentWindow%
		WinSet, Transparent, 150, ahk_id %currentWindow%
	}
	return
}


RAlt & Left::
	send {LAlt down}{Left}{LAlt up}
return

RAlt & Right::
	send {LAlt down}{Right}{LAlt up}
return

AppsKey & Up::
	send {PgUp}
return


AppsKey & Down::
	send {PgDn}
return

AppsKey & Left::
	send {Home}
return

AppsKey & Right::
	send {End}
return

LAlt & x::
	send {LAlt down}{F4}{LAlt up}
return

; Changes the audio output
RAlt & l::
{

	i:=0
	device%i%:=VA_GetDevice("playback")
	device_name%i%:=VA_GetDeviceName(device%i%)

	Loop {
		i+=1
		str := % "playback:" . i
		device%i%:=VA_GetDevice(str)
		if device%i% in 0
			break
		device_name%i%:=VA_GetDeviceName(device%i%)
	}
	numOfOutputs:=i-1
	j:=1
	while j<100
	{
		if device_name%j% in %device_name0% 
		{
			break
		} 
		else
		{
			j+=1
		}
	}
	next:=j+1
	if (next > numOfOutputs )
	{
		next:=1
	} 
	
	VA_SetDefaultEndpoint(device%next%, 0)
	VA_SetDefaultEndpoint(device%next%, 1)
	VA_SetDefaultEndpoint(device%next%, 2)

	Menu Tray, NoIcon  ; kills previously existing traytips
	Menu Tray, Icon
	TrayTip, Playback device: ,% device_name%next%, 1,16
return
}


RAlt & m::
	Run, %A_ScriptDir%\KeyboardMouse.exe
	ExitApp
return


; Opens the bash terminal
^!t::
    Run, Ubuntu
return

    

	
