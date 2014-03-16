PROGRAM_NAME='enova-dgx32'


#include 'amx-dgx-api'
#include 'amx-dgx-control'
#include 'amx-dxlink-api'
#include 'amx-dxlink-control'
#include 'amx-modero-api'
#include 'amx-modero-control'

define_device

// Touch Panel
dvTpMain = 10001:1:0

// DGX Switcher
dvDgxSwitcher = 5002:DGX_PORT_SWITCHER:0

// DXLink Fiber Multi-Format Transmitter
dvDxlfMftxMain              = 6001:DXLINK_PORT_MAIN:0
dvDxlfMftxUsb               = 6001:DXLINK_PORT_USB:0
dvDxlfMftxAudioInput        = 6001:DXLINK_PORT_AUDIO_INPUT:0
dvDxlfMftxVideoInputDigital = 6001:DXLINK_PORT_VIDEO_INPUT_DIGITAL:0
dvDxlfMftxVideoInputAnalog  = 6001:DXLINK_PORT_VIDEO_INPUT_DIGITAL:0

// DXLink Fiber Receiver
dvDxlfRxMain        = 7001:DXLINK_PORT_MAIN:0
dvDxlfRxUsb         = 7001:DXLINK_PORT_USB:0
dvDxlfRxAudioOutput = 7001:DXLINK_PORT_AUDIO_OUTPUT:0
dvDxlfRxVideoOutput = 7001:DXLINK_PORT_VIDEO_OUTPUT:0


define_constant

// DGX inputs
integer DGX_INPUT_SIGNAGE           = 1
integer DGX_INPUT_BLURAY            = 2
integer DGX_INPUT_LAPTOP_FIBER_TX   = 5
integer DGX_INPUT_SIGNAGE_REMOVABLE = 9

// DGX outputs
integer DGX_OUTPUT_DVX_1_FEED_1     = 1
integer DGX_OUTPUT_DVX_2_FEED_1     = 2
integer DGX_OUTPUT_DVX_1_FEED_2     = 5
integer DGX_OUTPUT_DVX_2_FEED_2     = 6
integer DGX_OUTPUT_MONITOR_FIBER_RX = 9
integer DGX_OUTPUT_ENCODER          = 13
integer DGX_OUTPUT_MONITOR_DIRECT   = 14



define_variable

// Modero Listener Dev Array for Listening to button events
dvPanelsButtons[] = { dvTpMain }



// Override Callback function from Moder Listener to track button pushes
#define INCLUDE_MODERO_NOTIFY_BUTTON_PUSH
define_function moderoNotifyButtonPush (dev panel, integer btnChanCde)
{
	// panel is the touch panel
	// btnChanCde is the button channel code
	
	if (panel == dvTpMain)
	{
		
	}
}



define_event

data_event [dvDxlfMftxMain]
data_event [dvDxlfMftxUsb]
data_event [dvDxlfMftxAudioInput]
data_event [dvDxlfMftxVideoInputDigital]
data_event [dvDxlfMftxVideoInputAnalog]
{
	online:
	{
	}
}

data_event [dvDxlfRxMain]
data_event [dvDxlfRxUsb]
data_event [dvDxlfRxAudioOutput]
data_event [dvDxlfRxVideoOutput]
{
	online:
	{
	}
}

data_event [dvDgxSwitcher]
{
	online:
	{
	}
}




#include 'amx-dgx-listener'
#include 'amx-dxlink-listener'
#include 'amx-modero-listener'