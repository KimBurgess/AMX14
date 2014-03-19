program_name='huddleRmsListener'


#define INCLUDE_SCHEDULING_EVENT_STARTED_CALLBACK;
#define INCLUDE_SCHEDULING_EVENT_ENDED_CALLBACK


#include 'RmsAssetLocationTracker';
#include 'RmsApi';
#include 'RmsSchedulingApi';
#include 'RmsSchedulingEventListener';


define_function RmsEventSchedulingEventStarted(CHAR bookingId[],
		RmsEventBookingResponse eventBookingResponse)
{
	if (eventBookingResponse.location == locationTracker.location.id)
	{
		handleBookingStart(eventBookingResponse);
	}
}

define_function RmsEventSchedulingEventEnded(CHAR bookingId[],
		RmsEventBookingResponse eventBookingResponse)
{
	if (eventBookingResponse.location == locationTracker.location.id)
	{
		handleBookingEnd(eventBookingResponse);
	}
}


define_event

// To enable this physical space to provide to discreet demo experience for
// AMX14 the touch panel is placed in it's own location (with a different
// resource calendar) on the RMS server. This then simply remaps our internals
// the appropriate location depending on what's plugged in.
data_event[dvTp]
{

	online:
	{
		setLocationTrackerAsset(RmsDevToString(data.device));
	}

	offline:
	{
		setLocationTrackerAsset(RmsDevToString(dvRx));
	}

}

define_start

setLocationTrackerAsset(RmsDevToString(dvRx));