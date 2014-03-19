program_name='modero-multi-preview-dvx'

#include 'common'
#include 'amx-device-control'
#include 'amx-dvx-api'
#include 'amx-dvx-control'
#include 'amx-modero-api'
#include 'amx-modero-control'


define_device

dvTpPort1           = 10001:1:0	// for capturing page tracking strings
dvTpSnapshotPreview = 10001:3:0

// DVX Main Switcher Port
dvDvxMain   = 5002:1:0

// DVX Video Inputs (generic names)
dvDvxVidIn1     = 5002:1:0
dvDvxVidIn2     = 5002:2:0
dvDvxVidIn3     = 5002:3:0
dvDvxVidIn4     = 5002:4:0
dvDvxVidIn5     = 5002:5:0
dvDvxVidIn6     = 5002:6:0
dvDvxVidIn7     = 5002:7:0
dvDvxVidIn8     = 5002:8:0
dvDvxVidIn9     = 5002:9:0
dvDvxVidIn10    = 5002:10:0

// DVX Video Outputs (generic names)
dvDvxVidOut1    = 5002:1:0
dvDvxVidOut2    = 5002:2:0
dvDvxVidOut3    = 5002:3:0
dvDvxVidOut4    = 5002:4:0
// DVX Video Outputs (descriptive names)
dvDvxVidOutMultiPreview = dvDvxVidOut2



define_constant


integer BTN_ADR_VIDEO_LOADING_PREVIEW = 30
integer BTN_ADR_VIDEO_PREVIEW_WINDOW  = 31
integer BTN_VIDEO_PREVIEW_LOADING_BAR = 32
integer BTN_ADR_VIDEO_PREVIEW_LOADING_BAR = 32

char POPUP_NAME_VIDEO_PREVIEW[] = 'popup-video-preview'
char POPUP_NAME_VIDEO_LOADING[] = 'popup-video-loading'

char IMAGE_FILE_NAME_NO_IMAGE_ICON[] = 'icon-novideo.png'



integer BTN_VIDEO_SNAPSHOT_PREVIEW_01 = 10
integer BTN_VIDEO_SNAPSHOT_PREVIEW_02 = 11
integer BTN_VIDEO_SNAPSHOT_PREVIEW_03 = 12
integer BTN_VIDEO_SNAPSHOT_PREVIEW_04 = 13
integer BTN_VIDEO_SNAPSHOT_PREVIEW_05 = 14
integer BTN_VIDEO_SNAPSHOT_PREVIEW_06 = 15
integer BTN_VIDEO_SNAPSHOT_PREVIEW_07 = 16
integer BTN_VIDEO_SNAPSHOT_PREVIEW_08 = 17
integer BTN_VIDEO_SNAPSHOT_PREVIEW_09 = 18
integer BTN_VIDEO_SNAPSHOT_PREVIEW_10 = 19


define_constant

long TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS = 1


integer BTNS_VIDEO_SNAPSHOT_PREVIEWS[DVX_MAX_VIDEO_INPUTS]   =
{
	BTN_VIDEO_SNAPSHOT_PREVIEW_01,
	BTN_VIDEO_SNAPSHOT_PREVIEW_02,
	BTN_VIDEO_SNAPSHOT_PREVIEW_03,
	BTN_VIDEO_SNAPSHOT_PREVIEW_04,
	BTN_VIDEO_SNAPSHOT_PREVIEW_05,
	BTN_VIDEO_SNAPSHOT_PREVIEW_06,
	BTN_VIDEO_SNAPSHOT_PREVIEW_07,
	BTN_VIDEO_SNAPSHOT_PREVIEW_08,
	BTN_VIDEO_SNAPSHOT_PREVIEW_09,
	BTN_VIDEO_SNAPSHOT_PREVIEW_10
}



integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_01 = 10
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_02 = 11
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_03 = 12
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_04 = 13
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_05 = 14
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_06 = 15
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_07 = 16
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_08 = 17
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_09 = 18
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_10 = 19

integer BTN_ADRS_VIDEO_SNAPSHOT_PREVIEWS[DVX_MAX_VIDEO_INPUTS]   =
{
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_01,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_02,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_03,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_04,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_05,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_06,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_07,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_08,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_09,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_10
}


integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_01 = 40
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_02 = 41
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_03 = 42
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_04 = 43
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_05 = 44
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_06 = 45
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_07 = 46
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_08 = 47
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_09 = 48
integer BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_10 = 49

integer BTN_ADRS_VIDEO_SNAPSHOT_PREVIEW_LABELS[DVX_MAX_VIDEO_INPUTS]   =
{
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_01,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_02,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_03,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_04,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_05,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_06,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_07,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_08,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_09,
	BTN_ADR_VIDEO_SNAPSHOT_PREVIEW_LABEL_10
}

integer BTN_VIDEO_PREVIEW_EXIT = 100



define_variable


long timelineTimesMultiPreviewSnapshots[DVX_MAX_VIDEO_INPUTS]
long timelineTimeMplBetweenSwitches = 1000

volatile integer snapshotsInProgress = FALSE


integer waitTimeVideoPreview = 5
integer waitTimeVideoLoading = 20
integer waitTimeValidSignal  = 600
integer waitTimeMplSnapShot  = 8

long tlTimes[3] = {0,600,2000}		// switch | snapshot | wait (ABSOLUTE)

volatile integer isVideoBeingPreviewed = 0

volatile _DvxSwitcher dvx

volatile integer currentDvxInput = 0

volatile char currentPreviewButtonBitmap[DVX_MAX_VIDEO_INPUTS][30]

// Modero Listener Dev Array for Listening to button events
dev dvPanelsButtons[] = { dvTpSnapshotPreview }

/*define_function startMultiPreviewSnapshots ()
{
	if (!isVideoBeingPreviewed)
	{
		stack_var integer i
		stack_var integer isAtLeastOneValidSignal
		
		isAtLeastOneValidSignal = FALSE
		
		// reset all timeline times back to zero
		for (i = 1; i<= max_length_array(timelineTimesMultiPreviewSnapshots); i++)
		{
			if (dvx.videoInputs[i].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
			{
				timelineTimesMultiPreviewSnapshots[i] = timelineTimeMplBetweenSwitches
				isAtLeastOneValidSignal = TRUE
			}
			else
			{
				timelineTimesMultiPreviewSnapshots[i] = 0
			}
		}
		
		if (isAtLeastOneValidSignal)
		{
			if (!timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))
			{
				set_length_array (timelineTimesMultiPreviewSnapshots, max_length_array(timelineTimesMultiPreviewSnapshots))
				
				timeline_create (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS,
						timelineTimesMultiPreviewSnapshots,
						length_array (timelineTimesMultiPreviewSnapshots),
						timeline_relative,
						timeline_repeat)
			}
			else
			{
				CANCEL_WAIT 'WAIT_MULTI_PREVIEW_SNAPSHOT'
				timeline_reload (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS, timelineTimesMultiPreviewSnapshots, length_array(timelineTimesMultiPreviewSnapshots))
			}
		}
		else
		{
			if (timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))
			{
				timeline_kill (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)
				CANCEL_WAIT 'WAIT_MULTI_PREVIEW_SNAPSHOT'
			}
		}
	}
}*/



define_function startMultiPreviewSnapshots ()
{
	send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
	if (!isVideoBeingPreviewed)
	{
		stack_var integer i
		stack_var integer isAtLeastOneValidSignal
		
		send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
		isAtLeastOneValidSignal = FALSE
		
		// reset all timeline times back to zero
		for (i = 1; i<= DVX_MAX_VIDEO_INPUTS; i++)
		{
			send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
			if (dvx.videoInputs[i].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
			{
				send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
				isAtLeastOneValidSignal = TRUE
			}
		}
		
		send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
		
		if (isAtLeastOneValidSignal)
		{
			send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
			if (!timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))
			{
				send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
				set_length_array (tlTimes, max_length_array(tlTimes))
				
				timeline_create (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS,
						tlTimes,
						length_array (tlTimes),
						timeline_absolute,
						timeline_repeat)
				
				snapshotsInProgress = true
			}
			else
			{
				send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
				timeline_reload (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS, tlTimes, length_array(tlTimes))
				snapshotsInProgress = true
			}
		}
		else
		{
			send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
			if (timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))
			{
				send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
				timeline_kill (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)
				snapshotsInProgress = false
			}
		}
	}
}





/*define_function stopMultiPreviewSnapshots ()
{
	if (timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))
	{
		currentDvxInput = false
		timeline_kill (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)
		CANCEL_WAIT 'WAIT_MULTI_PREVIEW_SNAPSHOT'
	}
}*/

define_function stopMultiPreviewSnapshots ()
{
	send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
	if (timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))
	{
		send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
		currentDvxInput = FALSE
		timeline_kill (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)
	}
}




define_function loadVideoPreviewWindow (dev dvDvxVidInPort)
{
	send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
	// kill the multi-preview snapshot timeline
	stopMultiPreviewSnapshots ()
	
	// turn on the video being previed flag
	ON [isVideoBeingPreviewed]
	
	// delete video snapshot on the video preview button
	moderoDeleteButtonVideoSnapshot (dvTpSnapshotPreview, BTN_ADR_VIDEO_PREVIEW_WINDOW, MODERO_BUTTON_STATE_ALL)
	
	moderoDisableButtonFeedback (dvTpSnapshotPreview, BTN_VIDEO_PREVIEW_LOADING_BAR)    // reset the loading progress bar
	
	moderoSetButtonOpacity (dvTpSnapshotPreview, BTN_ADR_VIDEO_PREVIEW_WINDOW, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_INVISIBLE)
	//moderoSetButtonHide (dvTpSnapshotPreview, BTN_ADR_VIDEO_PREVIEW_WINDOW)
	moderoSetButtonShow (dvTpSnapshotPreview, BTN_ADR_VIDEO_LOADING_PREVIEW)
	moderoSetButtonShow (dvTpSnapshotPreview, BTN_ADR_VIDEO_PREVIEW_LOADING_BAR)
	
	moderoEnablePopup (dvTpSnapshotPreview, POPUP_NAME_VIDEO_PREVIEW)
	
	moderoEnableButtonFeedback (dvTpSnapshotPreview, BTN_VIDEO_PREVIEW_LOADING_BAR) //start the loading progress bar
	
	dvxSwitchVideoOnly (dvDvxMain, dvDvxVidInPort.port, dvDvxVidOutMultiPreview.port)
	
	CANCEL_WAIT 'WAIT_HIDE_VIDEO_LOADING_BUTTON'
	WAIT waitTimeVideoLoading 'WAIT_HIDE_VIDEO_LOADING_BUTTON'
	{
		send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
		moderoSetButtonHide (dvTpSnapshotPreview, BTN_ADR_VIDEO_LOADING_PREVIEW)
		moderoSetButtonHide (dvTpSnapshotPreview, BTN_ADR_VIDEO_PREVIEW_LOADING_BAR)
		//moderoSetButtonShow (dvTpSnapshotPreview, BTN_ADR_VIDEO_PREVIEW_WINDOW)
		moderoSetButtonOpacity (dvTpSnapshotPreview, BTN_ADR_VIDEO_PREVIEW_WINDOW, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_OPAQUE)
	}
}




#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_STATUS_CALLBACK
define_function dvxNotifyVideoInputStatus (dev dvxVideoInput, char signalStatus[])
{
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// signalStatus is the input signal status (DVX_SIGNAL_STATUS_NO_SIGNAL | DVX_SIGNAL_STATUS_UNKNOWN | DVX_SIGNAL_STATUS_VALID_SIGNAL)
	
	stack_var char oldSignalStatus[50]
	
	send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
	
	oldSignalStatus = dvx.videoInputs[dvxVideoInput.port].status
	
	if (signalStatus != oldSignalStatus)
	{
		send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
		dvx.videoInputs[dvxVideoInput.port].status = signalStatus
		startMultiPreviewSnapshots ()
		
		switch (signalStatus)
		{
			case DVX_SIGNAL_STATUS_NO_SIGNAL:
			case DVX_SIGNAL_STATUS_UNKNOWN:
			{
				send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
				moderoSetButtonBitmap (dvTpSnapshotPreview, BTN_ADRS_VIDEO_SNAPSHOT_PREVIEWS[dvxVideoInput.port],MODERO_BUTTON_STATE_ALL,IMAGE_FILE_NAME_NO_IMAGE_ICON)
			}
			/*case DVX_SIGNAL_STATUS_VALID_SIGNAL:
			{
				moderoEnableButtonScaleToFit (dvTpSnapshotPreview, BTN_ADRS_VIDEO_SNAPSHOT_PREVIEWS[dvxVideoInput.port],MODERO_BUTTON_STATE_ALL)
				
				// NOTE: Don't set the dynamic resource here. That should be done by the timeline event for taking snapshots.
				// Otherwise it could result in the snapshots image of the currently routed video to the MPL being shown on all snapshot buttons.
			}*/
		}
		
	}
}

#define INCLUDE_MODERO_NOTIFY_BUTTON_BITMAP_NAME
define_function moderoNotifyButtonBitmapName (dev panel, integer btnAdrCde, integer nbtnState, char bitmapName[])
{
	// panel is the touch panel
	// btnAdrCde is the button address code
	// btnState is the button state
	// bitmapName is the name of the image assigned to the button
	
	send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
	if (panel == dvTpSnapshotPreview)
	{
		stack_var integer i
		
		send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
		for (i=1; i<=DVX_MAX_VIDEO_INPUTS; i++)
		{
			send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
			if (btnAdrCde == BTN_ADRS_VIDEO_SNAPSHOT_PREVIEWS[i])
			{
				send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
				currentPreviewButtonBitmap[i] = bitmapName
			}
		}
	}
}




#include 'amx-dvx-listener'
#include 'amx-modero-listener'


define_event

data_event[dvDvxMain]
{
	online:
	{
		dvxRequestVideoInputStatusAll (dvDvxMain)
	}
}

data_event[dvDvxVidOutMultiPreview]
{
	online:
	{
		stack_var integer i
		
		for (i=1; i<=DVX_MAX_VIDEO_INPUTS; i++)
		{
			// request bitmaps of sources
			moderoRequestButtonBitmapName (dvTpSnapshotPreview, BTN_ADRS_VIDEO_SNAPSHOT_PREVIEWS[i], MODERO_BUTTON_STATE_OFF)
		}
		
		dvxSetVideoOutputScaleMode (dvDvxVidOutMultiPreview, DVX_SCALE_MODE_AUTO)
	}
}

data_event[dvTpSnapshotPreview]
{
	online:
	{
		stack_var integer i
		
		// Set snapshot preview buttons to scale-to-fit (only applies to dynamic images in G4 modero panels)
		for (i=1; i<=DVX_MAX_VIDEO_INPUTS; i++)
			moderoEnableButtonScaleToFit (dvTpSnapshotPreview, BTN_ADRS_VIDEO_SNAPSHOT_PREVIEWS[i],MODERO_BUTTON_STATE_ALL)
		
		// Setup video settings for MPL
		moderoSetMultiPreviewInputFormatAndResolution (data.device, MODERO_MULTI_PREVIEW_INPUT_FORMAT_HDMI, MODERO_MULTI_PREVIEW_INPUT_RESOLUTION_HDMI_720x480i30HZ)
	}
}

data_event[dvTpPort1]
{
	online:
	{
		moderoEnablePageTracking (dvTpPort1)
		dvxRequestVideoInputStatusAll (dvDvxMain)
	}
	string:
	{
		// start taking snapshots of each input as soon as the video preview popup closes
		if (find_string(data.text, "'@PPF-',POPUP_NAME_VIDEO_PREVIEW",1) == 1)
		{
			// turn off the video being previewed flag
			isVideoBeingPreviewed = FALSE
			startMultiPreviewSnapshots ()
		}
	}
}

/*timeline_event[TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS]
{
	stack_var integer input
	local_var integer slotId
	local_var char dynamicImageName[30]
	
	input = timeline.sequence
	
	if (timelineTimesMultiPreviewSnapshots[input])
	{
		slotId = input
		dynamicImageName = "'MXA_PREVIEW_',itoa(slotId)"
		
		// Only take a snapshot if there is a valid signal status on the input
		if (dvx.videoInputs[slotId].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
		{
			dvxSwitchVideoOnly (dvDvxMain, slotId, dvDvxVidOutMultiPreview.port)
			
			WAIT waitTimeMplSnapShot 'WAIT_MULTI_PREVIEW_SNAPSHOT'   // wait just over half a second before taking the snapshot....allows the image time to lock on
			{
				moderoResourceForceRefreshPrefetchFromCache (dvTpSnapshotPreview, dynamicImageName, MODERO_RESOURCE_NOTIFICATION_OFF)
				moderoSetButtonBitmapResource (dvTpSnapshotPreview, BTN_ADRS_VIDEO_SNAPSHOT_PREVIEWS[slotId],MODERO_BUTTON_STATE_ALL,"'MXA_PREVIEW_',itoa(slotId)")
			}
		}
	}
}*/

timeline_event[TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS]
{
	local_var char dynamicImageName[30]
	
	send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
	switch (timeline.sequence)
	{
		case 1:
		{
			stack_var integer i
			
			send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
			
			// set up dvx input to start from
			if (currentDvxInput == false)
				currentDvxInput = 1
			
			for (i = currentDvxInput; i < currentDvxInput + DVX_MAX_VIDEO_INPUTS - 1; i++)
			{
				if (dvx.videoInputs[((i % DVX_MAX_VIDEO_INPUTS) + 1)].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
				{
					currentDvxInput = ((i % DVX_MAX_VIDEO_INPUTS) + 1)
					break	// exit the for loop
				}
			}
			
			send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
			
			moderoRequestButtonBitmapName (dvTpSnapshotPreview, BTN_ADRS_VIDEO_SNAPSHOT_PREVIEWS[currentDvxInput], MODERO_BUTTON_STATE_OFF)
			
			dvxSwitchVideoOnly (dvDvxMain, currentDvxInput, dvDvxVidOutMultiPreview.port)
		}
		case 2:
		{
			send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
			dynamicImageName = "'MXA_PREVIEW_',itoa(currentDvxInput)"
			
			
			sendCommand (dvTpSnapshotPreview, "'^RMF-',dynamicImageName,',%V0'")
			moderoResourceForceRefreshPrefetchFromCache (dvTpSnapshotPreview, dynamicImageName, MODERO_RESOURCE_NOTIFICATION_OFF)
			sendCommand (dvTpSnapshotPreview, "'^RMF-',dynamicImageName,',%V1'")
			
			// only need to set the button bitmap the first time the resource is loaded
			if (currentPreviewButtonBitmap[currentDvxInput] != dynamicImageName)
			{
				send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
				moderoSetButtonBitmapResource (dvTpSnapshotPreview, BTN_ADRS_VIDEO_SNAPSHOT_PREVIEWS[currentDvxInput],MODERO_BUTTON_STATE_ALL,"'MXA_PREVIEW_',itoa(currentDvxInput)")
			}
			
			
		}
		case 3:
		{
			send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
			// do nothing - just waiting until the next switch
		}
	}
}

button_event[dvTpSnapshotPreview,BTNS_VIDEO_SNAPSHOT_PREVIEWS]
{
	hold[waitTimeVideoPreview]:
	{
		send_string 0, "'DEBUG::Line:',itoa(__LINE__)"
		loadVideoPreviewWindow (dvDvxVidInPorts[get_last(BTNS_VIDEO_SNAPSHOT_PREVIEWS)])
	}
}

