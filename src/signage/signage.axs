program_name='signage'


#define INCLUDE_SCHEDULING_NEXT_ACTIVE_UPDATED_CALLBACK
#define INCLUDE_SCHEDULING_EVENT_ENDED_CALLBACK


define_device

dvUpperPlayer = 0:2:0;
dvLowerPlayer = 0:3:0;

dvTpCto = 10001:1:0;
dvTpUi = 10002:1:0;
dvTpRms = 10003:1:0;
dvTpEnova = 10004:1:0;
vdvHuddleTracker = 33001:1:0;

vdvRms = 41001:1:0;



#include 'signageControl';
#include 'RmsSchedulingApi';
#include 'RmsSchedulingEventListener';
#include 'RmsAssetLocationTracker';


define_type

structure attendeeGroup
{
	char bookingKey[64];
	char colour[16];
}

structure eventLocation
{
	char locationTrackerId
	char arrow[50];
}


define_variable

constant char GROUP_COUNT = 5;
constant char LOCATION_COUNT = 5;

volatile attendeeGroup groups[5];

volatile eventLocation locations[5];


define_function init()
{
	groups[1].key = 'Orange';
	groups[1].colour = xpressPlayerGroupOrangeColor;

	groups[2].key = 'Green';
	groups[2].colour = xpressPlayerGroupGreenColor;

	groups[3].key = 'Purple';
	groups[3].colour = xpressPlayerGroupPurpleColor;

	groups[4].key = 'Yellow';
	groups[4].colour = xpressPlayerGroupYellowColor;

	groups[5].key = 'Blue';
	groups[5].colour = xpressPlayerGroupBlueColor;

	
	setLocationTrackerAsset(1, RmsDevToString(dvTpCto));
	location[1].locationTrackerId = 1;
	location[1].arrow = xpressPlayerCTOvariableNameToUpdate;
	
	setLocationTrackerAsset(2, RmsDevToString(dvTpUi));
	location[2].locationTrackerId = 2;
	location[2].arrow = xpressPlayerCTOvariableNameToUpdate;
	
	setLocationTrackerAsset(3, RmsDevToString(dvTpRms));
	location[3].locationTrackerId = 3;
	location[3].arrow = xpressPlayerCTOvariableNameToUpdate;
	
	setLocationTrackerAsset(4, RmsDevToString(dvTpEnova));
	location[4].locationTrackerId = 4;
	location[4].arrow = xpressPlayerCTOvariableNameToUpdate;
	
	setLocationTrackerAsset(5, RmsDevToString(vdvHuddleTracker));
	location[5].locationTrackerId = 5;
	location[5].arrow = xpressPlayerCTOvariableNameToUpdate;
}

define_function char[50] getColourFromBookingName(char bookingName)
{
	stack_var integer i;

	for (i = GROUP_COUNT; i; i--)
	{
		if (find_string(bookingName, lower_string(groups[i].bookingKey), 1))
		{
			return groups[i].colour;
		}
	}

	return xpressPlayerGroupNone;
}

define_function char[50] getArrowFromLocationId(integer locationId)
{
	stack_var integer i;
	
	for (i = LOCATION_COUNT; i; i--)
	{
		if (locationTracker[locations[i].locationTrackerId].location.id == locationId)
		{
			return locations
		}
	}
}


// RMS Callbacks

define_function RmsEventSchedulingNextActiveUpdated(CHAR bookingId[],
		RmsEventBookingResponse eventBookingResponse)
{
	if (eventBookingResponse.minutesUntilStart < 5)
	{
		stack_var integer i;

		for (i = MAX_LOCATIONS; i; i--)
		{
			if (eventBookingResponse[i].location.id == locationTracker[i].location.id)
			{
				upadetArrowColor(location[i], getColourFromBookingName(eventBookingResponse.name));
			}
		}
	}
}

define_function RmsEventSchedulingEventEnded(CHAR bookingId[],
		RmsEventBookingResponse eventBookingResponse)
{

}




define_start

init();
