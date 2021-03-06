PROGRAM_NAME='enova-dvx'

include 'amx-dvx-control'
include 'amx-device-control'


define_device

dvSystem = 0:1:0

// DVX Switcher Input/Outputs - Generic Identifiers
dvDvxSwitcherMain         = 5002:DVX_PORT_MAIN:0
// Video inputs

dvDvxSwitcherVideoInput7  = 5002:DVX_PORT_VID_IN_7:0
dvDvxSwitcherVideoInput9 = 5002:DVX_PORT_VID_IN_9:0
// Audio inputs
dvDvxSwitcherAudioInput7  = 5002: DVX_PORT_AUD_IN_7:0
dvDvxSwitcherAudioInput9 = 5002: DVX_PORT_AUD_IN_9:0

// Video outputs
dvDvxSwitcherVideoOutput1 = 5002:DVX_PORT_VID_OUT_1:0

// Audio outputs
dvDvxSwitcherAudioOutput1 = 5002:DVX_PORT_AUD_OUT_1:0

vdvRMS = 41001:1:0 // RMS Client (Duet Module)


// RMS Client - NetLinx Adapter Module
// This module includes the RMS client module 
// and enables communication via SEND_COMMAND, 
// SEND_STRINGS, CHANNELS, and LEVELS with the 
// RMS Client.
DEFINE_MODULE 'RmsNetLinxAdapter_dr4_0_0' mdlRMSNetLinx(vdvRMS)
			  'RmsControlSystemMonitor' mdlRMSControlSys(vdvRMS, dvSystem)
			  'RmsDvxSwitcherMonitor' mdlRMSDvxSwitch(vdvRMS)
			  //'RmsTouchPanelMonitor' mdlRMSTouchPanel(vdvRMS, 
			

define_variable

dev dvDvxMainPorts[] = { dvDvxSwitcherMain }
dev dvDvxVidInPorts[] = { dvDvxSwitcherVideoInput7, dvDvxSwitcherVideoInput9 }

// declared a variable to track all the DVX info
_DvxSwitcher dvx




#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_STATUS_CALLBACK
define_function dvxNotifyVideoInputStatus (dev dvxVideoInput, char signalStatus[])
{
	//save current signal status
	dvx.videoInputs[dvxVideoInput.port].status = signalStatus
	
	// The logic below is:
	// If input 9 is valid and input 10 is not valid and we are using input 10 then 
	// we need to switch to the valid input 9. In the else if we test for the opposite.
	// This logic will do nothing if inputs are both valid or if both inputs are not valid
	

	if ((dvx.videoInputs[dvDvxSwitcherVideoInput7.port].status == DVX_SIGNAL_STATUS_VALID_SIGNAL) and
	   (dvx.videoInputs[dvDvxSwitcherVideoInput9.port].status != DVX_SIGNAL_STATUS_VALID_SIGNAL) and
	   (dvx.switchStatusVideoOutputs[dvDvxSwitcherVideoOutput1.port] == dvDvxSwitcherVideoInput9.port))
	{
		sendString (0,'lost input 9 switching to input 7')
		dvxSwitchVideoOnly (dvDvxSwitcherMain, dvDvxSwitcherVideoInput7.Port , dvDvxSwitcherVideoOutput1.Port)	
	}
	
	else if ((dvx.videoInputs[dvDvxSwitcherVideoInput9.port].status == DVX_SIGNAL_STATUS_VALID_SIGNAL) and
			(dvx.videoInputs[dvDvxSwitcherVideoInput7.port].status != DVX_SIGNAL_STATUS_VALID_SIGNAL) and
			(dvx.switchStatusVideoOutputs[dvDvxSwitcherVideoOutput1.port] == dvDvxSwitcherVideoInput7.port))
	{
		sendString (0,'lost input 7 switching to input 9')
		dvxSwitchVideoOnly (dvDvxSwitcherMain, dvDvxSwitcherVideoInput9.Port , dvDvxSwitcherVideoOutput1.Port)	
	}
	
	//to see what is going on uncomment the feedback below
	sendString (0, "'[',itoa(dvxVideoInput.Number),':',itoa(dvxVideoInput.Port),':',itoa(dvxVideoInput.System),'] ',signalStatus")
}


#define INCLUDE_DVX_NOTIFY_SWITCH_CALLBACK
define_function dvxNotifySwitch (dev dvxPort1, char signalType[], integer input, integer output)
{
	// dvxPort1 is port 1 on the DVX.
	// signalType contains the type of signal that was switched ('AUDIO' or 'VIDEO')
	// input contains the source input number that was switched to the destination
	// output contains the destination output number that the source was switched to
	if(signalType == 'VIDEO')
		dvx.switchStatusVideoOutputs[output] = input

}


include 'amx-dvx-listener'

define_event 

data_event [dvDvxSwitcherMain]
{
	online:
	{
		dvxRequestVideoInputStatus(dvDvxSwitcherVideoInput7)
		dvxRequestVideoInputStatus(dvDvxSwitcherVideoInput9)
		dvxRequestInputVideo(dvDvxSwitcherMain,dvDvxSwitcherVideoOutput1.port)
		dvxSwitchVideoOnly (dvDvxSwitcherMain, dvDvxSwitcherVideoInput7.Port , dvDvxSwitcherVideoOutput1.Port)	}
}

