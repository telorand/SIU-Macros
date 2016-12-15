;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Copyright 2016 Matthew Bullock
;
; SHATRNS-Delete is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; SHATRNS-Delete is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY or any implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

+Delete::
	; Initial deletion
	send, {Ctrl down}{PgDn}{PgDn}{Ctrl up}+{F6}{F10}+{F7}{Tab}{Tab}
	oldClip := Clipboardall
	Clipboard := ""
	send, ^c ; Get the current term number
	ClipWait
	clip := Clipboard
	if (clip is integer && clip = 1) { ; If the term we just deleted is 1
		send, ^{PgDn}+{F6}{Enter} ; Delete the school
		Sleep, 500
		send, {Enter}
		Sleep, 250
		send, +{F7}{Tab}
		Clipboard := ""
		send, ^c ; Get the school number
		ClipWait
		clip := Clipboard
		if (clip is integer && clip = 1) { ; If the school number is 1
			send, ^q ; Exit SHATRNS
		}
		else if (clip is integer && clip > 1){ ; If the school number is > 1
			clip -= 1 ; Decrement the school number by 1
			send, %clip%
		}
	}
	else if (clip is integer && clip > 1) { ; If the term we deleted is > 1
		clip -= 1 ; Decrement the term by 1
		send, %clip%
	}
	Clipboard := ""
	Clipboard := oldClip
Return