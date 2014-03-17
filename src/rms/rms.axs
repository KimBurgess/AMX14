PROGRAM_NAME='rms'
//  
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvMASTER	= 0:1:0
dvSWITCHER	= 5002:1:0
dvTP		= 10001:1:0

vdvRMS		= 41001:1:0


(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

// Inputs
Source1 		= 1	// Eric's laptop
Source2 		= 5	// NUC Out 1 
Source3			= 6	// NUC Out 2
Source4			= 7	// Signage
Source5			= 8	// AppleTV

//Outputs
Display1		= 1	// Projector 1 on DXLink output
Display2		= 2	// 
Display3		= 3	//  
Display4		= 4	//  

// TP buttons
btnSource1toDisplay1		= 11
btnSource1toDisplay2		= 21
btnSource1toDisplay3		= 31
btnSource1toDisplay4		= 41
btnSource1toALL			= 101

btnSource2toDisplay1		= 12
btnSource2toDisplay2		= 22
btnSource2toDisplay3		= 32
btnSource2toDisplay4		= 42
btnSource2toALL			= 102

btnSource3toDisplay1		= 13
btnSource3toDisplay2		= 23
btnSource3toDisplay3		= 33
btnSource3toDisplay4		= 43
btnSource3toALL			= 103

btnSource4toDisplay1		= 14
btnSource4toDisplay2		= 24
btnSource4toDisplay3		= 34
btnSource4toDisplay4		= 44
btnSource4toALL			= 104

btnSource5toDisplay1		= 15
btnSource5toDisplay2		= 25
btnSource5toDisplay3		= 35
btnSource5toDisplay4		= 45
btnSource5toALL			= 105



(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

// Flags
VOLATILE INTEGER nDisplay1SourceSelected
VOLATILE INTEGER nDisplay2SourceSelected
VOLATILE INTEGER nDisplay3SourceSelected
VOLATILE INTEGER nDisplay4SourceSelected
VOLATILE INTEGER nAllSourceSelected

dev dvDvxVidInPorts[] = { 5002:1:0, 5002:2:0, 5002:3:0, 5002:4:0, 5002:5:0, 5002:6:0, 5002:7:0, 5002:8:0, 5002:9:0, 5002:10:0 }

CHAR cRMS_Server_URL[] = 'http://events.amxaustralia.com.au/rms'
//CHAR cRMS_Server_URL[] = 'http://developer.amxaustralia.com.au/rms'


DEFINE_MODULE 'RmsNetLinxAdapter_dr4_0_0' mdlRMSNetLinx(vdvRMS);
DEFINE_MODULE 'RmsControlSystemMonitor' mdlRmsControlSystemMonitorMod(vdvRMS,dvMaster);
//DEFINE_MODULE 'RmsSystemPowerMonitor' mdlRmsSystemPowerMonitorMod(vdvRMS,dvMaster);
DEFINE_MODULE 'RmsTouchPanelMonitor' mdlRmsTouchPanelMonitorMod_1(vdvRMS,dvTP);
DEFINE_MODULE 'RmsDvxSwitcherMonitor' dvxSwitcher(vdvRMS);  //monitor DVX internal settings



#INCLUDE 'amx-dvx-control.axi'


#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_STATUS_CALLBACK
define_function dvxNotifyVideoInputStatus (dev dvxVideoInput, char signalStatus[])
{
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// signalStatus is the input signal status (DVX_SIGNAL_STATUS_NO_SIGNAL | DVX_SIGNAL_STATUS_UNKNOWN | DVX_SIGNAL_STATUS_VALID_SIGNAL)
	IF((dvxVideoInput.PORT = 2)|| (signalStatus = 'DVX_SIGNAL_STATUS_VALID_SIGNAL'))
	{
//	    dvxSwitchVideoOnly(dvSWITCHER, Source1, Display1)  //auto-switch laptop to display
	}
	
}

#INCLUDE 'amx-dvx-listener.axi'  // this must come last to work

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

SEND_COMMAND dvTP,'PAGE-RMS Demo'

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

DATA_EVENT[vdvRMS]
{
    ONLINE:
    {
	WAIT 50
	{
	    SEND_COMMAND vdvRMS,"'CONFIG.SERVER.URL-',cRMS_Server_URL" 	// Server URL
	    SEND_COMMAND vdvRMS,"'CONFIG.SERVER.PASSWORD-password'"
	    SEND_COMMAND vdvRMS,"'CONFIG.CLIENT.NAME-RMS Demo'"		// passed from room code  
	    SEND_COMMAND vdvRMS,"'CONFIG.CLIENT.ENABLED-true'"
	    SEND_COMMAND vdvRMS,"'CLIENT.CONNECT'"
	}
    }
    OFFLINE:
    {
    }
}


BUTTON_EVENT[dvTP,0]
{
    PUSH:
    {
	SWITCH (BUTTON.INPUT.CHANNEL)
	{
	    CASE btnSource1toDisplay1:
	    {
		nDisplay1SourceSelected=Source1
		dvxSwitchVideoOnly(dvSWITCHER, Source1, Display1)
	    }
	    CASE btnSource2toDisplay1:
	    {
		nDisplay1SourceSelected=Source2
		dvxSwitchVideoOnly(dvSWITCHER, Source2, Display1)
	    }
	    CASE btnSource3toDisplay1:
	    {
		nDisplay1SourceSelected=Source3
		dvxSwitchVideoOnly(dvSWITCHER, Source3, Display1)
	    }
	    CASE btnSource4toDisplay1:
	    {
		nDisplay1SourceSelected=Source4
		dvxSwitchVideoOnly(dvSWITCHER, Source4, Display1)
	    }
	    CASE btnSource5toDisplay1:
	    {
		nDisplay1SourceSelected=Source5
		dvxSwitchVideoOnly(dvSWITCHER, Source5, Display1)
	    }
	    
	    CASE btnSource1toDisplay2:
	    {
		nDisplay2SourceSelected=Source1
		dvxSwitchVideoOnly(dvSWITCHER, Source1, Display2)
	    }
	    CASE btnSource2toDisplay2:
	    {
		nDisplay2SourceSelected=Source2
		dvxSwitchVideoOnly(dvSWITCHER, Source2, Display2)
	    }
	    CASE btnSource3toDisplay2:
	    {
		nDisplay2SourceSelected=Source3
		dvxSwitchVideoOnly(dvSWITCHER, Source3, Display2)
	    }
	    CASE btnSource4toDisplay2:
	    {
		nDisplay2SourceSelected=Source4
		dvxSwitchVideoOnly(dvSWITCHER, Source4, Display2)
	    }
	    CASE btnSource5toDisplay2:
	    {
		nDisplay2SourceSelected=Source5
		dvxSwitchVideoOnly(dvSWITCHER, Source5, Display2)
	    }
	    
	    CASE btnSource1toDisplay3:
	    {
		nDisplay3SourceSelected=Source1
		dvxSwitchVideoOnly(dvSWITCHER, Source1, Display3)
	    }
	    CASE btnSource2toDisplay3:
	    {
		nDisplay3SourceSelected=Source2
		dvxSwitchVideoOnly(dvSWITCHER, Source2, Display3)
	    }
	    CASE btnSource3toDisplay3:
	    {
		nDisplay3SourceSelected=Source3
		dvxSwitchVideoOnly(dvSWITCHER, Source3, Display3)
	    }
	    CASE btnSource4toDisplay3:
	    {
		nDisplay3SourceSelected=Source4
		dvxSwitchVideoOnly(dvSWITCHER, Source4, Display3)
	    }
	    CASE btnSource5toDisplay3:
	    {
		nDisplay3SourceSelected=Source5
		dvxSwitchVideoOnly(dvSWITCHER, Source5, Display3)
	    }
	    
	    CASE btnSource1toDisplay4:
	    {
		nDisplay4SourceSelected=Source1
		dvxSwitchVideoOnly(dvSWITCHER, Source1, Display4)
	    }
	    CASE btnSource2toDisplay4:
	    {
		nDisplay4SourceSelected=Source2
		dvxSwitchVideoOnly(dvSWITCHER, Source2, Display4)
	    }
	    CASE btnSource3toDisplay4:
	    {
		nDisplay4SourceSelected=Source3
		dvxSwitchVideoOnly(dvSWITCHER, Source3, Display4)
	    }
	    CASE btnSource4toDisplay4:
	    {
		nDisplay4SourceSelected=Source4
		dvxSwitchVideoOnly(dvSWITCHER, Source4, Display4)
	    }
	    CASE btnSource5toDisplay4:
	    {
		nDisplay4SourceSelected=Source5
		dvxSwitchVideoOnly(dvSWITCHER, Source5, Display4)
	    }
	    
	    CASE btnSource1toALL:
	    {
		nDisplay1SourceSelected=Source1
		nDisplay2SourceSelected=Source1
		nDisplay3SourceSelected=Source1
		nDisplay4SourceSelected=Source1
		dvxSwitchVideoOnly(dvSWITCHER, Source1, Display1)
		dvxSwitchVideoOnly(dvSWITCHER, Source1, Display2)
		dvxSwitchVideoOnly(dvSWITCHER, Source1, Display3)
		dvxSwitchVideoOnly(dvSWITCHER, Source1, Display4)
	    }
	    CASE btnSource2toALL:
	    {
		nDisplay1SourceSelected=Source2
		nDisplay2SourceSelected=Source2
		nDisplay3SourceSelected=Source2
		nDisplay4SourceSelected=Source2
		dvxSwitchVideoOnly(dvSWITCHER, Source2, Display1)
		dvxSwitchVideoOnly(dvSWITCHER, Source2, Display2)
		dvxSwitchVideoOnly(dvSWITCHER, Source2, Display3)
		dvxSwitchVideoOnly(dvSWITCHER, Source2, Display4)
	    }
	    CASE btnSource3toALL:
	    {
		nDisplay1SourceSelected=Source3
		nDisplay2SourceSelected=Source3
		nDisplay3SourceSelected=Source3
		nDisplay4SourceSelected=Source3
		dvxSwitchVideoOnly(dvSWITCHER, Source3, Display1)
		dvxSwitchVideoOnly(dvSWITCHER, Source3, Display2)
		dvxSwitchVideoOnly(dvSWITCHER, Source3, Display3)
		dvxSwitchVideoOnly(dvSWITCHER, Source3, Display4)
	    }
	    CASE btnSource4toALL:
	    {
		nDisplay1SourceSelected=Source4
		nDisplay2SourceSelected=Source4
		nDisplay3SourceSelected=Source4
		nDisplay4SourceSelected=Source4
		dvxSwitchVideoOnly(dvSWITCHER, Source4, Display1)
		dvxSwitchVideoOnly(dvSWITCHER, Source4, Display2)
		dvxSwitchVideoOnly(dvSWITCHER, Source4, Display3)
		dvxSwitchVideoOnly(dvSWITCHER, Source4, Display4)
	    }
	    CASE btnSource5toALL:
	    {
		nDisplay1SourceSelected=Source5
		nDisplay2SourceSelected=Source5
		nDisplay3SourceSelected=Source5
		nDisplay4SourceSelected=Source5
		dvxSwitchVideoOnly(dvSWITCHER, Source5, Display1)
		dvxSwitchVideoOnly(dvSWITCHER, Source5, Display2)
		dvxSwitchVideoOnly(dvSWITCHER, Source5, Display3)
		dvxSwitchVideoOnly(dvSWITCHER, Source5, Display4)
	    }
	}
    }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

[dvTP,btnSource1toDisplay1]	= nDisplay1SourceSelected=Source1
[dvTP,btnSource2toDisplay1]	= nDisplay1SourceSelected=Source2
[dvTP,btnSource3toDisplay1]	= nDisplay1SourceSelected=Source3
[dvTP,btnSource4toDisplay1]	= nDisplay1SourceSelected=Source4
[dvTP,btnSource5toDisplay1]	= nDisplay1SourceSelected=Source5

[dvTP,btnSource1toDisplay2]	= nDisplay2SourceSelected=Source1
[dvTP,btnSource2toDisplay2]	= nDisplay2SourceSelected=Source2
[dvTP,btnSource3toDisplay2]	= nDisplay2SourceSelected=Source3
[dvTP,btnSource4toDisplay2]	= nDisplay2SourceSelected=Source4
[dvTP,btnSource5toDisplay2]	= nDisplay2SourceSelected=Source5

[dvTP,btnSource1toDisplay3]	= nDisplay3SourceSelected=Source1
[dvTP,btnSource2toDisplay3]	= nDisplay3SourceSelected=Source2
[dvTP,btnSource3toDisplay3]	= nDisplay3SourceSelected=Source3
[dvTP,btnSource4toDisplay3]	= nDisplay3SourceSelected=Source4
[dvTP,btnSource5toDisplay3]	= nDisplay3SourceSelected=Source5

[dvTP,btnSource1toDisplay4]	= nDisplay4SourceSelected=Source1
[dvTP,btnSource2toDisplay4]	= nDisplay4SourceSelected=Source2
[dvTP,btnSource3toDisplay4]	= nDisplay4SourceSelected=Source3
[dvTP,btnSource4toDisplay4]	= nDisplay4SourceSelected=Source4
[dvTP,btnSource5toDisplay4]	= nDisplay4SourceSelected=Source5


(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

