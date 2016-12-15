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
SetTitleMatchMode, RegEx
SetTitleMatchMode, Fast

+Delete::
	oldClip := Clipboardall
	ControlSend,, +{F7}{Tab}, .*(SHATAEQ)
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
			
			ControlSend,, ^q, .*(- SHATRNS)
			ControlSend,, ^q, .*(- SHQTRIT)
			Sleep, 250
			ControlSend,, +{Tab}, .*(SHATAEQ)
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
		ControlSend,, {F5}shatrns{Enter}, .*(SHATAEQ)
		ControlSend,, {Tab}, .*(- SHATRNS)
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
				ControlSend,, {Tab 2}, .*(- SHATRNS) ; Exited Attendance Period Number
				
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
		ControlSend,, %termIndex%{Ctrl down}{PgDn 2}{Ctrl up}+{F6}{F10}+{F7}{Tab 2}, .*(- SHATRNS)
	}
	deleteSingleSchool(){
		ControlSend,, ^{PgDn}+{F6}, .*(- SHATRNS)
		Sleep, 500
		
		ControlSend,, {Enter}, .*(- SHATRNS)
		Sleep, 500
		
		ControlSend,, {Enter}, .*(- SHATRNS)
		Sleep, 250
		
		ControlSend,, +{F7}, .*(- SHATRNS)
		Sleep, 250
		ControlSend,, {Tab}, .*(- SHATRNS)
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
					ControlSend,, {Up}, .*(SHATAEQ - (SHQTRIT))\s(\[Q\])?
				}
				schoolIndex -= 1
				selectHighlighted() ; Select last school
				ControlSend,, {AltDown}{AltUp}oed{F10}, .*(SHATAEQ) ; Unroll from history
				Sleep, 500
				ControlSend,, {Enter}, .*(SHATAEQ)
				Sleep, 1500
				deleteSchoolTerms(deleteTries) ; Recursively deletes work
				ControlSend,, +{F7}{Tab}{F9}, .*(SHATAEQ) ; If deletion successful
				ControlSend,, {PgDn 5}, .*(SHATAEQ - (SHQTRIT))\s(\[Q\])?
			}
		}
	}
	deleteSchoolTerms(deleteTries){ ; Deletes work from SHATAEQ
		ControlSend,, +{F7}^{PgDn}, .*(SHATAEQ)
		Sleep, 1750
		deleteTries += 1
		
		ControlSend,, {Shift down}, .*(SHATAEQ)
		Loop 50 {
			ControlSend,, {F6}, .*(SHATAEQ)
			Sleep, 50
		}
		ControlSend,, {Shift Up}{F10}, .*(SHATAEQ)
		Sleep, 250
		MsgBox, 4,, Has all work been deleted?
		if (deleteTries < 4) {
			IfMsgBox No ; If there's more work to delete
				deleteSchoolTerms(deleteTries) ; Recursive call
		}
		else { ; If we've failed to delete all the work after 4 tries
			MsgBox, 0,, Term deletion failed!
			IfMsgBox OK
				Exit
		}
	}
	getLastSchoolOrTerm(){
		ControlSend,, {F9}, .*(SHATAEQ|- SHATRNS)
		ControlSend,, {Pgdn 5}, .*(- SHQTRIT|- SHQTRAM)\s(\[Q\])? ; Highlight last school
		copyCurrentField()
		Sleep, 250
	}
	copyCurrentField(){
		Clipboard := ""
		Send,, ^c
		ClipWait, 1
		if ErrorLevel {
			copyError()
		}
	}
	selectHighlighted(){
		ControlSend,, {AltDown}{AltUp}f, .*(- SHQTRIT|- SHQTRAM)\s(\[Q\])?
		Sleep, 50
		ControlSend,, e, .*(- SHQTRIT|- SHQTRAM)\s(\[Q\])? ; Select
		Sleep, 100
	}
	copyError() {
		MsgBox, No schools or terms. Exiting.
		IfWinExist, .*(- SHATRNS - (SHQTRIT|SHQTRAM))\s(\[Q\])?
			copyErrorA()
		IfWinExist, .*(SHATAEQ - (SHQTRIT))\s(\[Q\])?
			ControlSend,, ^q+{Tab}, .*(- SHQTRIT)\s(\[Q\])?
		Exit
	}
	copyErrorA() {
		ControlSend,, ^q+{Tab}, .*(- SHQTRIT|- SHQTRAM)\s(\[Q\])?
		ControlSend,, ^q, .*(- SHATRNS)
		ControlSend,, +{Tab}, .*(SHATAEQ)
	}
Return