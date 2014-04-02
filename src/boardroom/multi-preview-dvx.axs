module_name='multi-preview-dvx' (dev virtual,
								 dev dvDvxVidOutMultiPreview, 
                                 dev dvTpSnapshotPreview, 
								 integer btnsVideoInputSnapshotPreviews[],     // address codes
								 integer btnAdrsVideoInputSnapshotPreviews[],  // address codes
								 integer btnAdrsVideoInputLabels[],            // address codes
								 integer btnAdrsVideoOutputSnapshotPreviews[], // address codes
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

// Override the dvx switcher input listener dev array from amx-dvx-listener
dev dvDvxMainPorts[1]

// Override the dvx video input listener dev array from amx-dvx-listener
dev dvDvxVidInPorts[DVX_MAX_VIDEO_INPUTS]



define_function setFlag (integer flag, integer boolean)
{
	flag = boolean
}

define_function integer getFlag (integer flag)
{
	return flag
}


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
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::define_function startMultiPreviewSnapshots ()'"
	
	if (getFlag(isVideoBeingPreviewed) == FALSE)	// only startup snapshots if live video is not being previewed
	{
		stack_var integer i
		stack_var integer isAtLeastOneValidSignal
		
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (getFlag(isVideoBeingPreviewed) == FALSE)'"
		
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to set variable isAtLeastOneValidSignal to FALSE'"
		setFlag (isAtLeastOneValidSignal, FALSE)
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::variable isAtLeastOneValidSignal has been set to FALSE'"
		
		// reset all timeline times back to zero
		for (i = 1; i<= DVX_MAX_VIDEO_INPUTS; i++)
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::for (i = 1; i<= DVX_MAX_VIDEO_INPUTS; i++).....i = <',itoa(i),'>'"
			if (dvx.videoInputs[i].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
			{
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (dvx.videoInputs[i].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)'"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to set variable isAtLeastOneValidSignal to TRUE'"
				setFlag (isAtLeastOneValidSignal, TRUE)
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::variable isAtLeastOneValidSignal has been set to TRUE'"
				break
			}
		}
		
		if (getFlag(isAtLeastOneValidSignal) == TRUE)
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (getFlag(isAtLeastOneValidSignal) == TRUE)'"
			if (!timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))
			{
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (!timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))'"
				
				set_length_array (tlTimes, max_length_array(tlTimes))
				
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to create the timeline (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)'"
				timeline_create (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS,
						tlTimes,
						length_array (tlTimes),
						timeline_absolute,
						timeline_repeat)
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::timeline created (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)'"
				
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to set variable snapshotsInProgress to TRUE'"
				setFlag (snapshotsInProgress, TRUE)
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::variable snapshotsInProgress has been set to TRUE'"
			}
			else
			{
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (!timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))....else'"
				
				// commented out for testing >>>>>>>>>>
				//timeline_reload (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS, tlTimes, length_array(tlTimes))
				// commented out for testing <<<<<<<<<<
				
				//////// commented in for testing >>>>>>>>>>
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to kill the timeline (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)'"
				timeline_kill (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::timeline killed (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)'"
				
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to create the timeline (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)'"
				timeline_create (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS,
						tlTimes,
						length_array (tlTimes),
						timeline_absolute,
						timeline_repeat)
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::timeline created (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)'"
				//////// commented in for testing <<<<<<<<<<
				
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to set variable snapshotsInProgress to TRUE'"
				setFlag (snapshotsInProgress, TRUE)
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to set variable snapshotsInProgress to TRUE'"
			}
		}
		else
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (getFlag(isAtLeastOneValidSignal) == TRUE).....else'"
			if (timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))
			{
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))'"
				
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to kill the timeline (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)'"
				timeline_kill (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::timeline killed (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)'"
				
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to set variable snapshotsInProgress to FALSE'"
				setFlag (snapshotsInProgress, FALSE)
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::variable snapshotsInProgress has been set to FALSE'"
			}
		}
	}
}

define_function stopMultiPreviewSnapshots ()
{
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::define_function stopMultiPreviewSnapshots ()'"
	
	if (timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))
	{
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))'"
		
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to set variable currentDvxInput to FALSE'"
		currentDvxInput = FALSE
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::variable currentDvxInput now set to FALSE'"
		
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to kill the timeline (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)'"
		timeline_kill (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::timeline has been killed (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)'"
	}
}

define_function stopLiveVideoPreview ()
{
	#warn '@TODO.....if neccessary?'
}

define_function startLiveVideoPreview (integer input)
{
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::define_function startLiveVideoPreview (integer input)'"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::input = ',itoa(input)"
	
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to call stopMultiPreviewSnapshots()'"
	// stop taking snapshots
	stopMultiPreviewSnapshots ()
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::finished calling stopMultiPreviewSnapshots()'"
	
	// delete video snapshot on the video preview button
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to call moderoDeleteButtonVideoSnapshot ()'"
	moderoDeleteButtonVideoSnapshot (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL)
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::finished call stopMultiPreviewSnapshots()'"
	
	moderoDisableButtonFeedback (dvTpSnapshotPreview, btnLoadingBarMultiState)    // reset the loading progress bar
	
	moderoSetButtonOpacity (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_INVISIBLE)
	moderoSetButtonShow (dvTpSnapshotPreview, btnAdrVideoPreviewLoadingMessage)
	moderoSetButtonShow (dvTpSnapshotPreview, btnAdrLoadingBar)
	
	moderoEnableButtonFeedback (dvTpSnapshotPreview, btnLoadingBarMultiState) //start the loading progress bar
	
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to switch video on the DVX. input (',itoa(dvDvxVidInPorts[input].port),') output (',itoa(dvDvxVidOutMultiPreview.port),')'"
	dvxSwitchVideoOnly (dvDvxSwitcher, dvDvxVidInPorts[input].port, dvDvxVidOutMultiPreview.port)
	
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to cancel a wait (WAIT_HIDE_VIDEO_LOADING_BUTTON)'"
	CANCEL_WAIT 'WAIT_HIDE_VIDEO_LOADING_BUTTON'
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to throw some code onto the wait stack (WAIT_HIDE_VIDEO_LOADING_BUTTON)'"
	WAIT waitTimeVideoLoading 'WAIT_HIDE_VIDEO_LOADING_BUTTON'
	{
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to run the code inside the wait (WAIT_HIDE_VIDEO_LOADING_BUTTON)'"
		moderoSetButtonHide (dvTpSnapshotPreview, btnAdrVideoPreviewLoadingMessage)
		moderoSetButtonHide (dvTpSnapshotPreview, btnAdrLoadingBar)
		moderoSetButtonOpacity (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_OPAQUE)
		//moderoSetButtonShow (dvTpSnapshotPreview, btnAdrVideoPreviewWindow)
	}
	
	// turn on the video being previed flag
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to set variable isVideoBeingPreviewed to TRUE'"
	setFlag (isVideoBeingPreviewed, TRUE)
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::variable isVideoBeingPreviewed now set to TRUE'"
}


#define INCLUDE_DVX_NOTIFY_SWITCH_CALLBACK
define_function dvxNotifySwitch (dev dvxPort1, char signalType[], integer input, integer output)
{
	// dvxPort1 is port 1 on the DVX.
	// signalType contains the type of signal that was switched ('AUDIO' or 'VIDEO')
	// input contains the source input number that was switched to the destination
	// output contains the destination output number that the source was switched to
	
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::define_function dvxNotifySwitch (dev dvxPort1, char signalType[], integer input, integer output)'"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dvxPort1 = ',itoa(dvxPort1.number),':',itoa(dvxPort1.port),':',itoa(dvxPort1.system)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::signalType = ',signalType"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::input = ',itoa(input)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::output = ',itoa(output)"
	
	switch (signalType)
	{
		case SIGNAL_TYPE_VIDEO:
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::switch (signalType)....case SIGNAL_TYPE_VIDEO'"
			dvx.switchStatusVideoOutputs[output] = input
			
			if (input == DVX_PORT_VID_IN_NONE)
			{
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (input == DVX_PORT_VID_IN_NONE)'"
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to set bitmap of button (address code ',itoa(btnAdrsVideoOutputSnapshotPreviews[output]),') to no image icon'"
				moderoSetButtonBitmap (dvTpSnapshotPreview, btnAdrsVideoOutputSnapshotPreviews[output], MODERO_BUTTON_STATE_ALL, imageFileNameNoVideo)
			}
			else
			{
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (input == DVX_PORT_VID_IN_NONE)....else'"
				/*moderoButtonCopyAttribute (dvTpSnapshotPreview, 
										   dvTpSnapshotPreview.port, 
										   btnAdrsVideoInputSnapshotPreviews[input], 
										   MODERO_BUTTON_STATE_OFF,
										   btnAdrsVideoOutputSnapshotPreviews[output], 
										   MODERO_BUTTON_STATE_ALL,
										   MODERO_BUTTON_ATTRIBUTE_BITMAP)*/
			}
		}
	}
}


#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_STATUS_CALLBACK
define_function dvxNotifyVideoInputStatus (dev dvxVideoInput, char signalStatus[])
{
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// signalStatus is the input signal status (DVX_SIGNAL_STATUS_NO_SIGNAL | DVX_SIGNAL_STATUS_UNKNOWN | DVX_SIGNAL_STATUS_VALID_SIGNAL)
	
	stack_var char oldSignalStatus[50]
	
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::define_function dvxNotifyVideoInputStatus (dev dvxVideoInput, char signalStatus[])'"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dvxVideoInput = ',itoa(dvxVideoInput.number),':',itoa(dvxVideoInput.port),':',itoa(dvxVideoInput.system)"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::signalStatus = ',signalStatus"
	
	oldSignalStatus = dvx.videoInputs[dvxVideoInput.port].status
	
	// only need to do anything if the signal status for this input has actually changed
	if (signalStatus != oldSignalStatus)
	{
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (signalStatus != oldSignalStatus)'"
		
		dvx.videoInputs[dvxVideoInput.port].status = signalStatus
		
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to start multi preview snapshots'"
		startMultiPreviewSnapshots ()
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::start multi preview snapshots complete'"
		
		switch (signalStatus)
		{
			case DVX_SIGNAL_STATUS_NO_SIGNAL:
			case DVX_SIGNAL_STATUS_UNKNOWN:
			{
				stack_var integer output
				
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::case DVX_SIGNAL_STATUS_NO_SIGNAL | case DVX_SIGNAL_STATUS_UNKNOWN'"
				
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to set bitmap of button (address code ',itoa(btnAdrsVideoOutputSnapshotPreviews[dvxVideoInput.port]),') to no image icon'"
				moderoSetButtonBitmap (dvTpSnapshotPreview, btnAdrsVideoInputSnapshotPreviews[dvxVideoInput.port],MODERO_BUTTON_STATE_ALL,imageFileNameNoVideo)
				
				for (output = 1; output <= DVX_MAX_VIDEO_OUTPUTS; output++)
				{
					if (dvx.switchStatusVideoOutputs[output] == dvxVideoInput.port)
					{
						/*moderoButtonCopyAttribute (dvTpSnapshotPreview, 
												   dvTpSnapshotPreview.port, 
												   btnAdrsVideoInputSnapshotPreviews[dvxVideoInput.port], 
												   MODERO_BUTTON_STATE_OFF,
												   btnAdrsVideoOutputSnapshotPreviews[output], 
												   MODERO_BUTTON_STATE_ALL,
												   MODERO_BUTTON_ATTRIBUTE_BITMAP)*/
					}
				}
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
			if (btnAdrCde == btnAdrsVideoInputSnapshotPreviews[i])
			{
				currentPreviewButtonBitmap[i] = bitmapName
			}
		}
	}
}

#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_NAME_CALLBACK
define_function dvxNotifyVideoInputName (dev dvxVideoInput, char name[])
{
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// name is the name of the video input
	moderoSetButtonText (dvTpSnapshotPreview, btnAdrsVideoInputLabels[dvxVideoInput.port], MODERO_BUTTON_STATE_ALL, name)
}


// Listener includes go below function definitions (IMPORTANT!!!)
#include 'amx-dvx-listener'
#include 'amx-modero-listener'




define_start

initDevice (dvTpPort1, dvTpSnapshotPreview.number, 1, dvTpSnapshotPreview.system)

// DVX Switcher
initDevice (dvDvxSwitcher, dvDvxVidOutMultiPreview.number, DVX_PORT_MAIN, dvDvxVidOutMultiPreview.system)

initDevice (dvDvxMainPorts[1], dvDvxSwitcher.number, dvDvxSwitcher.port, dvDvxSwitcher.system)
set_length_array (dvDvxMainPorts, 1)

// DVX Video Inputs
{
	stack_var integer number
	stack_var integer port
	stack_var integer system
	
	number = dvDvxVidOutMultiPreview.number
	system = dvDvxVidOutMultiPreview.system
	
	for (port = 1; port <= DVX_MAX_VIDEO_INPUTS; port++)
	{
		initDevice (dvDvxVidInPorts[port], number, port, system)
	}
	
	set_length_array (dvDvxVidInPorts, DVX_MAX_VIDEO_INPUTS)
}


addDeviceToDevArray (dvPanelsButtons, dvTpSnapshotPreview)

rebuild_event()



define_event

data_event[dvDvxSwitcher]
{
	online:
	{
		dvxRequestVideoInputStatusAll (dvDvxSwitcher)
		dvxRequestVideoInputNameAll (dvDvxSwitcher)
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
				moderoRequestButtonBitmapName (dvTpSnapshotPreview, btnAdrsVideoInputSnapshotPreviews[i], MODERO_BUTTON_STATE_OFF)
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
			moderoEnableButtonScaleToFit (dvTpSnapshotPreview, btnAdrsVideoInputSnapshotPreviews[i],MODERO_BUTTON_STATE_ALL)
		
		for (i=1; i<=DVX_MAX_VIDEO_INPUTS; i++)
		{
			// request bitmaps of sources
			moderoRequestButtonBitmapName (dvTpSnapshotPreview, btnAdrsVideoInputSnapshotPreviews[i], MODERO_BUTTON_STATE_OFF)
		}
		
		moderoSetButtonHide (dvTpSnapshotPreview, btnAdrVideoPreviewLoadingMessage)
		moderoSetButtonHide (dvTpSnapshotPreview, btnAdrLoadingBar)
		
		// Setup video settings for MPL
		moderoSetMultiPreviewInputFormatAndResolution (data.device, MODERO_MULTI_PREVIEW_INPUT_FORMAT_HDMI, MODERO_MULTI_PREVIEW_INPUT_RESOLUTION_HDMI_720x480i30HZ)
		
		// Request Dvx Info
		dvxRequestVideoInputStatusAll (dvDvxSwitcher)
		dvxRequestVideoInputNameAll (dvDvxSwitcher)
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
}

timeline_event[TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS]
{
	local_var char dynamicImageName[30]
	
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::timeline_event[TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS]'"
	
	switch (timeline.sequence)
	{
		case 1:
		{
			stack_var integer i
			
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::switch (timeline.sequence)....case 1'"
			
			// set up dvx input to start from
			
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::currentDvxInput = ',itoa(currentDvxInput)"
			if (currentDvxInput == false)
			{
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (currentDvxInput == false)'"
				currentDvxInput = 1
			}
			
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::currentDvxInput = ',itoa(currentDvxInput)"
			
			for (i = currentDvxInput; i < currentDvxInput + DVX_MAX_VIDEO_INPUTS - 1; i++)
			{
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::for (i = currentDvxInput; i < currentDvxInput + DVX_MAX_VIDEO_INPUTS - 1; i++).....i = ',itoa(i)"
				
				if (dvx.videoInputs[((i % DVX_MAX_VIDEO_INPUTS) + 1)].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)
				{
					send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (dvx.videoInputs[((i % DVX_MAX_VIDEO_INPUTS) + 1)].status == DVX_SIGNAL_STATUS_VALID_SIGNAL)'"
					
					currentDvxInput = ((i % DVX_MAX_VIDEO_INPUTS) + 1)
					send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::currentDvxInput = ',itoa(currentDvxInput)"
					
					break	// exit the for loop
				}
			}
			
			moderoRequestButtonBitmapName (dvTpSnapshotPreview, btnAdrsVideoInputSnapshotPreviews[currentDvxInput], MODERO_BUTTON_STATE_OFF)
			
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to switch video on DVX (input ',itoa(currentDvxInput),' to output ',itoa(dvDvxVidOutMultiPreview.port),')'"
			dvxSwitchVideoOnly (dvDvxSwitcher, currentDvxInput, dvDvxVidOutMultiPreview.port)
		}
		case 2:
		{
			stack_var integer output
			
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::switch (timeline.sequence)....case 2'"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::currentDvxInput = ',itoa(currentDvxInput)"
			
			dynamicImageName = "'MXA_PREVIEW_',itoa(currentDvxInput)"
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::dynamicImageName = ',dynamicImageName"
			
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to set panel to enable automatic reloading/refreshing of dynamic resource (',dynamicImageName,') on view'"
			moderoEnableResourceReloadOnView (dvTpSnapshotPreview, dynamicImageName)
			
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to force a refresh of the dynamic resource (',dynamicImageName,')'"
			moderoResourceForceRefreshPrefetchFromCache (dvTpSnapshotPreview, dynamicImageName, MODERO_RESOURCE_NOTIFICATION_OFF)
			
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to set panel to disable automatic reloading/refreshing of dynamic resource (',dynamicImageName,') on view'"
			moderoDisableResourceReloadOnView (dvTpSnapshotPreview, dynamicImageName)
			
			// only need to set the button bitmap the first time the resource is loaded
			if (currentPreviewButtonBitmap[currentDvxInput] != dynamicImageName)
			{
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (currentPreviewButtonBitmap[currentDvxInput] != dynamicImageName)'"
				
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::about to set bitmap of button (address code ',itoa(btnAdrsVideoInputSnapshotPreviews[currentDvxInput]),') to dynamic resource (MXA_PREVIEW_',itoa(currentDvxInput),')'"
				moderoSetButtonBitmapResource (dvTpSnapshotPreview, btnAdrsVideoInputSnapshotPreviews[currentDvxInput],MODERO_BUTTON_STATE_ALL,"'MXA_PREVIEW_',itoa(currentDvxInput)")
			}
			
			for (output = 1; output <= DVX_MAX_VIDEO_OUTPUTS; output++)
			{
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::for (output = 1; output <= DVX_MAX_VIDEO_OUTPUTS; output++)......output = ',itoa(output)"
				
				if (dvx.switchStatusVideoOutputs[output] == currentDvxInput)
				{
					send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (dvx.switchStatusVideoOutputs[output] == currentDvxInput)'"
					/*moderoButtonCopyAttribute (dvTpSnapshotPreview, 
											   dvTpSnapshotPreview.port, 
											   btnAdrsVideoInputSnapshotPreviews[currentDvxInput], 
											   MODERO_BUTTON_STATE_OFF,
											   btnAdrsVideoOutputSnapshotPreviews[output], 
											   MODERO_BUTTON_STATE_ALL,
											   MODERO_BUTTON_ATTRIBUTE_BITMAP)*/
				}
			}
		}
		case 3:
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::switch (timeline.sequence)....case 3'"
			// do nothing - just waiting until the next switch
		}
	}
}

data_event[virtual]
{
	command:
	{
		stack_var char header[50]
		
		header = remove_string(data.text,DELIM_HEADER,1)
		
		if (!length_array(header))
		{
			switch (data.text)
			{
				case 'STOP_VIDEO_PREVIEW':
				{
					// turn off the video being previewed flag
					setFlag (isVideoBeingPreviewed, FALSE)
					// delete video snapshot on the video preview button
					moderoDeleteButtonVideoSnapshot (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL)
					moderoSetButtonOpacity (dvTpSnapshotPreview, btnAdrVideoPreviewWindow, MODERO_BUTTON_STATE_ALL, MODERO_OPACITY_INVISIBLE)
					//moderoSetButtonHide (dvTpSnapshotPreview, btnAdrVideoPreviewWindow)
					startMultiPreviewSnapshots ()
				}
			}
		}
		else
		{
			switch (header)
			{
				case 'START_VIDEO_PREVIEW-':
				{
					// <input>
					integer input
					input = atoi(data.text)
					
					//loadVideoPreviewWindow (dvDvxVidInPorts[input])
					startLiveVideoPreview (input)
				}
			}
		}
	}
}
