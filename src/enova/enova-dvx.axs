PROGRAM_NAME='enova-dvx'

include 'amx-dvx-control'
include 'amx-device-control'


define_device

// DVX Switcher Input/Outputs - Generic Identifiers
dvDvxSwitcherMain         = 5002:DVX_PORT_MAIN:0
// Video inputs

dvDvxSwitcherVideoInput9  = 5002:DVX_PORT_VID_IN_9:0
dvDvxSwitcherVideoInput10 = 5002:DVX_PORT_VID_IN_10:0
// Audio inputs
dvDvxSwitcherAudioInput9  = 5002: DVX_PORT_AUD_IN_9:0
dvDvxSwitcherAudioInput10 = 5002: DVX_PORT_AUD_IN_10:0

// Video outputs
dvDvxSwitcherVideoOutput1 = 5002:DVX_PORT_VID_OUT_1:0

// Audio outputs
dvDvxSwitcherAudioOutput1 = 5002:DVX_PORT_AUD_OUT_1:0



define_variable

dev dvDvxMainPorts[] = { dvDvxSwitcherMain }
dev dvDvxVidInPorts[] = { dvDvxSwitcherVideoInput9, dvDvxSwitcherVideoInput10 }

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
	

	if ((dvx.videoInputs[dvDvxSwitcherVideoInput9.port].status == DVX_SIGNAL_STATUS_VALID_SIGNAL) and
	   (dvx.videoInputs[dvDvxSwitcherVideoInput10.port].status != DVX_SIGNAL_STATUS_VALID_SIGNAL) and
	   (dvx.switchStatusVideoOutputs[dvDvxSwitcherVideoOutput1.port] == dvDvxSwitcherVideoInput10.port))
	{
		sendString (0,'lost input 9 switching to input 10')
		dvxSwitchVideoOnly (dvDvxSwitcherMain, dvDvxSwitcherVideoInput9.Port , dvDvxSwitcherVideoOutput1.Port)	
	}
	
	else if ((dvx.videoInputs[dvDvxSwitcherVideoInput10.port].status == DVX_SIGNAL_STATUS_VALID_SIGNAL) and
			(dvx.videoInputs[dvDvxSwitcherVideoInput9.port].status != DVX_SIGNAL_STATUS_VALID_SIGNAL) and
			(dvx.switchStatusVideoOutputs[dvDvxSwitcherVideoOutput1.port] == dvDvxSwitcherVideoInput9.port))
	{
		sendString (0,'lost input 10 switching to input 9')
		dvxSwitchVideoOnly (dvDvxSwitcherMain, dvDvxSwitcherVideoInput10.Port , dvDvxSwitcherVideoOutput1.Port)	
	}
	
	//to see what is going on uncomment the feedback below
	//sendString (0, "'[',itoa(dvxVideoInput.Number),':',itoa(dvxVideoInput.Port),':',itoa(dvxVideoInput.System),'] ',signalStatus")
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
		dvxRequestVideoInputStatus(dvDvxSwitcherVideoInput9)
		dvxRequestVideoInputStatus(dvDvxSwitcherVideoInput10)
		dvxRequestInputVideo(dvDvxSwitcherMain,dvDvxSwitcherVideoOutput1.port)
		dvxSwitchVideoOnly (dvDvxSwitcherMain, dvDvxSwitcherVideoInput9.Port , dvDvxSwitcherVideoOutput1.Port)	}
}

