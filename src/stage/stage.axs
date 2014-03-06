PROGRAM_NAME='stage'

// DVX-3156
DEFINE_DEVICE

dvMASTER	= 0:1:0
dvSWITCHER	= 5002:1:0
dvRX1		= 5301:1:0	// Projector 1	(DXLinkfrom DVX)
dvRX2		= 5302:1:0	// Projector 2	(via separate Tx)
dvRX3		= 5303:1:0	// Confidence monitor at stage (DVXlink from DVX)
dvTX1		= 5401:1:0	// Feed from stage laptop
dvTX2		= 5402:1:0	// Feed from Camera
dvTX3		= 5403:1:0	// Feed to Projector 2	

dvTP		= 10001:1:0

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

// Inputs
SIGNAGE 	= 4	//HDMI port 
LAPTOP  	= 3
AUX		= 5	//Multiformat input
STAGE		= 7	//DXLink port
CAMERA		= 8

//Outputs
DISPLAY1	= 1	// Projector 1 on DXLink output
DISPLAY2	= 2	// Projector 2 on HDMI & then Tx
DISPLAY3	= 3	// LCD confidence monitor at stage

// TP buttons
btnSIGNAGEtoDISPLAY1	= 11
btnLAPTOPtoDISPLAY1	= 12
btnAUXtoDISPLAY1	= 13
btnCAMERAtoDISPLAY1	= 14

btnSIGNAGEtoDISPLAY2	= 21
btnLAPTOPtoDISPLAY2	= 22
btnAUXtoDISPLAY2	= 23
btnCAMERAtoDISPLAY2	= 24

btnSIGNAGEtoDISPLAY3	= 31
btnLAPTOPtoDISPLAY3	= 32
btnAUXtoDISPLAY3	= 33
btnCAMERAtoDISPLAY3	= 34

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

dev dvDvxVidInPorts[] = { 5002:1:0, 5002:2:0, 5002:3:0, 5002:4:0, 5002:5:0, 5002:6:0, 5002:7:0, 5002:8:0, 5002:9:0, 5002:10:0 }

#INCLUDE 'amx-dvx-control.axi'


#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_STATUS_CALLBACK
define_function dvxNotifyVideoInputStatus (dev dvxVideoInput, char signalStatus[])
{
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// signalStatus is the input signal status (DVX_SIGNAL_STATUS_NO_SIGNAL | DVX_SIGNAL_STATUS_UNKNOWN | DVX_SIGNAL_STATUS_VALID_SIGNAL)
	IF((dvxVideoInput.PORT = 2)|| (signalStatus = 'DVX_SIGNAL_STATUS_VALID_SIGNAL'))
	{
	    dvxSwitchVideoOnly(dvSWITCHER, LAPTOP, DISPLAY1)  //auto-switch laptop to display
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

BUTTON_EVENT[dvTP,0]
{
    PUSH:
    {
	SWITCH (BUTTON.INPUT.CHANNEL)
	{
	    CASE btnSIGNAGEtoDISPLAY1:
	    {
		nDisplay1SourceSelected=SIGNAGE
		dvxSwitchVideoOnly(dvSWITCHER, SIGNAGE, DISPLAY1)
	    }
	    CASE btnLAPTOPtoDISPLAY1:
	    {
		nDisplay1SourceSelected=LAPTOP
		dvxSwitchVideoOnly(dvSWITCHER, LAPTOP, DISPLAY1)
	    }
	    CASE btnAUXtoDISPLAY1:
	    {
		nDisplay1SourceSelected=AUX
		dvxSwitchVideoOnly(dvSWITCHER, AUX, DISPLAY1)
	    }
	    CASE btnCAMERAtoDISPLAY1:
	    {
		nDisplay1SourceSelected=CAMERA
		dvxSwitchVideoOnly(dvSWITCHER, CAMERA, DISPLAY1)
	    }
	    
	    CASE btnSIGNAGEtoDISPLAY2:
	    {
		nDisplay2SourceSelected=SIGNAGE
		dvxSwitchVideoOnly(dvSWITCHER, SIGNAGE, DISPLAY2)
	    }
	    CASE btnLAPTOPtoDISPLAY2:
	    {
		nDisplay2SourceSelected=LAPTOP
		dvxSwitchVideoOnly(dvSWITCHER, LAPTOP, DISPLAY2)
	    }
	    CASE btnAUXtoDISPLAY2:
	    {
		nDisplay2SourceSelected=AUX
		dvxSwitchVideoOnly(dvSWITCHER, AUX, DISPLAY2)
	    }
	    CASE btnCAMERAtoDISPLAY2:
	    {
		nDisplay2SourceSelected=CAMERA
		dvxSwitchVideoOnly(dvSWITCHER, CAMERA, DISPLAY2)
	    }
	    
	    CASE btnSIGNAGEtoDISPLAY3:
	    {
		nDisplay3SourceSelected=SIGNAGE
		dvxSwitchVideoOnly(dvSWITCHER, SIGNAGE, DISPLAY3)
	    }
	    CASE btnLAPTOPtoDISPLAY3:
	    {
		nDisplay3SourceSelected=LAPTOP
		dvxSwitchVideoOnly(dvSWITCHER, LAPTOP, DISPLAY3)
	    }
	    CASE btnAUXtoDISPLAY3:
	    {
		nDisplay3SourceSelected=AUX
		dvxSwitchVideoOnly(dvSWITCHER, AUX, DISPLAY3)
	    }
	    CASE btnCAMERAtoDISPLAY3:
	    {
		nDisplay3SourceSelected=CAMERA
		dvxSwitchVideoOnly(dvSWITCHER, CAMERA, DISPLAY3)
	    }
	}
    }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

[dvTP,btnSIGNAGEtoDISPLAY1]	= nDisplay1SourceSelected=SIGNAGE
[dvTP,btnLAPTOPtoDISPLAY1]	= nDisplay1SourceSelected=LAPTOP
[dvTP,btnAUXtoDISPLAY1]		= nDisplay1SourceSelected=AUX
[dvTP,btnCAMERAtoDISPLAY1]	= nDisplay1SourceSelected=CAMERA

[dvTP,btnSIGNAGEtoDISPLAY2]	= nDisplay2SourceSelected=SIGNAGE
[dvTP,btnLAPTOPtoDISPLAY2]	= nDisplay2SourceSelected=LAPTOP
[dvTP,btnAUXtoDISPLAY2]		= nDisplay2SourceSelected=AUX
[dvTP,btnCAMERAtoDISPLAY2]	= nDisplay2SourceSelected=CAMERA

[dvTP,btnSIGNAGEtoDISPLAY3]	= nDisplay3SourceSelected=SIGNAGE
[dvTP,btnLAPTOPtoDISPLAY3]	= nDisplay3SourceSelected=LAPTOP
[dvTP,btnAUXtoDISPLAY3]		= nDisplay3SourceSelected=AUX
[dvTP,btnCAMERAtoDISPLAY3]	= nDisplay3SourceSelected=CAMERA


(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

