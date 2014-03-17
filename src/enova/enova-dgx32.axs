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
dvDgxSwitcherDiagnotsics = 5002:DGX_PORT_DIAGNOSTICS:0

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

// Touch panel button channel codes
integer BTN_RESET_DEMO = 1

integer BTN_SOURCE_SIGNAGE_DGX32_ONLY     = 11
integer BTN_SOURCE_BLURAY                 = 12
integer BTN_SOURCE_LAPTOP                 = 13
integer BTN_SOURCE_SIGNAGE_DGX32_AND_DGX8 = 14

integer BTN_DESTINATION_DVX_1            = 21
integer BTN_DESTINATION_DVX_2            = 22
integer BTN_DESTINATION_MONITOR_RECEIVER = 23
integer BTN_DESTINATION_H264_ENCODER     = 24
integer BTN_DESTINATION_MONITOR_LOCAL    = 25


define_variable

// Modero Listener Dev Array for Listening to button events
dev dvPanelsButtons[] = { dvTpMain }

char ipAddressDxlfTx[15]
char ipAddressDxlfRx[15]

// Override Callback function from Moder Listener to track button pushes
#define INCLUDE_MODERO_NOTIFY_BUTTON_PUSH
define_function moderoNotifyButtonPush (dev panel, integer btnChanCde)
{
	// panel is the touch panel
	// btnChanCde is the button channel code
	
	if (panel == dvTpMain)
	{
		switch (btnChanCde)
		{
			case BTN_RESET_DEMO:
			{
				dgxEnableSwitch (dvDgxSwitcher, 0, DGX_INPUT_SIGNAGE, DGX_OUTPUT_DVX_1_FEED_1)
				dgxEnableSwitch (dvDgxSwitcher, 0, DGX_INPUT_SIGNAGE, DGX_OUTPUT_DVX_1_FEED_2)
				dgxEnableSwitch (dvDgxSwitcher, 0, DGX_INPUT_SIGNAGE, DGX_OUTPUT_DVX_2_FEED_1)
				dgxEnableSwitch (dvDgxSwitcher, 0, DGX_INPUT_SIGNAGE, DGX_OUTPUT_DVX_2_FEED_2)
				dgxEnableSwitch (dvDgxSwitcher, 0, DGX_INPUT_SIGNAGE, DGX_OUTPUT_ENCODER)
				dgxEnableSwitch (dvDgxSwitcher, 0, DGX_INPUT_SIGNAGE, DGX_OUTPUT_MONITOR_DIRECT)
				dgxEnableSwitch (dvDgxSwitcher, 0, DGX_INPUT_SIGNAGE, DGX_OUTPUT_MONITOR_FIBER_RX)
			}
		}
	}
}



define_event

data_event [dvDxlfMftxUsb]
{
	online:
	{
		ipAddressDxlfTx = data.sourceip
		dxlinkEnableTxUsbHidService (dvDxlfMftxUsb)
		
		if (device_id(dvDxlfRxUsb))
			dxlinkSetRxUsbHidRoute (dvDxlfRxUsb,ipAddressDxlfTx)
	}
}

data_event [dvDxlfRxUsb]
{
	online:
	{
		if (device_id(dvDxlfMftxUsb))
			dxlinkSetRxUsbHidRoute (dvDxlfRxUsb,ipAddressDxlfTx)
	}
}

data_event [dvDgxSwitcher]
data_event [dvDgxSwitcherDiagnotsics]
{
	online:
	{
	}
	command:
	{
	}
	string:
	{
	}
}




#include 'amx-dgx-listener'
#include 'amx-dxlink-listener'
#include 'amx-modero-listener'