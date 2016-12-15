;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Copyright 2016 Matthew Bullock
;
; RollToHistory is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; RollToHistory is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY or any implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

^+1::
	SetTitleMatchMode, RegEx
	; Match the window title(s) with RegExp
	send, {AltDown}{AltUp}oed
	KeyWait, F10, D T3
	Sleep, 500
	send, {F5}spacmnt{Enter}^{Pgdn}
	KeyWait, a, D T60
	KeyWait, e, D T60
	send, {Tab}
	KeyWait, a, D T60
	KeyWait, e, D T60
	send, {Tab}{Tab}{Tab}{Tab}{Tab}^+{Right}
Return

^+2::
	send, {F5}sgastdn{Enter}{Tab}{Delete}{CtrlDown}{Pgdn}{Pgdn}{Pgdn}{Pgdn}{Tab}
	KeyWait, F10, D T7
	send, ^q^q{F5}
Return
