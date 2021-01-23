/*
	Script allows the keyboard to be used as a mouse. 
	Arrows move the mouse
	LAlt or AppsKey right mouse button
	Win middle mouse button
	
	Also, LAlt has the same functionality with holding the button to get the middle button like Basic
	
	CapsLock suspends the script
	
	RAlt & m closes the script and starts Basic

*/


; skips the dialog box and replaces the old instance automatically
#SingleInstance force

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
	
	

AppsKey::
	GetKeyState, already_down_state, RButton
	If already_down_state = D
		return
	send {RButton down}
return

AppsKey Up::
	send {RButton up}
return

LWin::
	GetKeyState, already_down_state, LButton
	If already_down_state = D
		return
	send {LButton down}
return

LWin Up::
	send {LButton up}
return


trig:=0
LAlt::
	SetTimer, MiddleBtn, -500
return


MiddleBtn:
	trig:=1
	send, {MButton}
return

LAlt Up::
	if !trig
	{
		SetTimer, MiddleBtn, Delete
		send, {RButton}
	}
	else
	{
		trig:=0
	}
return
	

Up::
	gosub Move
return

Left::
	gosub Move
return

Right::
	gosub Move
return

Down::
	gosub Move
return


Move:
	MouseRate:=3
	MouseAcc:=2
	MaxMouseSpeed:=25
	Speed:=100
	
	Loop
	{	
		if (MouseRate<MaxMouseSpeed) 
		{
			MouseRate:=MouseAcc+MouseRate
		}
		moved=0
		X := Y := 0
		GetKeyState, left_state, Left, P
		GetKeyState, right_state, Right, P
		GetKeyState, up_state, Up, P
		GetKeyState, down_state, Down, P
		if left_state = D
		{
			X := X-MouseRate
			moved:=1
		}
		if right_state = D
		{
			X := X+MouseRate	
			moved:=1
		}
		if down_state = D
		{
			Y := Y+MouseRate	
			moved:=1
		}
		if up_state = D
		{
			Y := Y-MouseRate	
			moved:=1
		}
		if moved
			MouseMove, X, Y, Speed,R
		else
			Return
		sleep, 30
	}
return

CapsLock::
	Suspend, Toggle
return

RAlt & m::
	Run, %A_ScriptDir%\Basic.exe
	ExitApp
return
