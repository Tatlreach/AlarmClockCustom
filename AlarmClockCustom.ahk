;AlarmClock.ahk
; Enter a time and a message to set an alarm
;Skrommel @ 2017

#NoEnv
#SingleInstance,Off

applicationname=AlarmClock
BeepCount:=-2

global hour := -1
global minute := -1
global message

global hournum := 0
global minutenum := 0
global messagenum

global customDelay := 0
global customDelaySet := 0
global oldFocus
global 0, 1, 2, 3, 4


Goto, ProcessParameters

MENU:
Menu,Tray,NoStandard
Menu,Tray,Add,%applicationname%,SHOW
Menu,Tray,Add,&About...,ABOUT
Menu,Tray,Add,&Exit,EXIT
Menu,Tray,Default,%applicationname%
Menu,Tray,Click,1
Menu,Tray,Tip,%applicationname%


AMPM:
use24=0
RegRead,timeformat,HKEY_USERS,.DEFAULT\Control Panel\International,sTimeFormat
IfInString,timeformat,HH
  use24=1

If (use24=0)
{
  Loop,12
    hours:=hours SubStr("0" A_Index,-1,2) " am|"
  Loop,12
    hours:=hours SubStr("0" A_Index,-1,2) " pm|"
}
Else
{
  Loop,24
    hours:=hours SubStr("0" A_Index-1,-1,2) "|"
}
Loop,60
  minutes:=minutes SubStr("0" A_Index-1,-1,2) "|"
 
hourcount := "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23"
minutecount := "0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59"

GUI:
Gui,Add,ComboBox,XM W60 Vhournum,% hourcount
Gui,Add,ComboBox,X+5 W40 Vminutenum,% minutecount
Gui,Add,Edit,X+5 W150 Vmessagenum,Duration Alarm Description

Gui,Add,Button,X+5 GSTART,&Start
Gui,Add,Button,X+5 GSETBEEPS,&JustBeep
Gui,Add,Button,X+5 GEXITBUTTON,&Cancel

Gui,Add,ComboBox,XM Y+M W60 Vhour,% hours
Gui,Add,ComboBox,X+5 W40 Vminute,% minutes
Gui,Add,Edit,X+5 W150 Vmessage,Time Alarm Description

Gui,Add,Button,X+5 GSTART,&Start
Gui,Add,Button,X+5 GSETBEEPS,&JustBeep
Gui,Add,Button,X+5 GEXITBUTTON,&Cancel

Gui,Show,,%applicationname%


#IfWinActive AlarmClock
{
	$Esc::
	!$F4::
		ExitApp
		return

	^$Tab::
	^Up::
	^Down::
	`::
		Send {Tab}
		Send {Tab}
		Send {Tab}
		Send {Tab}
		Send {Tab}
		Send {Tab}

	;	GuiControlGet, oldFocus, FocusV
	;	if(oldFocus == hournum){
	;		GuiControl, Focus, hour
	;	}
		return

	Return
}

SHOW:
Gui,SHOW
Return

EXITBUTTON:
ExitApp
return

CONFIRMFINISHED:
	Gui, Destroy
	hournum := 0
	minutenum := 0
	customDelaySet := 0
	gui, add, text, ,%message%
	
	Gui,Add,Button,Default Y+M W316 GEXITBUTTON,&ACKNOWLEDGE
	
	gui, add, text, Y+2M ,   
	
	;A_GuiWidth-2M
	
	gui, add, text, XM Y+2M ,Custom Delay:
	gui, add, ComboBox, X+5 W80 VcustomDelay,	;CHANGES customDelay to string
	gui, add, button,X+5 W157 GCUSTOMSUBMIT, &Submit
	
	Gui,Add,Button,XM Y+M GDelay5,&Delay5
	Gui,Add,Button,X+5 GDelay10,&Delay10
	Gui,Add,Button,X+5 GDelay15,&Delay15
	Gui,Add,Button,X+5 GDelay20,&Delay20
	Gui,Add,Button,X+5 GDelay30,&Delay30
	Gui,Add,Button,X+5 GDelay60,&Delay60
	
	dont_disturb_apps := ["Warframe", "Overwatch", "DARK SOULS III", "Heroes of the Storm", "Warhammer", "Battlerite", "MONSTER HUNTER"]
	for _, Title in dont_disturb_apps {
        IfWinActive, %Title%
		{
            dont_disturb := true
        }
    }
	IfWinActive, Warframe
	{
		dont_disturb := true
		SoundBeep, 750, 500
		SoundBeep, 750, 500
		SoundBeep, 750, 500
		SoundBeep, 750, 500
		SoundBeep, 750, 500
	}
	
	IfWinActive, Overwatch
	{
		dont_disturb := true
	}
	
	IfWinActive, DARK SOULS III
	{
		dont_disturb := true
		SoundBeep, 750, 500
	}

	IfWinActive, Heroes of the Storm
	{
		dont_disturb := true
		SoundBeep, 750, 500
	}
	
	/*
	if(WinActive("ahk_exe eldenring.exe"))
	{
		dont_disturb := true
		SoundBeep, 750, 500
	}
	*/

	IfWinActive, ELDEN RING
	{
		dont_disturb := true
	}
	

	IfWinActive, Warhammer
	{
		dont_disturb := true
	}

	IfWinActive, Battlerite
	{
		dont_disturb := true
	}
	
	
	if(dont_disturb){
		WinGetTitle, title, A
		SoundBeep, 750, 500
		SoundBeep, 750, 500
		
		WinWaitNotActive, %title%
	}
	
	Gui,Show,,%applicationname%
	
	Return

Delay60:
	minutenum := 60
	Goto, START
Delay30:
	minutenum := 30
	Goto, START
Delay20:
	minutenum := 20
	Goto, START
Delay15:
	minutenum := 15
	Goto, START
Delay10:
	minutenum := 10
	Goto, START
Delay5:
	minutenum := 5
	Goto, START


SETBEEPS:
BeepCount:=3
Goto, START

CUSTOMSUBMIT:
customDelaySet := 1

START:
Gui,Submit


;MsgBox,64,%applicationname%,% hour " hour"
;MsgBox,64,%applicationname%,% minute " minute"
;MsgBox,64,%applicationname%,% message " message"

;MsgBox,64,%applicationname%,% hournum " hournum"
;MsgBox,64,%applicationname%,% minutenum " minutenum"
;MsgBox,64,%applicationname%,% messagenum " messagenum"

if(customDelay!=0) {		;the first alarm triggered
	if(customDelaySet){
		minutenum := customDelay
		customDelaySet := 0
	}
	AddDelayToTime()
	
	;MsgBox,64,%applicationname%,% customDelay " customDelay"
	;MsgBox,64,%applicationname%,% hour " hour"
	;MsgBox,64,%applicationname%,% minute " minute"
	;MsgBox,64,%applicationname%,% minutenum " minutenum"
} else {
	If hour=
	{
		If minute=
		{
			AddDelayToTime()
			message := messagenum
		}
	}

	If hour=
	{
	  hour:=A_Hour+1
	  If (hour>23)
		hour:="00"
	}
	If minute=
	  minute:="00"
	IfInString,hour,am
	  hour:=SubStr(hour,1,2)

	IfInString,hour,pm
	{
	  hour:=SubStr(hour,1,2)+12
	  If (hour=24)
		hour:="00"
	}
}

;MsgBox,64,%applicationname%,% hour "hour"
;MsgBox,64,%applicationname%,% minute "minute"
now:=A_Now
alarm:=A_Year A_Mon A_DD SubStr("0" hour,-1,2) SubStr("0" minute,-1,2) "00"
If (now>alarm)
  EnvAdd,alarm,1,Day
timer:=alarm
EnvSub,timer,now,Seconds
timer:=timer*-1000
SetTimer,ALARM,% timer
If (use24=0)
  FormatTime,alarm,% alarm, dddd MMMM d, yyyy hh:mm tt
Else
  FormatTime,alarm,% alarm, dddd d. MMMM yyyy hh:mm
TrayTip,%applicationname%,% message " set for " alarm,3
Menu,Tray,Tip,% message " set for " alarm
Return


TEST:
ALARM:
SoundBeep, 750, 500
SoundBeep, 750, 500
if(BeepCount<0){
	;MsgBox,64,%applicationname%,% message
	Goto, CONFIRMFINISHED
}

While(BeepCount>0){
	SoundBeep, 750, 500
	BeepCount--
;	sleep 1000
}

; done so I can pull open the tray and look at the alarm that I was on "dont disturb" mode for
if( BeepCount= -2) 
{
	ExitApp
}
Return


ABOUT:
Gui,99:Destroy
Gui,99:Margin,20,20
Gui,99:Add,Picture,xm Icon1,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,%applicationname% v1.1
Gui,99:Font
Gui,99:Add,Text,y+10,Enter a time and a message to set an alarm
Gui,99:Add,Text,y+10,- Supports both am/pm and 24 hour clock
Gui,99:Add,Text,y+10,- No need to input minutes

Gui,99:Add,Picture,xm y+20 Icon2,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,Custom Alarm Clock by Michael Salata
Gui,99:Font
Gui,99:Add,Text,y+10,For more info on the developer, visit
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 GLinkedIn,linkedin.com/in/michael-salata-6115a926
Gui,99:Font

Gui,99:Add,Picture,xm y+20 Icon4,%applicationname%.exe
Gui,99:Font,Bold
Gui,99:Add,Text,x+10 yp+10,AutoHotkey
Gui,99:Font
Gui,99:Add,Text,y+10,This tool was made using the powerful
Gui,99:Font,CBlue Underline
Gui,99:Add,Text,y+5 GAUTOHOTKEY,www.AutoHotkey.com
Gui,99:Font

Gui,99:Show,,%applicationname% About
hCur:=DllCall("LoadCursor","UInt",NULL,"Int",32649,"UInt") ;IDC_HAND
OnMessage(0x200,"WM_MOUSEMOVE") 
Return

LinkedIn:
  Run,https://www.linkedin.com/in/michael-salata-6115a926/
Return

AUTOHOTKEY:
  Run,http://www.autohotkey.com,,UseErrorLevel
Return

99GuiClose:
  Gui,99:Destroy
  OnMessage(0x200,"")
  DllCall("DestroyCursor","Uint",hCur)
Return

WM_MOUSEMOVE(wParam,lParam)
{
  Global hCur
  MouseGetPos,,,,ctrl
  If ctrl in Static9,Static13,Static17
    DllCall("SetCursor","UInt",hCur)
  Return
}
Return

EXIT:
ExitApp

AddDelayToTime(){
			hour := A_Hour
			minute := A_Min
			
			hour += hournum
			minute += minutenum
			
			while( minute >= 60 ){
				minute -= 60
				hour += 1
			}
			
			if( hour > 23 ){
				hour -= 24
			}
}

ProcessParameters:
	if(%0%){
		
		Global Args := []

		Loop, %0%
			Args.Push(%A_Index%)
			
		Loop %0%
		{
			;if(
			;MsgBox % "Command line Param " A_Index " is " %A_Index%
		}
		
		;MsgBox % "Command line Param " 0 " is " Args[0]
		;MsgBox % "Command line Param " 1 " is " Args[1]
		;MsgBox % "Command line Param " 2 " is " Args[2]
		;MsgBox % "Command line Param " 3 " is " Args[3]
		;MsgBox % "Command line Param " 4 " is " Args[4]
		
		if(Args[1]="num"){
			hour :=
			minute :=
		
			global hournum:=Args[2]
			global minutenum:=Args[3]
			global messagenum:=Args[4]
		} else {
			if(Args[1]="time"){
				hournum :=
				minutenum :=
				
				hour:=Args[2]
				minute:=Args[3]
				message:=Args[4]
			}
		}

		;hour:=%0%
		;minute:=%1%
		;message:=%2%
		;hournum:=%3%
		;minutenum:=%4%
		
		;hour:=A_Args%0%
		;minute:=A_Args%1%
		;message:=A_Args%2%
		;hournum:=A_Args%3%
		;minutenum:=A_Args%4%
		
		;MsgBox % "Number of command line args received: " %0% "`n"
		
		Goto, START
	}
Goto, MENU
