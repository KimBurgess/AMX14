program_name='huddleUIManager'


#include 'string'
#include 'amx-modero-control';


define_variable

constant char POPUP_AUTH[] = 'auth';
constant char POPUP_FILE_BROWSER[] = 'fileBrowser';
constant char POPUP_FILE_BROWSER_ERROR[] = 'fileBrowserError';
constant char POPUP_FILE_BROWSER_LOADING[] = 'fileBrowserLoading';
constant char POPUP_RESERVING[] = 'reserving';

constant char SUBPAGE_SOURCE_PREFEX[] = '[source]';
constant char SUBPAGE_FILE_PREFIX[] = '[file]';

constant integer BTN_SOURCE_SELECT[] = {1, 2, 3};
constant integer BTN_LAUNCHER_USB = 4;
constant integer BTN_LAUNCHER_DROPBOX = 5;
constant integer BTN_SOURCES_SUBPAGE_VIEW = 10;

constant integer BTN_END_SESSION = 13;

constant integer BTN_FILE_LIST_SUBPAGE_VIEW = 19;
constant integer BTN_FILE_LIST_UP = 20;
constant integer BTN_FILE_LIST_ITEM[] = {21, 22, 23, 24, 25, 26, 27, 28, 29,
		30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40};

// Part of the Google doc PoC
constant integer BTN_GOOGLE_DOC = 50;
persistent char googleDocLink[] = 'https://docs.google.com/document/d/19ajNKijP2BkXHNd2_p5L5lmCpW4VUsLlmyeSsP8KFlg/edit?usp=sharing';



define_function initUI()
{
	// Bring everything into sync with the current system state. This is a
	// little odd as the same physical space for AMX14 is being shared by two
	// discreet demo's.
	if (isSessionActive())
	{
		hideAuthScreen();
		createAdHocMeetingRoomBooking();
		enzoSessionStart(dvEnzo);
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
 * Play the authentication successful sound.
 */
define_function playAuthSound()
{
	moderoPlaySoundFile(dvTp, 'valid-id.wav');
}

define_function showReservingScreen()
{
	moderoEnablePopup(dvTp, POPUP_RESERVING);
}

define_function hideReservingScreen()
{
	moderoDisablePopup(dvTp, POPUP_RESERVING);
}

/**
 * Sets a source launcher icon to the achor position of our source list.
 */
define_function anchorSourceLauncher(char key[])
{
	if (deviceIsOnline(dvTp))
	{
		stack_var char subpageName[16];
		subpageName = "SUBPAGE_SOURCE_PREFEX,key";
		moderoShowSubpage(dvTp, BTN_SOURCES_SUBPAGE_VIEW, subpageName, 1, 10);
	}
}

/**
 * Sets the visibility state of a source launcher on our touch panel.
 */
define_function setContentLauncherVisbible(char key[], char isVisible)
{
	if (deviceIsOnline(dvTp))
	{
		stack_var char subpageName[32];

		log(AMX_DEBUG, "'setting content launcher for ', key, ' visibility ',
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

	log(AMX_DEBUG, 'refreshing source launcher visibility states');

	for (i = NUM_SOURCES; i; i--)
	{
		setContentLauncherVisbible(getSourceKey(i), isSourceAvailable(i));
	}

	for (i = MAX_ENZO_CONTENT_SOURCES; i; i--)
	{
		setContentLauncherVisbible(getEnzoContentSourceKey(i), isEnzoContentSourceAvailable(i));
	}

	// This is simply here to show proof of concept for a button to launch a
	// link directoy on Enzo. In real world scenarios a nice solution here would
	// be to parse the contents of any active meeting descriptions provided by
	// RMS and render each link as a launchable button. This would enable
	// all shared documents referenced within meeting invite to be quikcly and
	// easilly displayed on the room display.
	setContentLauncherVisbible('googleDoc', getEnzoSessionActive());

	anchorSourceLauncher(getSourceKey(getActiveSource()));
}

/**
 * Gets the icon reference for a passed file type.
 */
define_function char[32] getIconName(char fileType[])
{
	stack_var char mediaType[32];
	stack_var char subType[32];
	stack_var char iconName[32];

	mediaType = string_get_key(fileType, '/');
	subType = string_get_value(fileType, '/');

	switch (mediaType)
	{
		case 'audio': iconName = 'audio'
		case 'image': iconName = 'image';
		case 'video': iconName = 'video';
		case 'directory': iconName = 'folder';
		case 'parent': iconName = 'back';
		case 'application':
		{
			switch (subType)
			{
				case 'pdf': iconName = 'pdf';
			}
		}
	}

	if (!iconName)
	{
		iconName = 'other';
	}

	iconName = "'icon-', iconName, '.png'";

	return iconName;
}

/**
 * Refresh the displayed content within the file browser area.
 */
define_function refreshFileList()
{
	if (deviceIsOnline(dvTp))
	{
		stack_var integer i;

		// FIME this causes the popup to display briefly on device connect
		moderoEnablePopup(dvTp, POPUP_FILE_BROWSER_LOADING);

		moderoHideAllSubpages(dvTp, BTN_FILE_LIST_SUBPAGE_VIEW);

		for (i = getEnzoContentItemCount(); i; i--)
		{
			stack_var char subpageName[16];
			subpageName = "SUBPAGE_FILE_PREFIX,itoa(i)";

			moderoSetButtonText(dvTp, BTN_FILE_LIST_ITEM[i],
					MODERO_BUTTON_STATE_ALL, getEnzoContentItemName(i));

			moderoSetButtonBitmap(dvTp, BTN_FILE_LIST_ITEM[i],
					MODERO_BUTTON_STATE_ALL, getIconName(getEnzoContentItemType(i)));

			moderoShowSubpage(dvTp, BTN_FILE_LIST_SUBPAGE_VIEW, subpageName, 0, 0);
		}

		moderoDisablePopup(dvTp, POPUP_FILE_BROWSER_LOADING)
	}
}

define_function hideFileBrowser()
{
	if (deviceIsOnline(dvTp))
	{
		moderoDisablePopup(dvTp, POPUP_FILE_BROWSER);
	}
}

define_function showFileBrowserError()
{
	if (deviceIsOnline(dvTp))
	{
		moderoEnablePopup(dvTp, POPUP_FILE_BROWSER_ERROR);
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
		if (sourceId == SOURCE_ENZO)
		{
			if (!getEnzoSessionActive())
			{
				enzoSessionStart(dvEnzo);
			}
			else
			{
				enzoHome(dvEnzo);
			}
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

button_event[dvTp, BTN_FILE_LIST_ITEM]
{
	release:
	{
		stack_var integer index;
		stack_var char contentType[64]

		index = get_last(BTN_FILE_LIST_ITEM)
		contentType = getEnzoContentItemType(index);

		if (contentType == ENZO_CONTENT_TYPE_DIRECTORY ||
			contentType == ENZO_CONTENT_TYPE_PARENT)
		{
			enzoSetContentPath(dvEnzo, getEnzoContentItemPath(index));
		}
		else
		{
			setActiveSource(SOURCE_ENZO);
			enzoContentOpen(dvEnzo, getEnzoContentItemPath(index));
		}
	}
}

button_event[dvTp, BTN_GOOGLE_DOC]
{
	release:
	{
		setActiveSource(SOURCE_ENZO);
		enzoShowWebApp(dvEnzo, googleDocLink);
	}
}