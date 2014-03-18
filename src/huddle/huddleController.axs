module_name='huddleController'(dev vdvComm, dev vdvRMS, dev vdvDisplay,
		dev dvEnzo, dev dvRXMonitor, dev dvTXTable, devchan dcButton,
		devchan dcButtonFb)


#define INCLUDE_CONTROLPORTS_NOTIFY_IO_INPUT_ON_CALLBACK;
#define INCLUDE_CONTROLPORTS_NOTIFY_IO_INPUT_OFF_CALLBACK;
#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_STATUS_ANALOG_CALLBACK;
#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_STATUS_DIGITAL_CALLBACK;


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

constant char NUM_SOURCES = 3;

volatile SignalSource source[NUM_SOURCES];

volatile char activeSource;

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
#include 'amx-enzo-api';
#include 'amx-enzo-control';
#include 'amx-enzo-listener';
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
define_function char[32] getSourceName(char sourceId)
{
	return source[sourceId].name;
}

/**
 * Sets the human readable name associated with a source ID.
 */
define_function setSourceName(char sourceId, char name[32])
{
	log(AMX_DEBUG, "'Associating source ID', itoa(sourceId), ' with ', name");
	source[sourceId].name = name;
}

/**
 * Check the availability (aka input status) of a source id.
 */
define_function char isSourceAvailable(char sourceId)
{
	return source[sourceId].isAvailable;
}

/**
 * Sets the source available for consideration during switching requests.
 */
define_function setSourceAvailable(char sourceId, char isAvailable)
{
	log(AMX_DEBUG, "'Setting availability state of ', getSourceName(sourceId),
			' ', bool_to_string(isAvailable)");

	source[sourceId].isAvailable = isAvailable;

	updateButtonFeedbackState();
}

/**
 * Gets the number of sources currently available for selection.
 */
define_function char getAvailableSourceCount()
{
	stack_var char i;
	stack_var char count;

	count = 0;
	for (i = NUM_SOURCES; i; i--)
	{
		if (isSourceAvailable(i))
		{
			count = count + 1;
		}
	}

	return count;
}

/**
 * Set the active system source.
 */
define_function setActiveSource(char sourceId)
{
	log(AMX_INFO, "'Selecting ', getSourceName(sourceId), ' as system source'");

	setDisplaySource(sourceId);

	if (sourceId == SOURCE_ENZO)
	{
		enzoBlankingHide(dvEnzo);
	}
	else
	{
		enzoBlankingShow(dvEnzo, true);
	}

	activeSource = sourceId;

	updateButtonFeedbackState();
}

/**
 * Gets the currently active system source.
 */
define_function char getActiveSource()
{
	return activeSource;
}

/**
 * Sets the source to be output to the room display.
 */
define_function setDisplaySource(char sourceId)
{
	log(AMX_INFO, "'Switching to ', getSourceName(sourceId)");

	switch (sourceId)
	{
		case SOURCE_ENZO:
		{
			// TODO select correct input on display
		}
		case SOURCE_HDMI:
		{
			dxlinkSetTxVideoInputDigital(dvTxTableMain);
			// TODO select correct input on display
		}
		case SOURCE_VGA:
		{
			dxlinkSetTxVideoInputAnalog(dvTxTableMain);
			// TODO select correct input on display
		}
	}
}

/**
 * Selects the next available source.
 */
define_function cycleActiveSource()
{
	stack_var char nextSource;
	nextSource = activeSource + 1;
	while(!isSourceAvailable(nextSource))
	{
		nextSource = nextSource + 1
		if (nextSource > NUM_SOURCES) {
			nextSource = 1;
		}
	}

	setActiveSource(nextSource);
}

/**
 * Sets the button feedback to display for the appropriate system state.
 */
define_function updateButtonFeedbackState()
{
	setButtonFeedback((getAvailableSourceCount() > 1) || (getActiveSource() != SOURCE_ENZO));
}

/**
 * Sets the pushbutton feedback state.
 */
define_function setButtonFeedback(char isOn)
{
	log(AMX_DEBUG, "'Setting button feedback ', bool_to_string(isOn)");

	[dcButtonFb] = isOn;
}

/**
 * Handle a change to the pushbutton state.
 */
define_function handlePushbuttonEvent(char isPushed)
{
	log(AMX_DEBUG, "'pushbutton event [', bool_to_string(isPushed), ']'");

	if (isPushed)
	{
		cancel_wait 'signal returned';
		cycleActiveSource();
	}
}

/**
 * Handle an update to the detected signal status of one of our system sources.
 */
define_function handleSignalStatusEvent(char sourceId, char signalStatus[])
{
	log(AMX_DEBUG, "'Signal event for ', getSourceName(sourceId), ' [',
			signalStatus, ']'");

	setSourceAvailable(sourceId, signalStatus == DXLINK_SIGNAL_STATUS_VALID_SIGNAL);

	// If signal drops from the active source (e.g. laptop is unplugged or goes
	// to sleep throw up an alert using Enzo.
	if (signalStatus == DXLINK_SIGNAL_STATUS_NO_SIGNAL &&
			sourceId == activeSource)
	{
		log(AMX_INFO, 'Signal lost from active source');

		enzoAlert(dvEnzo,
				'Please reconnect your device to continue presenting.',
				ENZO_ALERT_TYPE_INFORMATION,
				'Device Disconnected',
				false,
				10);
		setDisplaySource(SOURCE_ENZO);
		wait_until (isSourceAvailable(getActiveSource())) 'signal returned'
		{
			log(AMX_DEBUG, 'Signal to active source returned. Switching back to display');
			setDisplaySource(getActiveSource());
			enzoAlertClose(dvEnzo);
		}
	}
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
