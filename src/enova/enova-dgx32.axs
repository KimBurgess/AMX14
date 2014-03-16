PROGRAM_NAME='enova-dgx32'

include 'amx-dxlink-api'

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
integer dgxInputSignage          = 1
integer dgxInputBluray           = 2
integer dgxInputLaptopFiberTx    = 5
integer dgxInputSignageRemovable = 9

// DGX outputs
integer dgxOutputDvx1Feed1      = 1
integer dgxOutputDvx2Feed1      = 2
integer dgxOutputDvx1Feed2      = 5
integer dgxOutputDvx2Feed2      = 6
integer dgxOutputMonitorFiberRx = 9
integer dgxOutputEncoder        = 13
integer dgxOutputMonitorDirect  = 14


define_event


data_event[dvDxlfMftxMain]
data_event [dvDxlfMftxUsb]
data_event[dvDxlfMftxAudioInput]
data_event[dvDxlfMftxVideoInputDigital]
data_event[dvDxlfMftxVideoInputAnalog]
{
	command:
	{
	}
}

data_event[dvDxlfRxMain]
data_event[dvDxlfRxUsb]
data_event[dvDxlfRxAudioOutput]
data_event[dvDxlfRxVideoOutput]
{
	command:
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