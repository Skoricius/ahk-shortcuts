
/*
	Script covering the basic commands I want to have on every computer running all the time. It includes:
	
		makes NumLock always on and CapsLock always off
		
		RAlt+t makes the current window always on top and transparent
		
		RAlt+l changes the audio output
		
		Maps RAlt & Left/Right to LAlt & Left/Right (for convenience in browsers)
		
		Maps AppsKey & Left/Right to Home/End (mainly for convenience on some keyboards)
		
		Maps AppsKey & Up/Down to Pgup/Pgdn (again, for convenience on some keyboards)
		
		Maps LAlt & X to LAlt & F4 (closing a program)

		Shift + Wheel for horizontal scrolling
		
		Runs KeyboardMouse on RAlt & M

		Changes windows color mode and background on RAlt & C (from switching to dark mode during the night)

		RAlt+k kill all AHK scripts

		Some useful macros for special symbols
*/
; dark_wallpaper := "C:\Users\lukas\Pictures\Backgrounds\medvednica_forest.jpg"
dark_wallpaper := "C:\Users\lukas\Pictures\Backgrounds\Earth_from_space.jpg"
light_wallpaper := "C:\Users\lukas\Pictures\Backgrounds\Windows_wallpaper.jpg"

; skips the dialog box and replaces the old instance automatically
#SingleInstance force
#Persistent
; WinSet, Transparent, 255, ahk_class Shell_TrayWnd

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#include VA.ahk

; Default state of lock keys
SetNumlockState, AlwaysOn
SetCapsLockState, AlwaysOff

; a set of text conversions, delay is for dealing with issues with some programs (https://github.com/yzhang-gh/vscode-markdown/issues/200)
:*:;->::{Sleep 100}→
:*:;<->::{Sleep 100}↔ 
:*:;=>::{Sleep 100}⇒
:*:;<=>::{Sleep 100}⇔
:*:+-::{Sleep 100}±
:*::cross::{Sleep 100}❌
:*:;cross::{Sleep 100}❌
:*::check::{Sleep 100}✔
:*:;check::{Sleep 100}✔
:*:;deg::{Sleep 100}°
:*::deg::{Sleep 100}°
:*:;otl::--one-top-level
:*:===::===================={Enter}
:*:___::____________________


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
	; run, taskkill /f /im zoom.exe
	send {LAlt down}{F4}{LAlt up}
return

; remap caps lock to ctrl and shit+caps to CapsLock
CapsLock::LCtrl
Shift & CapsLock::CapsLock

; Shift + Wheel for horizontal scrolling
+WheelDown::WheelRight
+WheelUp::WheelLeft

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

; Opens the terminal app
^!t::
    Run, "C:\Shortcuts\Terminal"
return

^#b::
	Run, bthprops.cpl
return
     

::startpython::
Send,
(
import os
import sys
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns; sns.set()
)

; kill all A/*HK scripts
RAlt & k::
{
	DetectHiddenWindows, On 
	WinGet, List, List, ahk_class AutoHotkey 


	Loop %List% 
	  { 
		WinGet, PID, PID, % "ahk_id " List%A_Index% 
		If ( PID <> DllCall("GetCurrentProcessId") ) 
			 PostMessage,0x111,65405,0,, % "ahk_id " List%A_Index% 
	  }
	
	ExitApp
}

; Change the mode from light to dark and change the wallpaper
RAlt & c::
{
	; read the System lightmode from the registry 
	RegRead,L_LightMode,HKCU,SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize,SystemUsesLightTheme
	If L_LightMode {                                  ; if the mode was Light
		; write both system end App lightmode to the registry
		RegWrite,Reg_Dword,HKCU,SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize,SystemUsesLightTheme,0
		RegWrite,Reg_Dword,HKCU,SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize,AppsUseLightTheme   ,0
		SetWallpaper(dark_wallpaper)
		}
	else {                                            ; if the mode was dark
		; write both system end App lightmode to the registry
		RegWrite,Reg_Dword,HKCU,SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize,SystemUsesLightTheme,1
		RegWrite,Reg_Dword,HKCU,SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize,AppsUseLightTheme   ,1
		SetWallpaper(light_wallpaper)
		}
	; tell the system it needs to refresh the user settings
	run,RUNDLL32.EXE USER32.DLL`, UpdatePerUserSystemParameters `,2 `,True
} 

; Sets the wallpaper to a selected file of your choosing.
SetWallpaper(WallpaperFile) {
	DllCall("SystemParametersInfo", "Uint", 20, "Uint", 0, "Str", WallpaperFile, "Uint", 2)
}


; ; runs the KeyboardMouse script
; RAlt & m::
; 	Run, %A_ScriptDir%\KeyboardMouse.exe
; 	ExitApp
; return


