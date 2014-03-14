module_name='huddleController'(dev vdvComm, dev vdvRMS, dev vdvDisplay,
		dev dvEnzo, dev dvRXMonitor, dev dvTXTable, devchan dcButton)


#include 'common';
#include 'util';
#include 'amx-device-control';
#include 'amx-controlports-api';
#include 'amx-controlports-control';
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
 * Map our device variables used internally to the appropriatevdevices passed
 * into this instance of the huddle controller.
 *
 * Note: this should be called from define_start only.
 */
define_function mapDevices() {
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
}


define_start

mapDevices();