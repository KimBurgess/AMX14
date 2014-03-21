program_name='huddleUIManager'


#include 'amx-modero-control';


define_variable

constant char POPUP_AUTH[] = 'auth';

constant char SUBPAGE_SOURCE_PREFEX[] = '[source]';
constant char SUBPAGE_FILE_PREFIX[] = '[file]';

constant integer BTN_SOURCE_SELECT[] = {1, 2, 3};
constant integer BTN_LAUNCHER_USB = 4;
constant integer BTN_LAUNCHER_DROPBOX = 5;
constant integer BTN_SOURCES_SUBPAGE_VIEW = 10;

constant integer BTN_END_SESSION = 13;

constant integer BTN_FILE_LIST_SUBPAGE_VIEW = 19;
constant integer BTN_FILE_LIST_UP = 20;
constant integer BTN_FILE_LIST_ITEM[] = {21, 22, 23, 24, 25, 26, 26, 27, 28, 29, 30};


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

		subpageName = "SUBPAGE_SOURCE_PREFEX,key";

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

define_function setFileItemVisible(integer id, char isVisible)
{
	if (deviceIsOnline(dvTp))
	{
		stack_var char subpageName[16];

		subpageName = "SUBPAGE_FILE_PREFIX,itoa(id)";

		if (isVisible)
		{
			moderoShowSubpage(dvTp, BTN_FILE_LIST_SUBPAGE_VIEW, subpageName, 1, 1);
		}
		else
		{
			moderoHideSubpage(dvTp, BTN_FILE_LIST_SUBPAGE_VIEW, subpageName, 1);
		}
	}
}

define_function refreshFileList()
{
	stack_var integer i;

	moderoHideAllSubpages(dvTp, BTN_FILE_LIST_SUBPAGE_VIEW);

	for (i = getEnzoContentItemCount(); i; i--)
	{
		setFileItemVisible(i, true);
		moderoSetButtonText(dvTp, BTN_FILE_LIST_ITEM[i],
				MODERO_BUTTON_STATE_ALL, getEnzoContentItemName(i));
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
	release:
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

button_event[dvTp, BTN_LAUNCHER_USB]
{
	release:
	{
		enzoSetContentSource(dvEnzo, getEnzoContentSourceKey(ENZO_CONTENT_SOURCE_USB));
	}
}

button_event[dvTp, BTN_LAUNCHER_DROPBOX]
{
	release:
	{
		enzoSetContentSource(dvEnzo, getEnzoContentSourceKey(ENZO_CONTENT_SOURCE_DROPBOX));
	}
}

button_event[dvTp, BTN_END_SESSION]
{
	push:
	{
		endSession();
	}
}

button_event[dvTp, BTN_FILE_LIST_UP]
{
	release:
	{
		enzoSetContentPath(dvEnzo, ENZO_CONTENT_PATH_UP);
	}
}

button_event[dvTp, BTN_FILE_LIST_ITEM]
{
	release:
	{
		stack_var integer index;
		index = get_last(BTN_FILE_LIST_ITEM)
		if (getEnzoContentItemType(index) == ENZO_CONTENT_TYPE_DIRECTORY)
		{
			enzoSetContentPath(dvEnzo, getEnzoContentItemPath(index));
		}
		else
		{
			enzoContentOpen(dvEnzo, getEnzoContentItemPath(index));
		}
	}
}
