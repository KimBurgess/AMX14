module_name='huddleFinder'(dev vdvRms, dev dvTp, integer locationIds[])


#define INCLUDE_SCHEDULING_ACTIVE_UPDATED_CALLBACK
#define INCLUDE_SCHEDULING_NEXT_ACTIVE_UPDATED_CALLBACK
#define INCLUDE_SCHEDULING_EVENT_ENDED_CALLBACK
#define INCLUDE_SCHEDULING_EVENT_STARTED_CALLBACK


#include 'amx-modero-control';
#include 'RmsApi';
#include 'RmsEventListener';
#include 'RmsSchedulingApi';
#include 'RmsSchedulingEventListener';


define_type

structure huddleSpace {
	integer locationId;
	char inUse;
	RmsEventBookingResponse activeBooking;
	RmsEventBookingResponse nextBooking;
}


define_variable

// Maximum number of supported huddle space - increase this to match your
// deployment requirements.
constant integer MAX_HUDDLE_SPACES = 1;

constant long MAX_TIME = $ffffffff;

// Button addresses
constant integer BTN_FIND_WORKSPACE = 1;
constant integer BTN_RESERVE = 2;
constant integer BTN_MINUTES_UNTIL_AVAILABLE = 4;
constant integer BTN_TIME_SELECT[] = {5, 6, 7, 8};

// Options available for 'meet now' and 'book next' inital meeting lengths
constant integer BOOKING_REQUEST_LENGTHS[] = {10, 20, 30, 60};

volatile huddleSpace trackedSpaces[MAX_HUDDLE_SPACES];

volatile integer bookingRequestLength;


/**
 * Initialises this module. This should only be called from within define_start.
 */
define_function init()
{
	stack_var integer i;
	for (i = min_value(MAX_HUDDLE_SPACES, length_array(locationIds)); i; i--)
	{
		trackedSpaces[i].locationId = locationIds[i];
		trackedSpaces[i].nextBooking.minutesUntilStart = MAX_TIME;
	}
}

/**
 * Gets the ID of the tracked huddle with the longest available time until the
 * next booking.
 */
define_function integer getLongestAvailableHuddle()
{
	stack_var integer i;
	stack_var integer longestAvailable;

	longestAvailable = 1;

	for (i = MAX_HUDDLE_SPACES; i; i--)
	{
		if (!trackedSpaces[i].inUse &&
				trackedSpaces[i].nextBooking.minutesUntilStart > trackedSpaces[longestAvailable].nextBooking.minutesUntilStart)
		{
			longestAvailable = i;
		}
	}

	return longestAvailable;
}

/**
 * Get the index of the next huddle space set to become available.
 */
define_function integer getNextAvailableHuddle()
{
	stack_var integer i;
	stack_var integer nextAvailable;

	nextAvailable = 1;

	for (i = MAX_HUDDLE_SPACES; i; i--)
	{

		if (trackedSpaces[i].inUse &&
				trackedSpaces[i].activeBooking.remainingMinutes < trackedSpaces[nextAvailable].activeBooking.remainingMinutes)
		{
			nextAvailable = i;
		}
	}

	return nextAvailable;
}

/**
 * Sets the active state of a button and adjust the opacity accordingly.
 */
define_function setButtonSelectable(integer address, isSelectable)
{
	if (isSelectable)
	{
		moderoEnableButtonPushes(dvTp, address);
		moderoSetButtonOpacity(dvTp, address, MODERO_BUTTON_STATE_ALL, 255);
	}
	else
	{
		moderoDisableButtonPushes(dvTp, address);
		moderoSetButtonOpacity(dvTp, address, MODERO_BUTTON_STATE_ALL, 127);
	}
}

/**
 * Update the meeting length presented for selection based on the available
 * time window.
 */
define_function updateAvailableBookingTimes()
{
	stack_var integer i;
	stack_var long maximumBookingLength;

	maximumBookingLength = trackedSpaces[getLongestAvailableHuddle()].nextBooking.minutesUntilStart;

	for (i = length_array(BTN_TIME_SELECT); i; i--)
	{
		setButtonSelectable(BTN_TIME_SELECT[i], maximumBookingLength > BOOKING_REQUEST_LENGTHS[i]);
	}
}

/**
 * Set the legnth that will be utilised by ad-hoc booking requests.
 */
define_function setBookingRequestLength(integer minutes)
{
	stack_var integer i;

	for (i = 1; i <= length_array(BTN_TIME_SELECT); i++)
	{
		[dvTp, BTN_TIME_SELECT[i]] = (BOOKING_REQUEST_LENGTHS[i] == minutes);
	}

	bookingRequestLength = minutes;
}

/**
 * Sets the pre-selected booking length.
 */
define_function setDefaultBookingLength()
{
	// Default to a 20 minute meeting, or if time doesn't allow fall back to
	// 10 minutes
	if (trackedSpaces[getLongestAvailableHuddle()].nextBooking.minutesUntilStart > BOOKING_REQUEST_LENGTHS[2])
	{
		setBookingRequestLength(BOOKING_REQUEST_LENGTHS[2]);
	}
	else
	{
		setBookingRequestLength(BOOKING_REQUEST_LENGTHS[1]);
	}
}

/**
 * Updates the state of the LED's
 */
define_function updateUI()
{
	if (device_id(10001:1:0))
	{
		moderoDisableLeds(dvTp, MODERO_LED_COLOUR_GREEN);
		moderoDisableLeds(dvTp, MODERO_LED_COLOUR_RED);
		return;
	}

	if (!trackedSpaces[getLongestAvailableHuddle()].inUse &&
			trackedSpaces[getLongestAvailableHuddle()].nextBooking.minutesUntilStart > BOOKING_REQUEST_LENGTHS[1])
	{
		moderoDisableLeds(dvTp, MODERO_LED_COLOUR_RED);
		moderoEnableLeds(dvTp, MODERO_LED_COLOUR_GREEN);
		moderoSetPage(dvTp, 'locate');
	}
	else
	{
		moderoDisableLeds(dvTp, MODERO_LED_COLOUR_GREEN);
		moderoEnableLeds(dvTp, MODERO_LED_COLOUR_RED);
		moderoSetButtonText(dvTp, BTN_MINUTES_UNTIL_AVAILABLE, MODERO_BUTTON_STATE_ALL,
				"'Next available in ', itoa(trackedSpaces[getNextAvailableHuddle()].activeBooking.remainingMinutes), ' minutes'");
		moderoSetPage(dvTp, 'allUsed');
		moderoDisableAllPopups(dvTp);
	}
}


// RMS callbacks

define_function RmsEventSchedulingActiveUpdated(CHAR bookingId[],
		RmsEventBookingResponse eventBookingResponse)
{
	stack_var integer i;

	for (i = MAX_HUDDLE_SPACES; i; i--)
	{
		if (eventBookingResponse.location == trackedSpaces[i].locationId)
		{
			trackedSpaces[i].activeBooking = eventBookingResponse;
			break;
		}
	}

	updateUI()
}

define_function RmsEventSchedulingNextActiveUpdated(CHAR bookingId[],
		RmsEventBookingResponse eventBookingResponse)
{
	stack_var integer i;

	for (i = MAX_HUDDLE_SPACES; i; i--)
	{
		if (eventBookingResponse.location == trackedSpaces[i].locationId)
		{
			trackedSpaces[i].nextBooking = eventBookingResponse;
			break;
		}
	}

	updateUI();
}

define_function RmsEventSchedulingEventEnded(CHAR bookingId[],
		RmsEventBookingResponse eventBookingResponse)
{
	stack_var integer i;

	for (i = MAX_HUDDLE_SPACES; i; i--)
	{
		if (eventBookingResponse.location == trackedSpaces[i].locationId)
		{
			trackedSpaces[i].inUse = false;
			break;
		}
	}

	updateUI();
}

define_function RmsEventSchedulingEventStarted(CHAR bookingId[],
		RmsEventBookingResponse eventBookingResponse)
{
	stack_var integer i;

	for (i = MAX_HUDDLE_SPACES; i; i--)
	{
		if (eventBookingResponse.location == trackedSpaces[i].locationId)
		{
			trackedSpaces[i].inUse = true;
			trackedSpaces[i].nextBooking.minutesUntilStart = MAX_TIME;
			break;
		}
	}

	updateUI();
}


define_event

data_event[dvTp]
{

	online:
	{
		updateUI();
	}

}

button_event[dvTp, BTN_FIND_WORKSPACE]
{

	push:
	{
		updateAvailableBookingTimes();
		setDefaultBookingLength();
	}

}

button_event[dvTp, BTN_TIME_SELECT]
{

	push:
	{
		setBookingRequestLength(BOOKING_REQUEST_LENGTHS[get_last(BTN_TIME_SELECT)]);
	}

}

button_event[dvTp, BTN_RESERVE]
{

	push:
	{
		RmsBookingCreate(ldate,
				time,
				bookingRequestLength,
				'Huddle Reservation',
				'Reservation created by room finding system',
				trackedSpaces[getLongestAvailableHuddle()].locationId);
	}

}

// THis is just a little bolt on for the purposes of the AMX14 demo. When the in
// room panel is connected the huddleFinder switches over to display a QR code'
// to show some different options for room scheduling.
data_event[10001:1:0]
{

	online:
	{
		moderoEnablePopup(dvTp, 'QR');
		updateUI();
	}

	offline:
	{
		moderoDisablePopup(dvTp, 'QR');
		updateUI();
	}

}


define_start

init();
