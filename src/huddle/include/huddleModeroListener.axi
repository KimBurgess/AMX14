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
		// TODO auth user
		// TODO request booking via RMS if it is online, if offline just start up the room
		startSession();
	}
}


define_start

dvPanelsNfc[1] = dvTp;
set_length_array(dvPanelsNfc, 1);

rebuild_event();
