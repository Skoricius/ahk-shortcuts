/*
	Script containing commands for the pen buttons on surface pro 4
*/

; skips the dialog box and replaces the old instance automatically
#SingleInstance force

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#F20:: 
	{
		SetTitleMatchMode, 2 ; approximate match
		IfWinExist, - OneNote
		{
			WinActivate, - OneNote
		}
		IfWinNotExist, - OneNote
		{
			run, "C:\Program Files\Microsoft Office\Office16\ONENOTE.EXE"
		}
		return
	}
#F19::

{
    send, {LWin down}{Shift down}{s}
    Sleep, 500
    send, {Shift up}{LWin up}
    Sleep, 500
    return
}

#F18::
    {   
        run, "C:\Users\ls604\Desktop\Scripts\DrawboardPDF.url"
        Return
    }












































