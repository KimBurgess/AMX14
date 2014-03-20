module_name='multi-preview-dvx' (dev virtual,
								 dev dvDvxVidOutMultiPreview, 
                                 dev dvTpSnapshotPreview, 
								 integer btnsVideoSnapshotPreviews[],          // address codes
								 integer btnAdrsVideoSnapshotPreviews[],       // address codes
								 integer btnAdrsVideoInputLabels[],            // address codes
								 integer btnAdrVideoPreviewLoadingMessage,     // address code
								 integer btnLoadingBarMultiState,              // channel code
								 integer btnAdrLoadingBar,                     // address code
								 integer btnAdrVideoPreviewWindow,             // address code
								 integer btnExitVideoPreview,                  // channel code
								 char popupNameVideoPreview[],
								 char imageFileNameNoVideo[])

#include 'common'
#include 'amx-device-control'
#include 'amx-dvx-api'
#include 'amx-dvx-control'
#include 'amx-modero-api'
#include 'amx-modero-control'



define_constant

long TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS = 1


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
dev dvPanelsButtons[1]


dev dvTpPort1


// DVX Main Switcher Port
dev dvDvxSwitcher

// DVX Video Inputs (generic names)
dev dvDvxVidIn1
dev dvDvxVidIn2
dev dvDvxVidIn3
dev dvDvxVidIn4
dev dvDvxVidIn5
dev dvDvxVidIn6
dev dvDvxVidIn7
dev dvDvxVidIn8
dev dvDvxVidIn9
dev dvDvxVidIn10

// DVX Video Outputs (generic names)
dev dvDvxVidOut1
dev dvDvxVidOut2
dev dvDvxVidOut3
dev dvDvxVidOut4




define_function initDevice (dev device, integer number, integer port, integer system)
{
	device.number = number
	device.port = port
	device.system = system
}

define_function addDeviceToDevArray (dev deviceArray[], dev device)
{
	if (length_array(deviceArray) < max_length_array(deviceArray))
	{
		set_length_array (deviceArray, (length_array(deviceArray)+1))
		deviceArray[length_array(deviceArray)] = device
	}
}

define_function startMultiPreviewSnapshots ()
{
	if (!isVideoBeingPreviewed)
	{
		stack_var integer i
		stack_var integer isAtLeastOneValidSignal
		
		isAtLeastOneValidSignal = FALSE
		
		// reset all timeline times back to zero
		for (i = 1; i<= DVX_MAX_VIDEO_INPUTS; i++)
		{
			if (dvx.videoInputs[i].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
			{
				isAtLeastOneValidSignal = TRUE
			}
		}
		
		if (isAtLeastOneValidSignal)
		{
			if (!timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))
			{
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
				timeline_reload (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS, tlTimes, length_array(tlTimes))
				snapshotsInProgress = true
			}
		}
		else
		{
			if (timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))
			{
				timeline_kill (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)
				snapshotsInProgress = false
			}
		}
	}
}

define_function stopMultiPreviewSnapshots ()
{
	if (timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))
	{
		currentDvxInput = FALSE
		timeline_kill (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)
	}
}

define_function loadVideoPreviewWindow (dev dvDvxVidInPort)
{
	// kill the multi-preview snapshot timeline
	stopMultiPreviewSnapshots ()
	
	// turn on the video being previed flag
	ON [isVideoBeingPreviewed]
	
	// delete video snapshot on the video preview button
	moderoDeleteButtonVideoSnapshot (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL)
	
	moderoDisableButtonFeedback (dvTpSnapshotPreview, btnLoadingBarMultiState)    // reset the loading progress bar
	
	moderoSetButtonOpacity (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_INVISIBLE)
	moderoSetButtonShow (dvTpSnapshotPreview, btnAdrVideoPreviewLoadingMessage)
	moderoSetButtonShow (dvTpSnapshotPreview, btnAdrLoadingBar)
	
	//moderoEnablePopup (dvTpSnapshotPreview, popupNameVideoPreview)
	
	moderoEnableButtonFeedback (dvTpSnapshotPreview, btnLoadingBarMultiState) //start the loading progress bar
	
	dvxSwitchVideoOnly (dvDvxSwitcher, dvDvxVidInPort.port, dvDvxVidOutMultiPreview.port)
	
	CANCEL_WAIT 'WAIT_HIDE_VIDEO_LOADING_BUTTON'
	WAIT waitTimeVideoLoading 'WAIT_HIDE_VIDEO_LOADING_BUTTON'
	{
		moderoSetButtonHide (dvTpSnapshotPreview, btnAdrVideoPreviewLoadingMessage)
		moderoSetButtonHide (dvTpSnapshotPreview, btnAdrLoadingBar)
		moderoSetButtonOpacity (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_OPAQUE)
	}
}

#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_STATUS_CALLBACK
define_function dvxNotifyVideoInputStatus (dev dvxVideoInput, char signalStatus[])
{
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// signalStatus is the input signal status (DVX_SIGNAL_STATUS_NO_SIGNAL | DVX_SIGNAL_STATUS_UNKNOWN | DVX_SIGNAL_STATUS_VALID_SIGNAL)
	
	stack_var char oldSignalStatus[50]
	
	oldSignalStatus = dvx.videoInputs[dvxVideoInput.port].status
	
	if (signalStatus != oldSignalStatus)
	{
		dvx.videoInputs[dvxVideoInput.port].status = signalStatus
		startMultiPreviewSnapshots ()
		
		switch (signalStatus)
		{
			case DVX_SIGNAL_STATUS_NO_SIGNAL:
			case DVX_SIGNAL_STATUS_UNKNOWN:
			{
				moderoSetButtonBitmap (dvTpSnapshotPreview, btnAdrsVideoSnapshotPreviews[dvxVideoInput.port],MODERO_BUTTON_STATE_ALL,imageFileNameNoVideo)
			}
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
	
	if (panel == dvTpSnapshotPreview)
	{
		stack_var integer i
		
		for (i=1; i<=DVX_MAX_VIDEO_INPUTS; i++)
		{
			if (btnAdrCde == btnAdrsVideoSnapshotPreviews[i])
			{
				currentPreviewButtonBitmap[i] = bitmapName
			}
		}
	}
}


// Listener includes go below function definitions (IMPORTANT!!!)
#include 'amx-dvx-listener'
#include 'amx-modero-listener'




define_start

initDevice (dvTpPort1, dvTpSnapshotPreview.number, 1, dvTpSnapshotPreview.system)

// DVX Switcher
initDevice (dvDvxSwitcher, dvDvxVidOutMultiPreview.number, DVX_PORT_MAIN, dvDvxVidOutMultiPreview.system)

// DVX Video Inputs (generic names)
initDevice (dvDvxVidIn1, dvDvxVidOutMultiPreview.number, DVX_PORT_VID_IN_1, dvDvxVidOutMultiPreview.system)
initDevice (dvDvxVidIn2, dvDvxVidOutMultiPreview.number, DVX_PORT_VID_IN_2, dvDvxVidOutMultiPreview.system)
initDevice (dvDvxVidIn3, dvDvxVidOutMultiPreview.number, DVX_PORT_VID_IN_3, dvDvxVidOutMultiPreview.system)
initDevice (dvDvxVidIn4, dvDvxVidOutMultiPreview.number, DVX_PORT_VID_IN_4, dvDvxVidOutMultiPreview.system)
initDevice (dvDvxVidIn5, dvDvxVidOutMultiPreview.number, DVX_PORT_VID_IN_5, dvDvxVidOutMultiPreview.system)
initDevice (dvDvxVidIn6, dvDvxVidOutMultiPreview.number, DVX_PORT_VID_IN_6, dvDvxVidOutMultiPreview.system)
initDevice (dvDvxVidIn7, dvDvxVidOutMultiPreview.number, DVX_PORT_VID_IN_7, dvDvxVidOutMultiPreview.system)
initDevice (dvDvxVidIn8, dvDvxVidOutMultiPreview.number, DVX_PORT_VID_IN_8, dvDvxVidOutMultiPreview.system)
initDevice (dvDvxVidIn9, dvDvxVidOutMultiPreview.number, DVX_PORT_VID_IN_9, dvDvxVidOutMultiPreview.system)
initDevice (dvDvxVidIn10, dvDvxVidOutMultiPreview.number, DVX_PORT_VID_IN_10, dvDvxVidOutMultiPreview.system)


// DVX Video Outputs (generic names)
initDevice (dvDvxVidOut1, dvDvxVidOutMultiPreview.number, DVX_PORT_VID_OUT_1, dvDvxVidOutMultiPreview.system)
initDevice (dvDvxVidOut2, dvDvxVidOutMultiPreview.number, DVX_PORT_VID_OUT_2, dvDvxVidOutMultiPreview.system)
initDevice (dvDvxVidOut3, dvDvxVidOutMultiPreview.number, DVX_PORT_VID_OUT_3, dvDvxVidOutMultiPreview.system)
initDevice (dvDvxVidOut4, dvDvxVidOutMultiPreview.number, DVX_PORT_VID_OUT_4, dvDvxVidOutMultiPreview.system)

addDeviceToDevArray (dvPanelsButtons, dvTpSnapshotPreview)

rebuild_event()



define_event

data_event[dvDvxSwitcher]
{
	online:
	{
		dvxRequestVideoInputStatusAll (dvDvxSwitcher)
	}
}

data_event[dvDvxVidOutMultiPreview]
{
	online:
	{
		dvxSetVideoOutputScaleMode (dvDvxVidOutMultiPreview, DVX_SCALE_MODE_AUTO)
		
		if (device_id(dvTpSnapshotPreview))
		{
			stack_var integer i
			
			for (i=1; i<=DVX_MAX_VIDEO_INPUTS; i++)
			{
				// request bitmaps of sources
				moderoRequestButtonBitmapName (dvTpSnapshotPreview, btnAdrsVideoSnapshotPreviews[i], MODERO_BUTTON_STATE_OFF)
			}
		}
	}
}

data_event[dvTpSnapshotPreview]
{
	online:
	{
		stack_var integer i
		
		// Set snapshot preview buttons to scale-to-fit (only applies to dynamic images in G4 modero panels)
		for (i=1; i<=DVX_MAX_VIDEO_INPUTS; i++)
			moderoEnableButtonScaleToFit (dvTpSnapshotPreview, btnAdrsVideoSnapshotPreviews[i],MODERO_BUTTON_STATE_ALL)
		
		for (i=1; i<=DVX_MAX_VIDEO_INPUTS; i++)
		{
			// request bitmaps of sources
			moderoRequestButtonBitmapName (dvTpSnapshotPreview, btnAdrsVideoSnapshotPreviews[i], MODERO_BUTTON_STATE_OFF)
		}
		
		moderoSetButtonHide (dvTpSnapshotPreview, btnAdrVideoPreviewLoadingMessage)
		moderoSetButtonHide (dvTpSnapshotPreview, btnAdrLoadingBar)
		
		// Setup video settings for MPL
		moderoSetMultiPreviewInputFormatAndResolution (data.device, MODERO_MULTI_PREVIEW_INPUT_FORMAT_HDMI, MODERO_MULTI_PREVIEW_INPUT_RESOLUTION_HDMI_720x480i30HZ)
	}
}

data_event[dvTpPort1]
{
	online:
	{
		moderoEnablePageTracking (dvTpPort1)
		
		if (device_id(dvDvxSwitcher))
			dvxRequestVideoInputStatusAll (dvDvxSwitcher)
	}
	string:
	{
		// start taking snapshots of each input as soon as the video preview popup closes
		if (find_string(data.text, "'@PPF-',popupNameVideoPreview",1) == 1)
		{
			// turn off the video being previewed flag
			isVideoBeingPreviewed = FALSE
			startMultiPreviewSnapshots ()
		}
	}
}

timeline_event[TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS]
{
	local_var char dynamicImageName[30]
	
	switch (timeline.sequence)
	{
		case 1:
		{
			stack_var integer i
			
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
			
			moderoRequestButtonBitmapName (dvTpSnapshotPreview, btnAdrsVideoSnapshotPreviews[currentDvxInput], MODERO_BUTTON_STATE_OFF)
			
			dvxSwitchVideoOnly (dvDvxSwitcher, currentDvxInput, dvDvxVidOutMultiPreview.port)
		}
		case 2:
		{
			dynamicImageName = "'MXA_PREVIEW_',itoa(currentDvxInput)"
			
			moderoEnableResourceReloadOnView (dvTpSnapshotPreview, dynamicImageName)
			moderoResourceForceRefreshPrefetchFromCache (dvTpSnapshotPreview, dynamicImageName, MODERO_RESOURCE_NOTIFICATION_OFF)
			moderoDisableResourceReloadOnView (dvTpSnapshotPreview, dynamicImageName)
			
			// only need to set the button bitmap the first time the resource is loaded
			if (currentPreviewButtonBitmap[currentDvxInput] != dynamicImageName)
			{
				moderoSetButtonBitmapResource (dvTpSnapshotPreview, btnAdrsVideoSnapshotPreviews[currentDvxInput],MODERO_BUTTON_STATE_ALL,"'MXA_PREVIEW_',itoa(currentDvxInput)")
			}
			
			
		}
		case 3:
		{
			// do nothing - just waiting until the next switch
		}
	}
}
/*
button_event[dvTpSnapshotPreview,btnsVideoSnapshotPreviews]
{
	hold[waitTimeVideoPreview]:
	{
		loadVideoPreviewWindow (dvDvxVidInPorts[get_last(btnsVideoSnapshotPreviews)])
	}
}*/


data_event[virtual]
{
	command:
	{
		stack_var char header[50]
		
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::data_event[virtual] - command'"
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::data.text = ',data.text"
		
		header = remove_string(data.text,DELIM_HEADER,1)
		
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::data.text = ',data.text"
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::header = ',header"
		
		if (!length_array(header))
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__)"
			switch (data.text)
			{
				case 'STOP_VIDEO_PREVIEW':
				{
					send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__)"
					// turn off the video being previewed flag
					isVideoBeingPreviewed = FALSE
					// delete video snapshot on the video preview button
					moderoDeleteButtonVideoSnapshot (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL)
					moderoSetButtonOpacity (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_INVISIBLE)
					startMultiPreviewSnapshots ()
				}
			}
		}
		else
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__)"
			switch (header)
			{
				case 'START_VIDEO_PREVIEW-':
				{
					// <input>
					integer input
					input = atoi(data.text)
					
					send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__)"
					
					loadVideoPreviewWindow (dvDvxVidInPorts[input])
				}
			}
		}
	}
}
