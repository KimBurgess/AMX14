program_name='huddle'


define_device

// Shared Devices
dvSystem = 0:1:0;
dvIO = 5001:4:0;
vdvRms = 41001:1:0;

// Central wayfinding panel
dvWayfindingTp = 10002:1:0;

// Basic huddle
vdvHuddle1Display = 41501:1:0;
dvHuddle1Tx = 7001:1:0;
dvHuddle1Rx = 8001:1:0;
dvHuddle1Enzo = 20001:1:0;
dvHuddle1Tp = 10001:1:0;


define_variable
// Within this demo the IO ports on the NI-700 are being used for the sake of
// simplicity. If this were to be deployed into a live environment there are a
// number of IO -> RS232 devices available that can be attached to the RS-232
// port available on the DXLink transmitter. This will allow you to have a
// single category cable run to the table and centrally located controller.
volatile devchan dcHuddle1Btn = {dvIO, 1};
volatile devchan dcHUddle1BtnFb = {dvIO, 2};

volatile integer huddleLocationIds[] = {2};


define_module

// Each huddle in the space uses it's own huddleController module instance. This
// handles all devices interaction, registration of devices with RMS, individual
// huddle UI etc. Although we're only showing a single huddle here this system
// can expand to accomodate multiple huddles running from a single NI-700.
// Simply instatiate a huddleController for each.
'huddleController' mdlHuddle1(vdvRMS, vdvHuddle1Display, dvHuddle1Enzo,
		dvHuddle1Rx, dvHuddle1Tx, dcHuddle1Btn, dcHuddle1BtnFb, dvHuddle1Tp);

'huddleFinder' mdlHuddleFinder(vdvRms, dvWayfindingTp, huddleLocationIds);

// Display module instantiation is intentially done here rather than within the
// huddleController module so that we can use the same huddle interaction logic
// regardless of the display in use.
'Samsung_MD55C_Comm_dr1_0_0' mdlHuddle1Display(vdvHuddle1Display, dvHuddle1Rx);

// RMS our central devices.
'RmsNetLinxAdapter_dr4_0_0' mdlRms(vdvRms);
'RmsControlSystemMonitor' mdlRmsControlSys(vdvRms, dvSystem);
'RmsTouchPanelMonitor' mdlRmsWayfindingTp(vdvRms, dvWayfindingTp);
