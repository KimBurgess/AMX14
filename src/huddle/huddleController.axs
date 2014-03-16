module_name='huddleController'(dev vdvComm, dev vdvRMS, dev vdvDisplay,
		dev dvEnzo, dev dvRXMonitor, dev dvTXTable, devchan dcButton)


#define INCLUDE_CONTROLPORTS_NOTIFY_IO_INPUT_ON_CALLBACK;
#define INCLUDE_CONTROLPORTS_NOTIFY_IO_INPUT_OFF_CALLBACK;


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
#include 'amx-modero-api';
#include 'amx-modero-control';


define_variable

// As we can only use define_device to declare devices based on constant value,
// rather than those passed in at runtime we need to be a little 'non standard'
// here. Devices used internally are declared below and mapped to appropriate
// value during module instantiation (define_start).

// DXLinx Receiver for monitor
volatile dev dvRxMonitorMain;
volatile dev dvRxMonitorSerial;
volatile dev dvRxMonitorVidOut;
volatile dev dvRxMonitorAudOut;

// DXLinx Multi-Format transmitter underneath table
volatile dev dvTxTableMain;
volatile dev dvTxTableVidInDigital;
volatile dev dvTxTableVidInAnalog;
volatile dev dvTxTableAudIn;

// Button IO
volatile dev dvIoPorts[1];


/**
 * Initialises module state on startup.
 */
define_function init() {
	setLogPrefix("'huddleController[', itoa(vdvComm.NUMBER), ']'");
	log(AMX_DEBUG, 'Initialising module');
	mapDevices();
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
	dvRxMonitorVidOut = dvRXMonitor.NUMBER:DXLINK_PORT_VIDEO_OUTPUT:dvRXMonitor.SYSTEM;
	dvRxMonitorAudOut = dvRXMonitor.NUMBER:DXLINK_PORT_AUDIO_OUTPUT:dvRXMonitor.SYSTEM;

	dvTxTableMain = dvTxTable;
	dvTxTableVidInDigital = dvTXTable.NUMBER:DXLINK_PORT_SERIAL:dvTXTable.SYSTEM;
	dvTxTableVidInAnalog = dvTXTable.NUMBER:DXLINK_PORT_VIDEO_OUTPUT:dvTXTable.SYSTEM;
	dvTxTableAudIn = dvTXTable.NUMBER:DXLINK_PORT_AUDIO_OUTPUT:dvTXTable.SYSTEM;

	dvIoPorts[1] = dcButton.DEVICE;
	set_length_array(dvIoPorts, 1);

	rebuild_event();

	log(AMX_INFO, 'Device mapping complete');
}

/**
 * Handle incoming command data on our comm device.
 */
define_function handleCommRx(char cmd[], char params[][])
{
	log(AMX_DEBUG, "'Incoming data from comm device: {cmd: ', cmd, ' params:[',
			implode(params, ','), ']}'");
}

/**
 * Handle a change to the pushbutton state.
 */
define_function handlePushbuttonEvent(char isPushed) {
	log(AMX_DEBUG, "'pushbutton event [', bool_to_string(isPushed), ']'");

	if (isPushed) {

	}
}


// AMX control ports callbacks

define_function amxControlPortNotifyIoInputOn (dev ioPort, integer ioChanCde)
{
	if (ioPort == dcButton.device && ioChanCde == dcButton.channel) {
		handlePushbuttonEvent(true);
	}
}

define_function amxControlPortNotifyIoInputOff (dev ioPort, integer ioChanCde)
{
	if (ioPort == dcButton.device && ioChanCde == dcButton.channel) {
		handlePushbuttonEvent(false);
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

		handleCommRx(cmd, params);
	}

}


define_start

init();
