/*
	Script doesn't allow computer to go to sleep by moving the mouse one pixel at left-right. However, if Win+Esc is pressed, it automatically closes the script and puts computer to hibernate.
	
	Also, RAlt & Esc shuts the computer down
*/
; skips the dialog box and replaces the old instance automatically
#SingleInstance force

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


#Persistent

CoordMode, Mouse, Screen

MouseGetPos, CurrentX, CurrentY
	
; Register a function to be called on exit:
OnExit("ExitFunc")

Loop {
    Sleep, 60000
    LastX := CurrentX
    LastY := CurrentY
    MouseGetPos, CurrentX, CurrentY
    If (CurrentX = LastX and CurrentY = LastY) {
        MouseMove, 2, 2, , R
        Sleep, 100
        MouseMove, -2, -2, , R
    }
}


; A function which is going to be executed if the app was terminated by ExitApp
ExitFunc(ExitReason, ExitCode)
{
	if ExitReason in Exit
	{
		DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
	}
}


RAlt & Esc::
	Shutdown, 1
return

#Esc::
	{
		ExitApp
	}
