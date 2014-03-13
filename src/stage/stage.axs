PROGRAM_NAME='stage'

// DVX-3156
DEFINE_DEVICE

dvMASTER	= 0:1:0
dvSWITCHER	= 5002:1:0
dvRX1		= 5301:1:0	// Projector 1	(DXLinkfrom DVX)
dvRX2		= 5302:1:0	// Projector 2	(via separate Tx)
dvRX3		= 5303:1:0	// Confidence monitor at stage (DVXlink from DVX)
dvTX1		= 5401:1:0	// Feed from stage DISPLAY1
dvTX2		= 5402:1:0	// Feed from Camera
dvTX3		= 5403:1:0	// Feed to Projector 2	

dvTP		= 10001:1:0

vdvRMS		= 41001:1:0

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

// Inputs
Source1 	= 3
Source2 	= 4	//HDMI port on 3156
Source3		= 7	// Stage Laptop - DXLink port on 3156
Source4		= 8

//Outputs
Display1		= 1	// Projector 1 on DXLink output
Display2		= 3	// Projector 2 on DXLink
Display3	= 4	// LCD confidence monitor at stage vir Tx/Rx pair
Display4		= 2	// Local Display4 monitor

// TP buttons
btnSource1toDisplay1		= 11
btnSource1toDisplay2		= 21
btnSource1toDisplay3		= 31
btnSource1toDisplay4		= 41
btnSource1toALL		= 101

btnSource3toDisplay1		= 12
btnSource3toDisplay2		= 22
btnSource3toDisplay3		= 32
btnSource3toDisplay4		= 42
btnSource3toALL		= 102

btnSource4toDisplay1		= 13
btnSource4toDisplay2		= 23
btnSource4toDisplay3		= 33
btnSource4toDisplay4		= 43
btnSource4toALL		= 103

btnSource2toDisplay1		= 14
btnSource2toDisplay2		= 24
btnSource2toDisplay3	= 34
btnSource2toDisplay4	= 44
btnSource2toALL		= 104


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
DEFINE_MODULE 'RmsDvx3156SwitcherMonitor' dvxSwitcher(vdvRMS);  //monitor DVX internal settings
DEFINE_MODULE 'RmsDXLinkMonitor' mdlRmsDXLinkRx1MonitorMod(vdvRMS,dvRx1);  //modified SDK module
DEFINE_MODULE 'RmsDXLinkMonitor' mdlRmsDXLinkRx2MonitorMod(vdvRMS,dvRx2);  //modified SDK module
DEFINE_MODULE 'RmsDXLinkMonitor' mdlRmsDXLinkRx3MonitorMod(vdvRMS,dvRx3);  //modified SDK module
DEFINE_MODULE 'RmsDXLinkMonitor' mdlRmsDXLinkTxMonitorMod(vdvRMS,dvTx1);    //modified SDK module
DEFINE_MODULE 'RmsDXLinkMonitor' mdlRmsDXLinkTx2MonitorMod(vdvRMS,dvTx2);    //modified SDK module



#INCLUDE 'amx-dvx-control.axi'


#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_STATUS_CALLBACK
define_function dvxNotifyVideoInputStatus (dev dvxVideoInput, char signalStatus[])
{
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// signalStatus is the input signal status (DVX_SIGNAL_STATUS_NO_SIGNAL | DVX_SIGNAL_STATUS_UNKNOWN | DVX_SIGNAL_STATUS_VALID_SIGNAL)
	IF((dvxVideoInput.PORT = 2)|| (signalStatus = 'DVX_SIGNAL_STATUS_VALID_SIGNAL'))
	{
	    dvxSwitchVideoOnly(dvSWITCHER, Source1, Display1)  //auto-switch laptop to display
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
	    SEND_COMMAND vdvRMS,"'CONFIG.CLIENT.NAME-Stage System'"		// passed from room code  
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
	    CASE btnSource2toDisplay1:
	    {
		nDisplay1SourceSelected=Source2
		dvxSwitchVideoOnly(dvSWITCHER, Source2, Display1)
	    }
	    
	    CASE btnSource1toDisplay2:
	    {
		nDisplay2SourceSelected=Source1
		dvxSwitchVideoOnly(dvSWITCHER, Source1, Display2)
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
	    CASE btnSource2toDisplay2:
	    {
		nDisplay2SourceSelected=Source2
		dvxSwitchVideoOnly(dvSWITCHER, Source2, Display2)
	    }
	    
	    CASE btnSource1toDisplay3:
	    {
		nDisplay3SourceSelected=Source1
		dvxSwitchVideoOnly(dvSWITCHER, Source1, Display3)
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
	    CASE btnSource2toDisplay3:
	    {
		nDisplay3SourceSelected=Source2
		dvxSwitchVideoOnly(dvSWITCHER, Source2, Display3)
	    }
	    
	    CASE btnSource1toDisplay4:
	    {
		nDisplay4SourceSelected=Source1
		dvxSwitchVideoOnly(dvSWITCHER, Source1, Display4)
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
	    CASE btnSource2toDisplay4:
	    {
		nDisplay4SourceSelected=Source2
		dvxSwitchVideoOnly(dvSWITCHER, Source2, Display4)
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

[dvTP,btnSource1toDisplay3]		= nDisplay3SourceSelected=Source1
[dvTP,btnSource3toDisplay3]		= nDisplay3SourceSelected=Source3
[dvTP,btnSource4toDisplay3]		= nDisplay3SourceSelected=Source4
[dvTP,btnSource2toDisplay3]		= nDisplay3SourceSelected=Source2

[dvTP,btnSource1toDisplay4]		= nDisplay4SourceSelected=Source1
[dvTP,btnSource3toDisplay4]		= nDisplay4SourceSelected=Source3
[dvTP,btnSource4toDisplay4]		= nDisplay4SourceSelected=Source4
[dvTP,btnSource2toDisplay4]		= nDisplay4SourceSelected=Source2


(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

