PROGRAM_NAME='huddleDXLinkListener'


#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_STATUS_ANALOG_CALLBACK;
#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_STATUS_DIGITAL_CALLBACK;


define_variable

volatile dev dvDxlinkTxDigitalVideoInPorts[1];
volatile dev dvDxlinkTxAnalogVidInPorts[1];


#include 'amx-dxlink-api';
#include 'amx-dxlink-listener';


define_function dxlinkNotifyTxVideoInputStatusAnalog (dev dxlinkTxAnalogVideoInput, char signalStatus[])
{
	if (dxlinkTxAnalogVideoInput == dvTx.NUMBER:DXLINK_PORT_VIDEO_INPUT_ANALOG:dvTx.SYSTEM)
	{
		handleSignalStatusEvent(SOURCE_VGA, signalStatus);
	}
}

define_function dxlinkNotifyTxVideoInputStatusDigital (dev dxlinkTxDigitalVideoInput, char signalStatus[])
{
	if (dxlinkTxDigitalVideoInput == dvTx.NUMBER:DXLINK_PORT_VIDEO_INPUT_DIGITAL:dvTx.SYSTEM)
	{
		handleSignalStatusEvent(SOURCE_HDMI, signalStatus);
	}
}


define_start

dvDxlinkTxDigitalVideoInPorts[1] = dvTx.NUMBER:DXLINK_PORT_VIDEO_INPUT_DIGITAL:dvTx.SYSTEM;
set_length_array(dvDxlinkTxDigitalVideoInPorts, 1);

dvDxlinkTxAnalogVidInPorts[1] = dvTx.NUMBER:DXLINK_PORT_VIDEO_INPUT_ANALOG:dvTx.SYSTEM;
set_length_array(dvDxlinkTxAnalogVidInPorts, 1);

rebuild_event();
