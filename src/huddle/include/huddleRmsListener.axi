program_name='huddleRmsListener'


#define INCLUDE_SCHEDULING_EVENT_STARTED_CALLBACK;
#define INCLUDE_SCHEDULING_EVENT_ENDED_CALLBACK;
#define INCLUDE_SCHEDULING_ACTIVE_UPDATED_CALLBACK;
#define INCLUDE_SCHEDULING_CREATE_RESPONSE_CALLBACK


#include 'RmsAssetLocationTracker';
#include 'RmsApi';
#include 'RmsSchedulingApi';
#include 'RmsSchedulingEventListener';


define_variable

constant integer LOCATION_HUDDLE = 1;
constant integer LOCATION_MEETING = 2;

// As we're using the same physical space for two discreet demo environemnts we
// need to track active bookings for each seperately.
volatile RmsEventBookingResponse activeBookingHuddle;
volatile RmsEventBookingResponse activeBookingMeeting;


define_function RmsEventSchedulingEventStarted(CHAR bookingId[],
		RmsEventBookingResponse eventBookingResponse)
{
	if (eventBookingResponse.location == locationTracker[LOCATION_MEETING].location.id ||
				eventBookingResponse.location == locationTracker[LOCATION_HUDDLE].location.id)
	{
		handleBookingStart(eventBookingResponse);
	}
}

define_function RmsEventSchedulingEventEnded(CHAR bookingId[],
		RmsEventBookingResponse eventBookingResponse)
{
	if (eventBookingResponse.location == locationTracker[LOCATION_MEETING].location.id ||
			eventBookingResponse.location == locationTracker[LOCATION_HUDDLE].location.id)
	{
		handleBookingEnd(eventBookingResponse);
	}
}

define_function RmsEventSchedulingActiveUpdated(CHAR bookingId[],
		RmsEventBookingResponse eventBookingResponse)
{
	if (eventBookingResponse.location == locationTracker[LOCATION_MEETING].location.id)
	{
		activeBookingMeeting = eventBookingResponse;
	}
	else if (eventBookingResponse.location == locationTracker[LOCATION_HUDDLE].location.id)
	{
		// TODO call meetinging ending function so that warning can be displayed
		activeBookingHuddle = eventBookingResponse;
	}
}

define_function RmsEventSchedulingCreateResponse(char isDefaultLocation,
		char responseText[],
		RmsEventBookingResponse eventBookingResponse)
{
	if (eventBookingResponse.location == locationTracker[LOCATION_HUDDLE].location.id &&
			eventBookingResponse.isSuccessful &&
			!isSessionActive());
	{
		// This will only ever fire if a booking is created from wayfinding TP,
		// which only creates bookings for now.
		startSession();
	}
}


define_start

setLocationTrackerAsset(LOCATION_HUDDLE, RmsDevToString(dvRx));
setLocationTrackerAsset(LOCATION_MEETING, RmsDevToString(dvTp));
