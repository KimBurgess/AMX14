program_name='huddleModeroListener'


#define INCLUDE_MODERO_NOTIFY_NFC_TAG_READ;


define_variable

volatile dev dvPanelsNfc[1];


#include 'amx-modero-api';
#include 'amx-modero-listener';


define_function moderoNotifyNfcTagRead(dev panel, char nfcUid[])
{
	if (panel == dvTp && !isSessionActive())
	{
		// For the purposes of this demo any NFC card will be treated as authed.
		// In real world scenarious you can trigger a user auth process form
		// here and call back to handleUserAuth() on success.
		handleUserAuth();
	}
}


define_start

dvPanelsNfc[1] = dvTp;
set_length_array(dvPanelsNfc, 1);

rebuild_event();
