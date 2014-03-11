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

vdvRMS		= 41001:1:0

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

// Inputs
SIGNAGE 	= 4	//HDMI port 
LAPTOP  	= 3
STAGE		= 7	//DXLink port
CAMERA		= 8

//Outputs
PJ1		= 1	// Projector 1 on DXLink output
PJ2		= 3	// Projector 2 on DXLink
CONFIDENCE	= 4	// LCD confidence monitor at stage vir Tx/Rx pair
PREVIEW		= 2	// Local preview monitor

// TP buttons
btnLAPTOPtoPJ1		= 11
btnLAPTOPtoPJ2		= 21
btnLAPTOPtoCONF		= 31
btnLAPTOPtoPREV		= 41
btnLAPTOPtoALL		= 101

btnSTAGEtoPJ1		= 12
btnSTAGEtoPJ2		= 22
btnSTAGEtoCONF		= 32
btnSTAGEtoPREV		= 42
btnSTAGEtoALL		= 102

btnCAMERAtoPJ1		= 13
btnCAMERAtoPJ2		= 23
btnCAMERAtoCONF		= 33
btnCAMERAtoPREV		= 43
btnCAMERAtoALL		= 103

btnSIGNAGEtoPJ1		= 14
btnSIGNAGEtoPJ2		= 24
btnSIGNAGEtoCONF	= 34
btnSIGNAGEtoPREV	= 44
btnSIGNAGEtoALL		= 104


(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

// Flags
VOLATILE INTEGER nPJ1SourceSelected
VOLATILE INTEGER nPJ2SourceSelected
VOLATILE INTEGER nConfidenceSourceSelected
VOLATILE INTEGER nPreviewSourceSelected
VOLATILE INTEGER nAllSourceSelected

dev dvDvxVidInPorts[] = { 5002:1:0, 5002:2:0, 5002:3:0, 5002:4:0, 5002:5:0, 5002:6:0, 5002:7:0, 5002:8:0, 5002:9:0, 5002:10:0 }

//CHAR cRMS_Server_URL[] = 'http://events.amxaustralia.com.au/rms'
CHAR cRMS_Server_URL[] = 'http://developer.amxaustralia.com.au/rms'


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
	    dvxSwitchVideoOnly(dvSWITCHER, LAPTOP, PJ1)  //auto-switch laptop to display
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
	    CASE btnLAPTOPtoPJ1:
	    {
		nPJ1SourceSelected=LAPTOP
		dvxSwitchVideoOnly(dvSWITCHER, LAPTOP, PJ1)
	    }
	    CASE btnSTAGEtoPJ1:
	    {
		nPJ1SourceSelected=STAGE
		dvxSwitchVideoOnly(dvSWITCHER, STAGE, PJ1)
	    }
	    CASE btnCAMERAtoPJ1:
	    {
		nPJ1SourceSelected=CAMERA
		dvxSwitchVideoOnly(dvSWITCHER, CAMERA, PJ1)
	    }
	    CASE btnSIGNAGEtoPJ1:
	    {
		nPJ1SourceSelected=SIGNAGE
		dvxSwitchVideoOnly(dvSWITCHER, SIGNAGE, PJ1)
	    }
	    
	    CASE btnLAPTOPtoPJ2:
	    {
		nPJ2SourceSelected=LAPTOP
		dvxSwitchVideoOnly(dvSWITCHER, LAPTOP, PJ2)
	    }
	    CASE btnSTAGEtoPJ2:
	    {
		nPJ2SourceSelected=STAGE
		dvxSwitchVideoOnly(dvSWITCHER, STAGE, PJ2)
	    }
	    CASE btnCAMERAtoPJ2:
	    {
		nPJ2SourceSelected=CAMERA
		dvxSwitchVideoOnly(dvSWITCHER, CAMERA, PJ2)
	    }
	    CASE btnSIGNAGEtoPJ2:
	    {
		nPJ2SourceSelected=SIGNAGE
		dvxSwitchVideoOnly(dvSWITCHER, SIGNAGE, PJ2)
	    }
	    
	    CASE btnLAPTOPtoCONF:
	    {
		nCONFIDENCESourceSelected=LAPTOP
		dvxSwitchVideoOnly(dvSWITCHER, LAPTOP, CONFIDENCE)
	    }
	    CASE btnSTAGEtoCONF:
	    {
		nCONFIDENCESourceSelected=STAGE
		dvxSwitchVideoOnly(dvSWITCHER, STAGE, CONFIDENCE)
	    }
	    CASE btnCAMERAtoCONF:
	    {
		nCONFIDENCESourceSelected=CAMERA
		dvxSwitchVideoOnly(dvSWITCHER, CAMERA, CONFIDENCE)
	    }
	    CASE btnSIGNAGEtoCONF:
	    {
		nCONFIDENCESourceSelected=SIGNAGE
		dvxSwitchVideoOnly(dvSWITCHER, SIGNAGE, CONFIDENCE)
	    }
	    
	    CASE btnLAPTOPtoPREV:
	    {
		nPREVIEWSourceSelected=LAPTOP
		dvxSwitchVideoOnly(dvSWITCHER, LAPTOP, PREVIEW)
	    }
	    CASE btnSTAGEtoPREV:
	    {
		nPREVIEWSourceSelected=STAGE
		dvxSwitchVideoOnly(dvSWITCHER, STAGE, PREVIEW)
	    }
	    CASE btnCAMERAtoPREV:
	    {
		nPREVIEWSourceSelected=CAMERA
		dvxSwitchVideoOnly(dvSWITCHER, CAMERA, PREVIEW)
	    }
	    CASE btnSIGNAGEtoPREV:
	    {
		nPREVIEWSourceSelected=SIGNAGE
		dvxSwitchVideoOnly(dvSWITCHER, SIGNAGE, PREVIEW)
	    }
	    
	    CASE btnLAPTOPtoALL:
	    {
		nPJ1SourceSelected=LAPTOP
		nPJ2SourceSelected=LAPTOP
		nConfidenceSourceSelected=LAPTOP
		nPreviewSourceSelected=LAPTOP
		dvxSwitchVideoOnly(dvSWITCHER, LAPTOP, PJ1)
		dvxSwitchVideoOnly(dvSWITCHER, LAPTOP, PJ2)
		dvxSwitchVideoOnly(dvSWITCHER, LAPTOP, CONFIDENCE)
		dvxSwitchVideoOnly(dvSWITCHER, LAPTOP, PREVIEW)
	    }
	    CASE btnSTAGEtoALL:
	    {
		nPJ1SourceSelected=STAGE
		nPJ2SourceSelected=STAGE
		nConfidenceSourceSelected=STAGE
		nPreviewSourceSelected=STAGE
		dvxSwitchVideoOnly(dvSWITCHER, STAGE, PJ1)
		dvxSwitchVideoOnly(dvSWITCHER, STAGE, PJ2)
		dvxSwitchVideoOnly(dvSWITCHER, STAGE, CONFIDENCE)
		dvxSwitchVideoOnly(dvSWITCHER, STAGE, PREVIEW)
	    }
	    CASE btnCAMERAtoALL:
	    {
		nPJ1SourceSelected=CAMERA
		nPJ2SourceSelected=CAMERA
		nConfidenceSourceSelected=CAMERA
		nPreviewSourceSelected=CAMERA
		dvxSwitchVideoOnly(dvSWITCHER, CAMERA, PJ1)
		dvxSwitchVideoOnly(dvSWITCHER, CAMERA, PJ2)
		dvxSwitchVideoOnly(dvSWITCHER, CAMERA, CONFIDENCE)
		dvxSwitchVideoOnly(dvSWITCHER, CAMERA, PREVIEW)
	    }
	    CASE btnSIGNAGEtoALL:
	    {
		nPJ1SourceSelected=SIGNAGE
		nPJ2SourceSelected=SIGNAGE
		nConfidenceSourceSelected=SIGNAGE
		nPreviewSourceSelected=SIGNAGE
		dvxSwitchVideoOnly(dvSWITCHER, SIGNAGE, PJ1)
		dvxSwitchVideoOnly(dvSWITCHER, SIGNAGE, PJ2)
		dvxSwitchVideoOnly(dvSWITCHER, SIGNAGE, CONFIDENCE)
		dvxSwitchVideoOnly(dvSWITCHER, SIGNAGE, PREVIEW)
	    }
	}
    }
}

(***********************************************************)
(*            THE ACTUAL PROGRAM GOES BELOW                *)
(***********************************************************)
DEFINE_PROGRAM

[dvTP,btnLAPTOPtoPJ1]	= nPJ1SourceSelected=LAPTOP
[dvTP,btnSTAGEtoPJ1]	= nPJ1SourceSelected=STAGE
[dvTP,btnCAMERAtoPJ1]	= nPJ1SourceSelected=CAMERA
[dvTP,btnSIGNAGEtoPJ1]	= nPJ1SourceSelected=SIGNAGE

[dvTP,btnLAPTOPtoPJ2]	= nPJ2SourceSelected=LAPTOP
[dvTP,btnSTAGEtoPJ2]	= nPJ2SourceSelected=STAGE
[dvTP,btnCAMERAtoPJ2]	= nPJ2SourceSelected=CAMERA
[dvTP,btnSIGNAGEtoPJ2]	= nPJ2SourceSelected=SIGNAGE

[dvTP,btnLAPTOPtoCONF]	= nCONFIDENCESourceSelected=LAPTOP
[dvTP,btnSTAGEtoCONF]	= nCONFIDENCESourceSelected=STAGE
[dvTP,btnCAMERAtoCONF]	= nCONFIDENCESourceSelected=CAMERA
[dvTP,btnSIGNAGEtoCONF]	= nCONFIDENCESourceSelected=SIGNAGE

[dvTP,btnLAPTOPtoPREV]	= nPreviewSourceSelected=LAPTOP
[dvTP,btnSTAGEtoPREV]	= nPreviewSourceSelected=STAGE
[dvTP,btnCAMERAtoPREV]	= nPreviewSourceSelected=CAMERA
[dvTP,btnSIGNAGEtoPREV]	= nPreviewSourceSelected=SIGNAGE


(***********************************************************)
(*                     END OF PROGRAM                      *)
(*        DO NOT PUT ANY CODE BELOW THIS COMMENT           *)
(***********************************************************)

