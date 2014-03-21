program_name='huddleUIManager'


#include 'amx-modero-control';


define_variable

constant char POPUP_AUTH[] = 'auth';

constant char SOURCE_SUBPAGE_PREFEX[] = '[source]';

constant integer BTN_SOURCE_SELECT[] = {1, 2, 3};

constant integer BTN_SOURCES_SUBPAGE_VIEW = 10;

constant integer BTN_END_SESSION = 13;


define_function initUI()
{
	if (isSessionActive())
	{
		hideAuthScreen();
	}
	else
	{
		showAuthScreen();
	}

	refreshSourceLauncherVisibility();
}

/**
 * Show the NFC auth screen on the TP
 */
define_function showAuthScreen()
{
	moderoEnablePopup(dvTp, POPUP_AUTH);
}

/**
 * Hide's the NFC auth / lockup
 */
define_function hideAuthScreen()
{
	moderoDisablePopup(dvTp, POPUP_AUTH);
}

/**
 * Sets the visibility state of a source launcher on our touch panel.
 */
define_function setSourceLauncherVisbible(char key[], char isVisible)
{
	if (deviceIsOnline(dvTp))
	{
		stack_var char subpageName[16];

		log(AMX_DEBUG, "'setting source launcher for ', key, ' visibility ',
				bool_to_string(isVisible)");

		subpageName = "SOURCE_SUBPAGE_PREFEX,key";

		if (isVisible)
		{
			moderoShowSubpage(dvTp, BTN_SOURCES_SUBPAGE_VIEW, subpageName, 1, 10);
		}
		else
		{
			moderoHideSubpage(dvTp, BTN_SOURCES_SUBPAGE_VIEW, subpageName, 10);
		}
	}
}

/**
 *	Refresh the visibility state of all source launch icons.
 */
define_function refreshSourceLauncherVisibility()
{
	stack_var char i;

	for (i = NUM_SOURCES; i; i--)
	{
		setSourceLauncherVisbible(getSourceKey(i), isSourceAvailable(i));
	}

	for (i = MAX_ENZO_CONTENT_SOURCES; i; i--)
	{
		setSourceLauncherVisbible(getEnzoContentSourceKey(i), isEnzoContentSourceAvailable(i));
	}
}


define_event

data_event[dvTp]
{
	online:
	{
		initUI();
	}
}

button_event[dvTp, BTN_SOURCE_SELECT]
{
	push:
	{
		stack_var char sourceId;
		sourceId = get_last(BTN_SOURCE_SELECT)
		setActiveSource(sourceId);
		if (sourceId == SOURCE_ENZO && !getEnzoSessionActive())
		{
			enzoSessionStart(dvEnzo);
		}
	}
}

button_event[dvTp, BTN_END_SESSION]
{
	push:
	{
		endSession();
	}
}
