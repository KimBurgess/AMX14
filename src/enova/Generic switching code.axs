PROGRAM_NAME='Generic switching code'
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 04/05/2006  AT: 09:00:25        *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    $History: $
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvMASTER	= 0:1:0
dvSWITCHER	= 5002:1:0
dvTP		= 10001:1:0
dvTP2		= 10002:1:0	// TP outside door

vdvRMS		= 41001:1:0

ipSocketXpressPlayer = 0:2:0

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

// Inputs
Source1 		= 1	// Eric's laptop
Source2 		= 2	 
Source3			= 5	// Signage player
Source4			= 6

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

btnSignageSlideTitle = 200
btnSignageSlideStory = 201


(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

char ipAddressXpressPlayer[50]             = '192.168.4.70'
char xpressPlayerVariableNameToUpdate[100] = 'menu'
char xpressPlayerVariableValueTitle[100]   = 'P1'
char xpressPlayerVariableValueStory[100]   = 'P2'

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
DEFINE_MODULE 'RmsTouchPanelMonitor' mdlRmsTouchPanelMonitorMod_2(vdvRMS,dvTP2);
DEFINE_MODULE 'RmsDvxSwitcherMonitor' dvxSwitcher(vdvRMS);  //monitor DVX internal settings



#INCLUDE 'amx-dvx-control.axi'
#INCLUDE 'amx-is-xpress-api'
#INCLUDE 'amx-is-xpress-control'


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
	    SEND_COMMAND vdvRMS,"'CONFIG.CLIENT.NAME-Enova Demo'"		// passed from room code  
	    SEND_COMMAND vdvRMS,"'CONFIG.CLIENT.ENABLED-true'"
	    SEND_COMMAND vdvRMS,"'CLIENT.CONNECT'"
	}
    }
    OFFLINE:
    {
    }
}


DATA_EVENT[dvTP]
{
	ONLINE:
	{
		SEND_COMMAND dvTP,'PAGE-Enova Demo'
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
	    CASE btnSignageSlideTitle:
	    {
			// code to switch IS-SPX-1300 to Title slide
			xpressUpdateVariable (ipSocketXpressPlayer, ipAddressXpressPlayer, XPRESS_NETWORK_API_TCP_PORT_DEFAULT, xpressPlayerVariableNameToUpdate, xpressPlayerVariableValueTitle)
	    }
	    CASE btnSignageSlideStory:
	    {
		// code to switch IS-SPX-1300 to Story slide
			xpressUpdateVariable (ipSocketXpressPlayer, ipAddressXpressPlayer, XPRESS_NETWORK_API_TCP_PORT_DEFAULT, xpressPlayerVariableNameToUpdate, xpressPlayerVariableValueStory)
	    }
	}    
    }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

[dvTP,btnSource1toDisplay1]	= nDisplay1SourceSelected=Source1
[dvTP,btnSource3toDisplay1]	= nDisplay1SourceSelected=Source3
[dvTP,btnSource4toDisplay1]	= nDisplay1SourceSelected=Source4
[dvTP,btnSource2toDisplay1]	= nDisplay1SourceSelected=Source2

[dvTP,btnSource1toDisplay2]	= nDisplay2SourceSelected=Source1
[dvTP,btnSource3toDisplay2]	= nDisplay2SourceSelected=Source3
[dvTP,btnSource4toDisplay2]	= nDisplay2SourceSelected=Source4
[dvTP,btnSource2toDisplay2]	= nDisplay2SourceSelected=Source2

[dvTP,btnSource1toDisplay3]	= nDisplay3SourceSelected=Source1
[dvTP,btnSource3toDisplay3]	= nDisplay3SourceSelected=Source3
[dvTP,btnSource4toDisplay3]	= nDisplay3SourceSelected=Source4
[dvTP,btnSource2toDisplay3]	= nDisplay3SourceSelected=Source2

[dvTP,btnSource1toDisplay4]	= nDisplay4SourceSelected=Source1
[dvTP,btnSource3toDisplay4]	= nDisplay4SourceSelected=Source3
[dvTP,btnSource4toDisplay4]	= nDisplay4SourceSelected=Source4
[dvTP,btnSource2toDisplay4]	= nDisplay4SourceSelected=Source2


(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

