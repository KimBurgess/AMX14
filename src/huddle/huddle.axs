program_name='huddle'


#include 'common';
#include 'amx-device-control';
#include 'amx-controlports-api';
#include 'amx-controlports-control';
#include 'amx-modero-api';
#include 'amx-modero-control';


define_device

// Shared Devices
dvSystem = 0:1:0;
vdvRMS = 41001:1:0;
dvWayfindingPanel = 10002:2:0;
dvIO = 5001:4:0;

// Huddle Specific
vdvHuddle1Display = 41501:1:0;
dvHuddle1Tx = 7001:1:0;
dvHuddle1Rx = 8001:1:0;
dvHuddle1Tp = 10001:1:0;
dvHuddle1SchedulingTp = 10002:1:0;
dvHuddle1Enzo = 20001:1:0;
// ...
// Although we're only showing a single huddle here this system can expand to
// accomodate multiple huddles running from a single NI-700. The only addition
// you may want to make is to utilise EXB boxes to provide additional IO ports
// for in table push buttons.


define_variable

volatile devchan dcHuddle1Btn = {dvIO, 1};
volatile devchan dcHUddle1BtnFb = {dvIO, 2};


// Display module instantiation is intentially done here rather than within the
// huddleController module so that we can use the same huddle interaction logic
// regardless of the display in use.
define_module 'Samsung_MD55C_Comm_dr1_0_0' mdlHuddle1Display(vdvHuddle1Display, dvHuddle1Rx);

// Each huddle in the space uses it's own huddleController module instance. This
// handles all devices interaction, registration of devices with RMS, individual
// huddle UI etc.
define_module 'huddleController' mdlHuddle1(vdvRMS, vdvHuddle1Display,
		dvHuddle1Enzo, dvHuddle1Rx, dvHuddle1Tx, dcHuddle1Btn, dcHuddle1BtnFb);
