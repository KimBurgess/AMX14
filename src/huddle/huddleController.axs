module_name='huddleController'(dev vdvComm, dev vdvRMS, dev vdvDisplay,
		dev dvEnzo, dev dvRXMonitor, dev dvTXTable, devchan dcButton)


#define INCLUDE_CONTROLPORTS_NOTIFY_IO_INPUT_ON_CALLBACK;
#define INCLUDE_CONTROLPORTS_NOTIFY_IO_INPUT_OFF_CALLBACK;
#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_STATUS_ANALOG_CALLBACK
#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_STATUS_DIGITAL_CALLBACK


define_type

structure SignalSource
{
	char name[32];
	char isAvailable;
}


define_variable

constant char SOURCE_ENZO = 1;
constant char SOURCE_HDMI = 2;
constant char SOURCE_VGA = 3;

volatile SignalSource source[3];

// As we can only use define_device to declare devices based on constant value,
// rather than those passed in at runtime we need to be a little 'non standard'
// here. Devices used internally are declared below and mapped to appropriate
// value during module instantiation.

// DXLinx Receiver for monitor
volatile dev dvRxMonitorMain;
volatile dev dvRxMonitorSerial;

// DXLinx Multi-Format transmitter underneath table
volatile dev dvTxTableMain;
volatile dev dvTxTableVidInDigital;
volatile dev dvTxTableVidInAnalog;

// Device arrays for listeners
volatile dev dvIoPorts[1];
volatile dev dvDxlinkTxDigitalVideoInPorts[1];
volatile dev dvDxlinkTxAnalogVidInPorts[1];


#include 'logger';
#include 'string';
#include 'common';
#include 'util';
#include 'amx-device-control';
#include 'amx-controlports-api';
#include 'amx-controlports-control';
#include 'amx-controlports-listener';
#include 'amx-dxlink-api';
#include 'amx-dxlink-control';
#include 'amx-dxlink-listener';
#include 'amx-modero-api';
#include 'amx-modero-control';
#include 'amx-modero-listener';


/**
 * Initialises module state on startup.
 */
define_function init()
{
	setLogPrefix("'huddleController[', itoa(vdvComm.NUMBER), ']'");
	log(AMX_DEBUG, 'Initialising module');

	mapDevices();

	configSources();
}

/**
 * Set up system source information.
 */
define_function configSources() {
	setSourceName(SOURCE_ENZO, 'Enzo');
	setSourceAvailable(SOURCE_ENZO, true);

	setSourceName(SOURCE_HDMI, 'HDMI input');
	setSourceAvailable(SOURCE_HDMI, false);

	setSourceName(SOURCE_VGA, 'VGA input');
	setSourceAvailable(SOURCE_VGA, false);
}

/**
 * Map our device variables used internally to the appropriate devices passed
 * into this instance of the huddle controller.
 */
define_function mapDevices()
{
	log(AMX_DEBUG, 'Mapping devices...');

	dvRxMonitorMain = dvRXMonitor;
	dvRxMonitorSerial = dvRXMonitor.NUMBER:DXLINK_PORT_SERIAL:dvRXMonitor.SYSTEM;

	dvTxTableMain = dvTxTable;
	dvTxTableVidInDigital = dvTXTable.NUMBER:DXLINK_PORT_VIDEO_INPUT_DIGITAL:dvTXTable.SYSTEM;
	dvTxTableVidInAnalog = dvTXTable.NUMBER:DXLINK_PORT_VIDEO_INPUT_ANALOG:dvTXTable.SYSTEM;

	dvIoPorts[1] = dcButton.DEVICE;
	set_length_array(dvIoPorts, 1);

	dvDxlinkTxDigitalVideoInPorts[1] = dvTxTableVidInDigital;
	set_length_array(dvDxlinkTxDigitalVideoInPorts, 1);

	dvDxlinkTxAnalogVidInPorts[1] = dvTxTableVidInAnalog;
	set_length_array(dvDxlinkTxAnalogVidInPorts, 1);

	rebuild_event();

	log(AMX_INFO, 'Device mapping complete');
}

/**
 * Get the human readable name associated with a source.
 */
define_function char[32] getSourceName(char sourceId) {
	return source[sourceId].name;
}

/**
 * Sets the human readable name associated with a source ID.
 */
define_function setSourceName(char sourceId, char name[32]) {
	log(AMX_DEBUG, "'Associating source ID', itoa(sourceId), ' with ', name");
	source[sourceId].name = name;
}

/**
 * Check the availability (aka input status) of a source id.
 */
define_function char isSourceAvailable(char sourceId) {
	return source[sourceId].isAvailable;
}

/**
 * Sets the source available for consideration during switching requests.
 */
define_function setSourceAvailable(char sourceId, char isAvailable) {
	log(AMX_DEBUG, "'Setting availability state of ', getSourceName(sourceId),
			bool_to_string(isAvailable)");
	source[sourceId].isAvailable = isAvailable;
}

/**
 * Set the active system source.
 */
define_function setActiveSource(char sourceId) {
	log(AMX_INFO, "'Selecting ', getSourceName(sourceId), ' as system source'");


}

/**
 * Handle a change to the pushbutton state.
 */
define_function handlePushbuttonEvent(char isPushed)
{
	log(AMX_DEBUG, "'pushbutton event [', bool_to_string(isPushed), ']'");

	if (isPushed) {

	}
}

/**
 * Handle an update to the detected signal status of one of our system sources.
 */
define_function handleSignalStatusEvent(char sourceId, char signalStatus[])
{
	log (AMX_DEBUG, "'signal event for ', getSourceName(sourceId), ' [',
			signalStatus, ']'");

	setSourceAvailable(sourceId, signalStatus == DXLINK_SIGNAL_STATUS_VALID_SIGNAL);
}


// AMX control ports callbacks

define_function amxControlPortNotifyIoInputOn (dev ioPort, integer ioChanCde)
{
	if (ioPort == dcButton.device && ioChanCde == dcButton.channel)
	{
		handlePushbuttonEvent(true);
	}
}

define_function amxControlPortNotifyIoInputOff (dev ioPort, integer ioChanCde)
{
	if (ioPort == dcButton.device && ioChanCde == dcButton.channel)
	{
		handlePushbuttonEvent(false);
	}
}


// DXLink trasmitter callbacks

define_function dxlinkNotifyTxVideoInputStatusAnalog (dev dxlinkTxAnalogVideoInput, char signalStatus[])
{
	if (dxlinkTxAnalogVideoInput == dvTxTableVidInAnalog)
	{
		handleSignalStatusEvent(SOURCE_VGA, signalStatus);
	}
}

define_function dxlinkNotifyTxVideoInputStatusDigital (dev dxlinkTxDigitalVideoInput, char signalStatus[])
{
	if (dxlinkTxDigitalVideoInput == dvTxTableVidInDigital)
	{
		handleSignalStatusEvent(SOURCE_HDMI, signalStatus);
	}
}


define_event

data_event[vdvComm]
{

	command:
	{
		stack_var char cmd[128];
		stack_var char params[8][256];
		stack_var integer paramCount;

		cmd = upper_string(string_get_key(data.text, '-'));
		paramCount = explode(',', string_get_value(data.text, '-'), params, 0);
		set_length_array(params, paramCount);

		log(AMX_DEBUG, "'Incoming data from comm device: {cmd: ', cmd, ' params:[',
			implode(params, ','), ']}'");
	}

}

data_event[dvTxTableMain]
{

	online:
	{
		dxlinkDisableTxVideoInputAutoSelect(data.device);
	}

}

data_event[dcButton.device]
{

	online:
	{
		amxIoSetInputState(dcButton.device, dcButton.channel, IO_ACTIVE_STATE_LOW);
	}

}


define_start

init();
