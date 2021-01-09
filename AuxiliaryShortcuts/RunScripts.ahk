/*
	This Script just calls all the other scripts and has explanations to what they do
*/


; skips the dialog box and replaces the old instance automatically
#SingleInstance force

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; basic path to the folder with scripts
path=%A_ScriptDir%


/*
	Script which defines loads of functions for audio control which I will be using in some of the other scripts
*/

; Run, %path%VA
; #include VA.ahk


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
; Run, %path%Basic.ahk
#include Basic.ahk

/*
	Script containing commands for the pen buttons on surface pro 4
*/
; Run, %path%PenButtons.ahk
#include PenButtons.ahk

/*
	Script doesn't allow computer to go to sleep by moving the mouse one pixel at left-right. However, if Win+Esc is pressed, it automatically closes the script and puts computer to hibernate.
*/
Run, %path%NoSleep.ahk
; #include NoSleep.ahk


/*
	Script allows the keyboard to be used as a mouse. 
	Arrows move the mouse
	LAlt or AppsKey right mouse button
	Win middle mouse button
	
	Also, LAlt has the same functionality with holding the button to get the middle button like Basic
	
	CapsLock suspends the script
	
	RAlt & m closes the script and starts Basic

*/
Run, %path%NoSleep.ahk

