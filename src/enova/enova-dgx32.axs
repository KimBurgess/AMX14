PROGRAM_NAME='enova-dgx32'


define_device

// Touch Panel
dvTpMain = 10001:1:0

// DGX Switcher
dvDgxSwitcher = 5002:2:0

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