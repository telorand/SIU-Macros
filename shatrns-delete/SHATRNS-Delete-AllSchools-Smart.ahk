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
SetKeyDelay, 100

+Delete::
	oldClip := Clipboardall
	send, +{F7}{Tab}
	Sleep, 250
	MsgBox, 3,, Start deletion?, 30
	IfMsgBox, No
		Return
	IfMsgBox, Cancel
		Return
	IfMsgBox, Timeout
		Return
	else {
		try {
			deleteAllSchoolwork()
			Sleep, 500
			deleteSHATRNS()
			
			send, ^q^q
			Sleep, 250
			send, +{Tab}
		}
		catch e {
			MsgBox, An error was encountered. Exiting.
			Exit
		}
		finally {
			Clipboard := ""
			Clipboard := oldClip
		}
	}
	
	deleteSHATRNS() {
		send, {F5}shatrns{Enter}{Tab}
		Sleep, 500
		getLastSchoolOrTerm() ; Inside Transfer Institution Number
		maxSchools := Clipboard
		schoolIndex := Clipboard
		
		Loop %maxSchools% {
				selectHighlighted() ; Select highlighted school. Exited Transfer Institution Number
				getLastSchoolOrTerm() ; Inside Attendance Period Number
				maxTerms := Clipboard
				termIndex := Clipboard
				selectHighlighted() ; Select highlighted term. Exited Attendance Period Number
				send, {Tab 2} ; Exited Attendance Period Number
				
				Loop %maxTerms% {
					Sleep, 500
					deleteSingleTerm(termIndex)
					termIndex -= 1
				}
				deleteSingleSchool()
				; Sleep, 250
				if (schoolIndex > 1) {
					; MsgBox, About to getLastSchoolOrTerm
					getLastSchoolOrTerm() ; Inside Transfer Institution Number
				}
				schoolIndex -= 1
		}
	}

	deleteSingleTerm(termIndex){
		send, %termIndex%{Ctrl down}{PgDn 2}{Ctrl up}+{F6}{F10}+{F7}{Tab 2}
	}
	deleteSingleSchool(){
		send, ^{PgDn}+{F6}
		Sleep, 500
		
		send, {Enter}
		Sleep, 500
		
		send, {Enter}
		Sleep, 250
		
		send, +{F7}
		Sleep, 250
		send, {Tab}
	}
	
	deleteAllSchoolwork(){
		Sleep, 500
		getLastSchoolOrTerm()
		maxSchools := Clipboard
		schoolIndex := Clipboard ; Important for ups calculation
		deleteTries := 0

		Loop {
			if (schoolIndex is integer && schoolIndex < 1 || !(schoolIndex is integer)) {
				break
			}
			else if (schoolIndex is integer && schoolIndex >= 1) {
				ups := maxSchools - schoolIndex
				Loop %ups% {
					send, {Up}
				}
				schoolIndex -= 1
				selectHighlighted() ; Select last school
				send, {AltDown}{AltUp}oed{F10} ; Unroll from history
				Sleep, 500
				send, {Enter}
				Sleep, 1500
				deleteSchoolTerms(deleteTries) ; Recursively deletes work
				send, +{F7}{Tab}{F9}{PgDn 5} ; If deletion successful
			}
		}
	}
	deleteSchoolTerms(deleteTries){ ; Deletes work from SHATAEQ
		send, +{F7}^{PgDn}
		Sleep, 1750
		deleteTries += 1
		
		send, {Shift down}
		Loop 50 {
			send, {F6}
			Sleep, 50
		}
		send, {Shift Up}{F10}
		Sleep, 250
		MsgBox, 4,, Has all work been deleted?
		if (deleteTries < 4) {
			IfMsgBox No ; If there's more work to delete
				deleteSchoolTerms(deleteTries) ; Recursive call
		}
		else { ; If we've failed to delete all the work after 4 tries
			MsgBox, 0,, Term deletion failed!
			IfMsgBox OK
				ExitApp
		}
	}
	getLastSchoolOrTerm(){
		send, {F9}{Pgdn 5} ; Highlight last school
		copyCurrentField()
		Sleep, 250
	}
	copyCurrentField(){
		Clipboard := ""
		send, ^c
		ClipWait, 1
		if ErrorLevel {
			copyError()
		}
	}
	selectHighlighted(){
		send, {AltDown}{AltUp}f
		Sleep, 50
		send, e ; Select
		Sleep, 100
	}
	copyError(){
		MsgBox, No schools or terms. Exiting.
		send, {AltDown}{AltUp}fm
		Sleep, 100
		send, shataeq{Enter}
		Exit
	}
Return