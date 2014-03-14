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
	
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// signalStatus is the input signal status (DVX_SIGNAL_STATUS_NO_SIGNAL | DVX_SIGNAL_STATUS_UNKNOWN | DVX_SIGNAL_STATUS_VALID_SIGNAL)
	
	//save current signal status
	dvx.videoInputs[dvxVideoInput.port].status = signalStatus
	
	
	
	
	if (dvx.videoInputs[dvDvxSwitcherVideoInput9.port].status == DVX_SIGNAL_STATUS_VALID_SIGNAL or
		dvx.videoInputs[dvDvxSwitcherVideoInput10.port].status == DVX_SIGNAL_STATUS_VALID_SIGNAL )
	{
		//ask dvx if input 9 is = 'VALID SIGNAL' 
		if (dvx.videoInputs[dvDvxSwitcherVideoInput9.port].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
		{
			//if the input we are using == input 10 and it is != valid then switch to 9
			if (dvx.videoOutputs[dvDvxSwitcherVideoOutput1.Port].inputSelected == dvDvxSwitcherVideoInput10.port and
				dvx.videoInputs[dvDvxSwitcherVideoInput10.port].status != DVX_SIGNAL_STATUS_VALID_SIGNAL)
			{
				sendString (0,'lost input 10 switching to input 9')
				dvxSwitchVideoOnly (dvDvxSwitcherMain, dvDvxSwitcherVideoInput9.Port , dvDvxSwitcherVideoOutput1.Port)
			}
		}
		//ask dvx if input 10 is = 'VALID SIGNAL'
		if (dvx.videoInputs[dvDvxSwitcherVideoInput10.port].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
		{
			//if the input we are using == input 9 and it is != valid then switch to 10
			if (dvx.videoOutputs[dvDvxSwitcherVideoOutput1.Port].inputSelected == dvDvxSwitcherVideoInput9.port and 
				dvx.videoInputs[dvDvxSwitcherVideoInput9.port].status != DVX_SIGNAL_STATUS_VALID_SIGNAL)
			{
				sendString (0,'lost input 9 switching to input 10')
				dvxSwitchVideoOnly (dvDvxSwitcherMain, dvDvxSwitcherVideoInput10.Port , dvDvxSwitcherVideoOutput1.Port)
			}
		}
	}
	/*
	//ask dvx if either input is = 'VALID SIGNAL' so we dont switch when there are no valid signal
	if (dvx.videoInputs[dvDvxSwitcherVideoInput9.port].status == DVX_SIGNAL_STATUS_VALID_SIGNAL or
	    dvx.videoInputs[dvDvxSwitcherVideoInput10.port].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
	{
		//if the input we are using == the input that is != to a valid signal then switch ports
		if (dvx.videoOutputs[dvDvxSwitcherVideoOutput1.Port].inputSelected == dvxVideoInput.port and
			signalStatus != DVX_SIGNAL_STATUS_VALID_SIGNAL )
		{
			sendString (0,'lost input switching to other input')
			if (dvxVideoInput.port == dvDvxSwitcherVideoInput9.Port)
			{
				dvxSwitchVideoOnly (dvDvxSwitcherMain, dvDvxSwitcherVideoInput10.Port , dvDvxSwitcherVideoOutput1.Port)
			}
			else if (dvxVideoInput.port == dvDvxSwitcherVideoInput10.Port)
			{
				dvxSwitchVideoOnly (dvDvxSwitcherMain, dvDvxSwitcherVideoInput9.Port , dvDvxSwitcherVideoOutput1.Port)
			}			
		}
		// if the input we are using is != valid signal and the other input is == valid signal switch to that one 
		else if (dvx.videoOutputs[dvDVxSwitcherVideoOutput1.port].inputSelected != DVX_SIGNAL_STATUS_VALID_SIGNAL and
				)
		{
			sendString (0,'switching to good input')
			if (dvxVideoInput.port == dvDvxSwitcherVideoInput9.Port)
			{
				dvxSwitchVideoOnly (dvDvxSwitcherMain, dvDvxSwitcherVideoInput10.Port , dvDvxSwitcherVideoOutput1.Port)
			}
			else if (dvxVideoInput.port == dvDvxSwitcherVideoInput10.Port)
			{
				dvxSwitchVideoOnly (dvDvxSwitcherMain, dvDvxSwitcherVideoInput9.Port , dvDvxSwitcherVideoOutput1.Port)
			}
		}
	}*/
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
		dvx.videoOutputs[output].inputSelected = input

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
	}
}
