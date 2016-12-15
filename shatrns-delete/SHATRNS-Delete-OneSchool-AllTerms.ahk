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
	send, {Ctrl down}{PgDn}{PgDn}{Ctrl up}+{F6}{F10}+{F7}{Tab}{Tab}
	oldClip := Clipboardall
	Loop {
		Clipboard := ""
		send, ^c
		ClipWait
		clip := Clipboard ;, clip += 0
		if (clip is integer && clip = 1 || !(clip is integer)) {
			break
		}
		else if (clip is integer && clip > 1) {
			clip -= 1
			send, %clip%{Ctrl down}{PgDn}{PgDn}{Ctrl up}+{F6}{F10}+{F7}{Tab}{Tab}
		}
	}
	send, ^{PgDn}+{F6}{Enter}
	Sleep, 500
	send, {Enter}
	Sleep, 250
	send, +{F7}{Tab}
	Clipboard := ""
	send, ^c
	ClipWait
	clip := Clipboard
	if (clip is integer && clip = 1 || !(clip is integer)) {
		send, ^q
	}
	else if (clip is integer && clip > 1) {
		clip -= 1
		send, %clip%
	}
	Clipboard := ""
	Clipboard := oldClip
Return