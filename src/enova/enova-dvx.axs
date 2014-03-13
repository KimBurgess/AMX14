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

dev dvDvxVidInPorts[] = { dvDvxSwitcherVideoInput9, dvDvxSwitcherVideoInput10 }

#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_STATUS_CALLBACK
define_function dvxNotifyVideoInputStatus (dev dvxVideoInput, char signalStatus[])
{
	
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// signalStatus is the input signal status (DVX_SIGNAL_STATUS_NO_SIGNAL | DVX_SIGNAL_STATUS_UNKNOWN | DVX_SIGNAL_STATUS_VALID_SIGNAL)

sendString (0, "'[',itoa(dvxVideoInput.Number),':',itoa(dvxVideoInput.Port),':',itoa(dvxVideoInput.System),'] ',signalStatus")

}


include 'amx-dvx-listener'

