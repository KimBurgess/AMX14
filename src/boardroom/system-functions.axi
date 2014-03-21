program_name='system-functions'

#if_not_defined __SYSTEM_FUNCTIONS__
#define __SYSTEM_FUNCTIONS__

#include 'system-devices'
#include 'system-structures'
#include 'system-constants'
#include 'system-variables'
#include 'system-library-api'
#include 'system-library-control'


/*
 * --------------------
 * System functions
 * --------------------
 */


define_function resetDraggablePopup (dev dragAndDropVirtual, integer id)
{
	hideDraggablePopup (dragAndDropVirtual, id)
	showDraggablePopup (dragAndDropVirtual, id)
}

define_function hideDraggablePopup (dev dragAndDropVirtual, integer id)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDrop19):
		{
			moderoDisablePopup (dvTpDragAndDrop19, draggablePopups19[id])
		}
		
		active (dragAndDropVirtual == vdvDragAndDrop10):
		{
			moderoDisablePopup (dvTpDragAndDrop10, draggablePopups10[id])
		}
	}
}

define_function hideAllDraggablePopups (dev dragAndDropVirtual)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDrop19):
		{
			hideDraggablePopup (vdvDragAndDrop19, dvDvxVidIn1.port)
			hideDraggablePopup (vdvDragAndDrop19, dvDvxVidIn5.port)
			hideDraggablePopup (vdvDragAndDrop19, dvDvxVidIn6.port)
			hideDraggablePopup (vdvDragAndDrop19, dvDvxVidIn7.port)
			hideDraggablePopup (vdvDragAndDrop19, dvDvxVidIn8.port)
		}
		
		active (dragAndDropVirtual == vdvDragAndDrop10):
		{
			hideDraggablePopup (vdvDragAndDrop10, dvDvxVidInTableDisplayPort.port)
			hideDraggablePopup (vdvDragAndDrop10, dvDvxVidInTableHdmi1.port)
			hideDraggablePopup (vdvDragAndDrop10, dvDvxVidInTableHdmi2.port)
			hideDraggablePopup (vdvDragAndDrop10, dvDvxVidInTableVga.port)
		}
	}
}

define_function showDraggablePopup (dev dragAndDropVirtual, integer id)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDrop19):
		{
			moderoEnablePopup (dvTpDragAndDrop19, draggablePopups19[id])
		}
		
		active (dragAndDropVirtual == vdvDragAndDrop10):
		{
			moderoEnablePopup (dvTpDragAndDrop10, draggablePopups10[id])
		}
	}
}

define_function showDraggablePopupsAll (dev dragAndDropVirtual)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDrop19):
		{
			showDraggablePopup (vdvDragAndDrop19, dvDvxVidIn1.port)
			showDraggablePopup (vdvDragAndDrop19, dvDvxVidIn5.port)
			showDraggablePopup (vdvDragAndDrop19, dvDvxVidIn6.port)
			showDraggablePopup (vdvDragAndDrop19, dvDvxVidIn7.port)
			showDraggablePopup (vdvDragAndDrop19, dvDvxVidIn8.port)
		}
		
		active (dragAndDropVirtual == vdvDragAndDrop10):
		{
			showDraggablePopup (vdvDragAndDrop10, dvDvxVidInTableDisplayPort.port)
			showDraggablePopup (vdvDragAndDrop10, dvDvxVidInTableHdmi1.port)
			showDraggablePopup (vdvDragAndDrop10, dvDvxVidInTableHdmi1.port)
			showDraggablePopup (vdvDragAndDrop10, dvDvxVidInTableVga.port)
		}
	}
}

define_function enableDragItem (dev dragAndDropVirtual, integer id)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDrop19):
		{
			sendCommand (vdvDragAndDrop19, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(id, dragAreas19[id])")
		}
		
		active (dragAndDropVirtual == vdvDragAndDrop10):
		{
			sendCommand (vdvDragAndDrop10, "'DEFINE_DRAG_ITEM-',buildDragAndDropParameterString(id, dragAreas10[id])")
		}
	}
}


define_function enableDragItemsAll (dev dragAndDropVirtual)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDrop19):
		{
			enableDragItem (vdvDragAndDrop19, dvDvxVidIn1.port)
			enableDragItem (vdvDragAndDrop19, dvDvxVidIn5.port)
			enableDragItem (vdvDragAndDrop19, dvDvxVidIn6.port)
			enableDragItem (vdvDragAndDrop19, dvDvxVidIn7.port)
			enableDragItem (vdvDragAndDrop19, dvDvxVidIn8.port)
		}
		
		active (dragAndDropVirtual == vdvDragAndDrop10):
		{
			enableDragItem (vdvDragAndDrop10, dvDvxVidInTableDisplayPort.port)
			enableDragItem (vdvDragAndDrop10, dvDvxVidInTableHdmi1.port)
			enableDragItem (vdvDragAndDrop10, dvDvxVidInTableHdmi2.port)
			enableDragItem (vdvDragAndDrop10, dvDvxVidInTableVga.port)
		}
	}
}


define_function disableDragItem (dev dragAndDropVirtual, integer id)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDrop19):
		{
			sendCommand (vdvDragAndDrop19, "'DELETE_DRAG_ITEM-',itoa(id)")
		}
		
		active (dragAndDropVirtual == vdvDragAndDrop10):
		{
			sendCommand (vdvDragAndDrop10, "'DELETE_DRAG_ITEM-',itoa(id)")
		}
	}
}


define_function disableDragItemsAll (dev dragAndDropVirtual)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDrop19):
		{
			disableDragItem (vdvDragAndDrop19, dvDvxVidIn1.port)
			disableDragItem (vdvDragAndDrop19, dvDvxVidIn5.port)
			disableDragItem (vdvDragAndDrop19, dvDvxVidIn6.port)
			disableDragItem (vdvDragAndDrop19, dvDvxVidIn7.port)
			disableDragItem (vdvDragAndDrop19, dvDvxVidIn8.port)
		}
		
		active (dragAndDropVirtual == vdvDragAndDrop10):
		{
			disableDragItem (vdvDragAndDrop10, dvDvxVidInTableDisplayPort.port)
			disableDragItem (vdvDragAndDrop10, dvDvxVidInTableHdmi1.port)
			disableDragItem (vdvDragAndDrop10, dvDvxVidInTableHdmi2.port)
			disableDragItem (vdvDragAndDrop10, dvDvxVidInTableDisplayPort.port)
		}
	}
}

define_function disableDropArea (dev dragAndDropVirtual, integer id)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDrop19):
		{
			sendCommand (vdvDragAndDrop19, "'DELETE_DROP_AREA-',itoa(id)")
		}
		
		active (dragAndDropVirtual == vdvDragAndDrop10):
		{
			sendCommand (vdvDragAndDrop10, "'DELETE_DROP_AREA-',itoa(id)")
		}
	}
}

define_function disableDropAreasAll (dev dragAndDropVirtual)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDrop19):
		{
			disableDropArea (vdvDragAndDrop19, dvDvxVidOutMonitorLeft.port)
			disableDropArea (vdvDragAndDrop19, dvDvxVidOutMonitorRight.port)
			disableDropArea (vdvDragAndDrop19, dvDvxVidOutMultiPreview.port)
		}
		
		active (dragAndDropVirtual == vdvDragAndDrop10):
		{
			disableDropArea (vdvDragAndDrop10, dvDvxVidOutMonitorLeft.port)
			disableDropArea (vdvDragAndDrop10, dvDvxVidOutMonitorRight.port)
		}
	}
}

define_function enableDropArea (dev dragAndDropVirtual, integer id)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDrop19):
		{
			sendCommand (vdvDragAndDrop19, "'DEFINE_DROP_AREA-',buildDragAndDropParameterString(id, dropAreas19[id])")
		}
		
		// do not handle 10" panel in this function.
		// the 10" is a special case as the index number of the drodAreas array does not necessary correlate to the output number of the dvx.
		/*active (dragAndDropVirtual == vdvDragAndDrop10):
		{
			sendCommand (vdvDragAndDrop10, "'DEFINE_DROP_AREA-',buildDragAndDropParameterString(id, dropAreas10[id])")
		}*/
	}
}

define_function enableDropItemsAll (dev dragAndDropVirtual)
{
	select
	{
		active (dragAndDropVirtual == vdvDragAndDrop19):
		{
			enableDropArea (vdvDragAndDrop19, dvDvxVidOutMonitorLeft.port)
			enableDropArea (vdvDragAndDrop19, dvDvxVidOutMonitorRight.port)
			enableDropArea (vdvDragAndDrop19, dvDvxVidOutMultiPreview.port)
		}
		
		// do not handle 10" panel in this function.
		// the 10" is a special case as the index number of the drodAreas array does not necessary correlate to the output number of the dvx.
		/*active (dragAndDropVirtual == vdvDragAndDrop10):
		{
			enableDropArea (vdvDragAndDrop10, dvDvxVidOutMonitorLeft.port)
			enableDropArea (vdvDragAndDrop10, dvDvxVidOutMonitorRight.port)
		}*/
	}
}

define_function turnOnDisplay (dev virtual)
{
	snapiDisplayEnablePower (virtual)
}

define_function turnOffDisplay (dev virtual)
{
	snapiDisplayDisablePower (virtual)
}

define_function turnOnDisplaysAll ()
{
	turnOnDisplay (vdvMonitorLeft)
	turnOnDisplay (vdvMonitorRight)
}

define_function turnOffDisplaysAll ()
{
	turnOffDisplay (vdvMonitorLeft)
	turnOffDisplay (vdvMonitorRight)
}

define_function enableVideoPreview (integer input)
{
	sendCommand (vdvMultiPreview, "'START_VIDEO_PREVIEW-',itoa(input)")
}

define_function disableVideoPreview ()
{
	sendCommand (vdvMultiPreview, "'STOP_VIDEO_PREVIEW'")
}

define_function showSourceOnDisplay (integer input, integer output)
{
	// switch the video
	dvxSwitchVideoOnly (dvDvxMain, input, output)
	
	// disable any test patterns on the output of the dvx
	// turn on the monitor
	select
	{
		active (output == dvDvxVidOutMonitorLeft.port):
		{
			dvxSetVideoOutputTestPattern (dvDvxVidOutMonitorLeft, DVX_TEST_PATTERN_OFF)
			turnOnDisplay (vdvMonitorLeft)
		}
		
		active (output == dvDvxVidOutMonitorRight.port):
		{
			dvxSetVideoOutputTestPattern (dvDvxVidOutMonitorRight, DVX_TEST_PATTERN_OFF)
			turnOnDisplay (vdvMonitorRight)
		}
	}
	
	// set flag to indicate that system is in use
	setFlagAvSystemInUse (TRUE)
}

define_function setFlagAvSystemInUse (integer boolean)
{
	isSystemAvInUse = boolean
}

define_function setFlagSystemMode (integer mode)
{
	systemMode = mode
}


define_function selectVcMode ()
{
	// show VC main on left display and VC 2nd (camera) on right display
	showSourceOnDisplay (dvDvxVidInVcMain.port, dvDvxVidOutMonitorLeft.port)
	showSourceOnDisplay (dvDvxVidInVcCamera.port, dvDvxVidOutMonitorRight.port)
		
	// set lighting to vc preset
	#warn '@TODO'
	
	// set audio for both outputs to follow VC main
	
	// hide draggable popups on 19" panel
	hideAllDraggablePopups (vdvDragAndDrop19)
	
	// disable all drag items on 19" panel
	disableDragItemsAll (vdvDragAndDrop19)
	
	// turn off the drag and drop expanded drop area animation channel on the 19" panel
	channelOff (dvTpTableDebug, 1)
	
	// stop live video streaming from the MPL
	disableVideoPreview ()
	
	// apply feedback to vc mode select button
	channelOn (dvTpTableMain, BTN_MAIN_VIDEO_CONFERENCE)
	
	// set flag to indicate that system is in use
	setFlagAvSystemInUse (TRUE)

	// lastly, update the system mode variable
	setFlagSystemMode (SYSTEM_MODE_VIDEO_CONFERENCE)
}

define_function selectPresentationMode ()
{
	// turn off the test pattern on left and right screen
	#warn '@TODO'
	
	// set lighting to presentation preset
	#warn '@TODO'
	
	// if not already in presentation mode:
	if (systemMode != SYSTEM_MODE_PRESENTATION)
	{
		//	- hide all popups
		#warn '@TODO'
		
		//	- flip to user page
		#warn '@TODO'
		
		// if coming out of VC mode
		if (systemMode = SYSTEM_MODE_VIDEO_CONFERENCE)
		{
			dvxSetVideoOutputTestPattern (dvDvxVidOutMonitorLeft, DVX_TEST_PATTERN_LOGO_2)
			dvxSetVideoOutputTestPattern (dvDvxVidOutMonitorRight, DVX_TEST_PATTERN_LOGO_2)
		}
	}
	
	//	- show all draggable popups on 19" panel
	showDraggablePopupsAll (vdvDragAndDrop19)
	
	// enable all drag items on 19" panel
	enableDragItemsAll (vdvDragAndDrop19)
	
	// turn off the drag and drop expanded drop area animation channel on the 19" panel
	channelOff (dvTpTableDebug, 1)
	
	// stop live video streaming from the MPL
	disableVideoPreview ()
	
	// apply feedback to presentation mode select button
	channelOn (dvTpTableMain, BTN_MAIN_PRESENTATION)

	// lastly, update the system mode variable
	setFlagSystemMode (SYSTEM_MODE_PRESENTATION)
}

define_function showDragAndDropPopups (dev panel)
{
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','showDragAndDropPopups (dev panel)'"
	if (panel == dvTpTableMain)
	{
		stack_var integer i
		
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::'"
		for (i=1; i<=DVX_MAX_VIDEO_INPUTS; i++)
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::i = ',itoa(i)"
			if (dragAreas19[i].height and dragAreas19[i].width and dragAreas19[i].left and dragAreas19[i].top)
			{
				send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::if (true); i = ',itoa(i)"
				moderoEnablePopup (panel, "'draggable-source-',itoa(i)")
			}
		}
	}
}

define_function initArea (_area area, integer left, integer top, integer width, integer height)
{
	area.left = left
	area.top = top
	area.width = width
	area.height = height
}

define_function char[20] buildDragAndDropParameterString (integer id, _area area)
{
	return "itoa(id),',',itoa(area.left),',',itoa(area.top),',',itoa(area.width),',',itoa(area.height)"
}

/*
define_function recallCameraPreset (integer cameraPreset)
{
	switch (cameraPreset)
	{
		case CAMERA_PRESET_1:	channelPulse (dvPtzCam, CAM1_PRESET_1)
		case CAMERA_PRESET_2:   channelPulse (dvPtzCam, CAM1_PRESET_2)
		case CAMERA_PRESET_3:   channelPulse (dvPtzCam, CAM1_PRESET_3)
	}
}
*/
/*
define_function startMultiPreviewSnapshots ()
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
}


define_function stopMultiPreviewSnapshots ()
{
	if (timeline_active(TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS))
	{
		timeline_kill (TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS)
		CANCEL_WAIT 'WAIT_MULTI_PREVIEW_SNAPSHOT'
	}
}
*/

define_function shutdownAvSystem ()
{
	// Blinds - raise blockouts and shades
	amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_UP)
	amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_UP)
	amxRelayPulse (dvRelaysRelBox, REL_SHADES_CORNER_WINDOW_UP)
	amxRelayPulse (dvRelaysRelBox, REL_SHADES_WALL_WINDOW_UP)
	
	// Lights - recall the "all off" preset
	lightsEnablePresetAllOff ()
	
	
	channelOff (dvTpTableDebug, 1)
	sendCommand (vdvMultiPreview, "'STOP_VIDEO_PREVIEW'")
	
	// Video - Turn the monitors off and switch input "none" to the monitor and multi-preview outputs on the DVX
	snapiDisplayDisablePower (vdvMonitorLeft)
	snapiDisplayDisablePower (vdvMonitorRight)
	
	dvxSwitchVideoOnly (dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMonitorLeft.port)
	dvxSwitchVideoOnly (dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMonitorRight.port)
	dvxSwitchVideoOnly (dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMultiPreview.port)
	
	// Audio - Switch input "none" to the speaker output on the DVX, unmute the audio and reset the volume to a base level for next use
	dvxSwitchAudioOnly (dvDvxMain, DVX_PORT_AUD_IN_NONE, dvDvxAudOutSpeakers.port)
	dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
	dvxDisableAudioOutputMute (dvDvxAudOutSpeakers)
	
	// stop taking snapshots (no point constantly switching on the DVX anymore)
	//stopMultiPreviewSnapshots ()
	
	// reset Camera position
	irPulse (dvPtzCam, CAM1_HOME)
	
	
	// set flag to indicate that system is not in use
	isSystemAvInUse = FALSE
	
	// clear flags keeping track of selected video/audio inputs
	selectedVideoInputMonitorLeft = FALSE
	selectedVideoInputMonitorRight = FALSE
	selectedAudioInput = FALSE
	audioFollowingVideoOutput = FALSE
	systemMode = SYSTEM_MODE_AV_OFF
}


/*
 * Reports a valid signal on DXLink MFTX HDMI input.
 * 
 * Need to be a little bit careful here. This could be an indicator to tell us someone 
 * has just plugged a video source into a table HDMI input but it might also just be
 * a response to the signal status query that we send to each MFTX when the DVX boots.
 * 
 * One thing we do know for sure is that if the AV system is already on and this notification 
 * comes through just do nothing.
 * 
 * We really only want to react to this notification if the system is off in which case 
 * we turn the system on and route the DVX to the appropriate DXLink input corresponding 
 * to the MFTX that triggered this notification MFTX.
 */
define_function tableInputDetected (dev dvTxVidIn)
{
	#warn '@BUG: amx-au-gc-boardroom-main'
	
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','tableInputDetected (dev dvTxVidIn)'"
	send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','dvTxVidIn = ',itoa(dvTxVidIn.number),':',itoa(dvTxVidIn.port),':',itoa(dvTxVidIn.system)"
	/*
	 * --------------------
	 * This code running as expected but the MFTX is reporting a valid signal twice when a new input is plugged in.
	 * 
	 * The result is that this function is getting called twice.
	 * 
	 * If a new laptop input is plugged in when the system is off this function gets called the first time the MFTX reports
	 * a valid signal and routes the newly found laptop video to the left monitor.
	 * 
	 * But then the MFTX reports a valid signal again so this function gets called again. This time teh system is already on
	 * and nothing is routed to the right monitor so this function sends the laptop to the right monitor.
	 * 
	 * In effect, what the user sees is that when the plug in their laptop it comes on on both screens.
	 * 
	 * Not really an issue as far as the user is concerned (they may think the system is designed to do just that) but it's
	 * not what I want to happen!
	 * --------------------
	 */
	
	
	cancel_wait 'WAITING_TO_MAKE_SURE_ROOM_IS_EMPTY'
	
	if (!isSystemAvInUse)
	{
		stack_var integer input
		
		input = dvTxVidIn.port
		
		/*select
		{
			active (dvTxVidIn == dvTxTable1VidInDigital):    input = dvDvxVidInTx1.port
			active (dvTxVidIn == dvTxTable1VidInAnalog):     input = dvDvxVidInTx1.port
			
			active (dvTxVidIn == dvTxTable2VidInDigital):    input = dvDvxVidInTx2.port
			active (dvTxVidIn == dvTxTable2VidInAnalog):     input = dvDvxVidInTx2.port
			
			active (dvTxVidIn == dvTxTable3VidInDigital):    input = dvDvxVidInTx3.port
			active (dvTxVidIn == dvTxTable3VidInAnalog):     input = dvDvxVidInTx3.port
			
			active (dvTxVidIn == dvTxTable4VidInDigital):    input = dvDvxVidInTx4.port
			active (dvTxVidIn == dvTxTable4VidInAnalog):     input = dvDvxVidInTx4.port
		}*/
		
		// route the DVX input for this TX to the DVX output for the left monitor
		dvxSwitchVideoOnly (dvDvxMain, input, dvDvxVidOutMonitorLeft.port)
		// route the audio from the DVX input for this TX to the DVX output for the speakers
		dvxSwitchAudioOnly (dvDvxMain, input, dvDvxAudOutSpeakers.port)
		// set the flag to show that the audio is following the left screen
		audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
		
		// lower the shades, raise the blockouts
		amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_UP)
		amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_UP)
		amxRelayPulse (dvRelaysRelBox, REL_SHADES_CORNER_WINDOW_DN)
		amxRelayPulse (dvRelaysRelBox, REL_SHADES_WALL_WINDOW_DN)
		
		// set up a nice lighting atmosphere for viewing the video
		lightsSetLevelWithFade (LIGHTING_ADDRESS_BOARDROOM, LIGHTING_LEVEL_40_PERCENT,5)
		
		// Set lights to "all on" mode as people have entered the room
		lightsEnablePresetAllOn ()
		
		// turn on the left monitor
		snapiDisplayEnablePower (vdvMonitorLeft)
		
		// wake up the touch panel
		moderoWake (dvTpTableMain)
		
		// flip the panel to the main page
		moderoSetPage (dvTpTableMain, PAGE_NAME_MAIN_USER)
		// show the source selection / volume control page
		moderoEnablePopup (dvTpTableMain, POPUP_NAME_SOURCE_SELECTION)
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::'"
		showDragAndDropPopups (dvTpTableMain)
		
		// set the flag to show that the AV system is now in use
		isSystemAvInUse = TRUE
		systemMode = SYSTEM_MODE_PRESENTATION
	}
	// system is in use
	else
	{
		if (systemMode = SYSTEM_MODE_PRESENTATION)
		{
			// is there a monitor not being used?
			if (selectedVideoInputMonitorLeft == DVX_PORT_VID_IN_NONE)
			{
				stack_var integer input
				
				select
				{
					active (dvTxVidIn == dvTxTable1VidInDigital):    input = dvDvxVidInTx1.port
					active (dvTxVidIn == dvTxTable1VidInAnalog):     input = dvDvxVidInTx1.port
					
					active (dvTxVidIn == dvTxTable2VidInDigital):    input = dvDvxVidInTx2.port
					active (dvTxVidIn == dvTxTable2VidInAnalog):     input = dvDvxVidInTx2.port
					
					active (dvTxVidIn == dvTxTable3VidInDigital):    input = dvDvxVidInTx3.port
					active (dvTxVidIn == dvTxTable3VidInAnalog):     input = dvDvxVidInTx3.port
					
					active (dvTxVidIn == dvTxTable4VidInDigital):    input = dvDvxVidInTx4.port
					active (dvTxVidIn == dvTxTable4VidInAnalog):     input = dvDvxVidInTx4.port
				}
				
				// route the DVX input for this TX to the DVX output for the left monitor
				dvxSwitchVideoOnly (dvDvxMain, input, dvDvxVidOutMonitorLeft.port)
				
				// audio
				if (  (selectedAudioInput == DVX_PORT_AUD_IN_NONE) or
					  ((audioFollowingVideoOutput == dvDvxVidOutMonitorRight.port) and (signalStatusDvxInputMonitorRight != DVX_SIGNAL_STATUS_VALID_SIGNAL))  )
				{
					audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
				}
				
				if (audioFollowingVideoOutput == dvDvxVidOutMonitorLeft.port)
				{
					dvxSwitchAudioOnly (dvDvxMain, input, dvDvxAudOutSpeakers.port)
				}
				
				// turn on the left monitor
				snapiDisplayEnablePower (vdvMonitorLeft)
			}
			else if (selectedVideoInputMonitorRight == DVX_PORT_VID_IN_NONE)
			{
				stack_var integer input
				
				select
				{
					active (dvTxVidIn == dvTxTable1VidInDigital):    input = dvDvxVidInTx1.port
					active (dvTxVidIn == dvTxTable1VidInAnalog):     input = dvDvxVidInTx1.port
					
					active (dvTxVidIn == dvTxTable2VidInDigital):    input = dvDvxVidInTx2.port
					active (dvTxVidIn == dvTxTable2VidInAnalog):     input = dvDvxVidInTx2.port
					
					active (dvTxVidIn == dvTxTable3VidInDigital):    input = dvDvxVidInTx3.port
					active (dvTxVidIn == dvTxTable3VidInAnalog):     input = dvDvxVidInTx3.port
					
					active (dvTxVidIn == dvTxTable4VidInDigital):    input = dvDvxVidInTx4.port
					active (dvTxVidIn == dvTxTable4VidInAnalog):     input = dvDvxVidInTx4.port
				}
				
				// route the DVX input for this TX to the DVX output for the right monitor
				dvxSwitchVideoOnly (dvDvxMain, input, dvDvxVidOutMonitorRight.port)
				
				// audio
				if (  (selectedAudioInput == DVX_PORT_AUD_IN_NONE) or
					  ((audioFollowingVideoOutput == dvDvxVidOutMonitorLeft.port) and (signalStatusDvxInputMonitorLeft != DVX_SIGNAL_STATUS_VALID_SIGNAL))    )
				{
					audioFollowingVideoOutput = dvDvxVidOutMonitorRight.port
				}
				
				if (audioFollowingVideoOutput == dvDvxVidOutMonitorRight.port)
				{
					dvxSwitchAudioOnly (dvDvxMain, input, dvDvxAudOutSpeakers.port)
				}
				
				// turn on the right monitor
				snapiDisplayEnablePower (vdvMonitorRight)
			}
		}
	}
}



/*
 * --------------------
 * Lighting functions
 * --------------------
 */

define_function lightsEnablePresetAllOn()
{
	lightsSetLevelWithFade (LIGHTING_ADDRESS_BOARDROOM, 100, 1)
}

define_function lightsEnablePresetAllOff()
{
	lightsSetLevelWithFade (LIGHTING_ADDRESS_BOARDROOM, 0, 10)
}

define_function lightsEnablePresetAllDim()
{
	lightsSetLevelWithFade (LIGHTING_ADDRESS_BOARDROOM, 20, 2)
}

define_function lightsEnablePresetPresentation()
{
	lightsSetLevelWithFade (LIGHTING_ADDRESS_BOARDROOM, 80, 2)
}

define_function lightsEnablePresetVc()
{
	lightsSetLevelWithFade (LIGHTING_ADDRESS_BOARDROOM, 60, 2)
}



/*
 * --------------------
 * Override modero-listener callback functions
 * --------------------
 */

#define INCLUDE_MODERO_NOTIFY_BUTTON_BITMAP_NAME
define_function moderoNotifyButtonBitmapName (dev panel, integer btnAdrCde, integer nbtnState, char bitmapName[])
{
	// panel is the touch panel
	// btnAdrCde is the button address code
	// btnState is the button state
	// bitmapName is the name of the image assigned to the button
	
	if (panel == dvTpDragAndDrop10)
	{
		switch (btnAdrCde)
		{
			case BTN_DRAG_ITEM_SOURCE_HDMI_1:	    draggableItemBitmapNames[dvDvxVidInTableHdmi1.port] = bitmapName
			case BTN_DRAG_ITEM_SOURCE_HDMI_2:	    draggableItemBitmapNames[dvDvxVidInTableHdmi2.port] = bitmapName
			case BTN_DRAG_ITEM_SOURCE_VGA:	        draggableItemBitmapNames[dvDvxVidInTableVga.port] = bitmapName
			case BTN_DRAG_ITEM_SOURCE_DISPLAYPORT:	draggableItemBitmapNames[dvDvxVidInTableDisplayPort.port] = bitmapName
		}
	}
}




/*
 * --------------------
 * Override dvx-listener callback functions
 * --------------------
 */

#define INCLUDE_DVX_NOTIFY_SWITCH_CALLBACK
define_function dvxNotifySwitch (dev dvxPort1, char signalType[], integer input, integer output)
{
	// dvxPort1 is port 1 on the DVX.
	// signalType contains the type of signal that was switched ('AUDIO' or 'VIDEO')
	// input contains the source input number that was switched to the destination
	// output contains the destination output number that the source was switched to
	
	switch (signalType)
	{
		case SIGNAL_TYPE_VIDEO:
		{
			select
			{
				active (output == dvDvxVidOutMonitorLeft.port):     selectedVideoInputMonitorLeft = input
				
				active (output == dvDvxVidOutMonitorRight.port):    selectedVideoInputMonitorRight = input
			}
		}
		case SIGNAL_TYPE_AUDIO:
		{
			select
			{
				active (output == dvDvxAudOutSpeakers.port):    selectedAudioInput = input
			}
		}
	}
}


#define INCLUDE_DVX_NOTIFY_VIDEO_INPUT_NAME_CALLBACK
define_function dvxNotifyVideoInputName (dev dvxVideoInput, char name[])
{
	// dvxVideoInput is the D:P:S of the video input port on the DVX switcher. The input number can be taken from dvxVideoInput.PORT
	// name is the name of the video input
	
	//moderoSetButtonText (dvTpTableVideo, btnsVideoInputsMonitorLeft[dvxVideoInput.port], MODERO_BUTTON_STATE_ALL, name)
	//moderoSetButtonText (dvTpTableVideo, btnsVideoInputsMonitorRight[dvxVideoInput.port], MODERO_BUTTON_STATE_ALL, name)
	
	dvx.videoInputs[dvxVideoInput.port].name = name
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
		//startMultiPreviewSnapshots ()
		
		if (signalStatus == DVX_SIGNAL_STATUS_VALID_SIGNAL)
		{
			if ( (dvxVideoInput == dvDvxVidInTx1) OR
			     (dvxVideoInput == dvDvxVidInTx2) OR
			     (dvxVideoInput == dvDvxVidInTx3) OR
			     (dvxVideoInput == dvDvxVidInTx4) )
			{
				tableInputDetected (dvxVideoInput)
			}
		}
	}
	
	/*
	switch (signalStatus)
	{
		case DVX_SIGNAL_STATUS_NO_SIGNAL:
		case DVX_SIGNAL_STATUS_UNKNOWN:
		{
			moderoSetButtonBitmap (dvTpTableVideo, BTN_ADRS_VIDEO_MONITOR_LEFT_INPUT_SELECTION[dvxVideoInput.port],MODERO_BUTTON_STATE_ALL,IMAGE_FILE_NAME_NO_IMAGE_ICON)
			moderoSetButtonBitmap (dvTpTableVideo, BTN_ADRS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION[dvxVideoInput.port],MODERO_BUTTON_STATE_ALL,IMAGE_FILE_NAME_NO_IMAGE_ICON)
		}
		case DVX_SIGNAL_STATUS_VALID_SIGNAL:
		{
			moderoEnableButtonScaleToFit (dvTpTableVideo, BTN_ADRS_VIDEO_MONITOR_LEFT_INPUT_SELECTION[dvxVideoInput.port],MODERO_BUTTON_STATE_ALL)
			moderoEnableButtonScaleToFit (dvTpTableVideo, BTN_ADRS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION[dvxVideoInput.port],MODERO_BUTTON_STATE_ALL)
			
			// NOTE: Don't set the dynamic resource here. That should be done by the timeline event for taking snapshots.
			// Otherwise it could result in the snapshots image of the currently routed video to the MPL being shown on all snapshot buttons.
			
		}
	}*/
	
	if (dvxVideoInput.port == selectedVideoInputMonitorLeft)
	{
		signalStatusDvxInputMonitorLeft = signalStatus
	}
	if (dvxVideoInput.port == selectedVideoInputMonitorRight)
	{
		signalStatusDvxInputMonitorRight = signalStatus
	}
	
	// Energy saving - switch off monitors when signal has been disconnected for some time
	// if signal
	switch (signalStatus)
	{
		case DVX_SIGNAL_STATUS_VALID_SIGNAL:
		{
			if (dvxVideoInput.port == selectedVideoInputMonitorLeft)
			{
				cancel_wait 'WAIT_FOR_SIGNAL_OF_INPUT_ROUTED_TO_LEFT_MONITOR_TO_RETURN'
				
			}
			if (dvxVideoInput.port == selectedVideoInputMonitorRight)
			{
				cancel_wait 'WAIT_FOR_SIGNAL_OF_INPUT_ROUTED_TO_RIGHT_MONITOR_TO_RETURN'
			}
		}
		case DVX_SIGNAL_STATUS_NO_SIGNAL:
		{
			if (dvxVideoInput.port == selectedVideoInputMonitorLeft)
			{
				wait waitTimeValidSignal 'WAIT_FOR_SIGNAL_OF_INPUT_ROUTED_TO_LEFT_MONITOR_TO_RETURN'
				{
					snapiDisplayDisablePower (vdvMonitorLeft)
					dvxSwitchVideoOnly (dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMonitorLeft.port)
					off [selectedVideoInputMonitorLeft]
					
					if (audioFollowingVideoOutput == dvDvxVidOutMonitorLeft.port)
					{
						if (signalStatusDvxInputMonitorRight == DVX_SIGNAL_STATUS_VALID_SIGNAL)
						{
							dvxSwitchAudioOnly (dvDvxMain, selectedVideoInputMonitorRight, dvDvxAudOutSpeakers.port)
							audioFollowingVideoOutput = dvDvxVidOutMonitorRight.port
						}
						else
						{
							dvxSwitchAudioOnly (dvDvxMain, DVX_PORT_AUD_IN_NONE, dvDvxAudOutSpeakers.port)
							dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
							off [selectedAudioInput]
							off [audioFollowingVideoOutput]
						}
					}
				}
			}
			
			if (dvxVideoInput.port == selectedVideoInputMonitorRight)
			{
				wait waitTimeValidSignal 'WAIT_FOR_SIGNAL_OF_INPUT_ROUTED_TO_RIGHT_MONITOR_TO_RETURN'
				{
					snapiDisplayDisablePower (vdvMonitorRight)
					dvxSwitchVideoOnly (dvDvxMain, DVX_PORT_VID_IN_NONE, dvDvxVidOutMonitorRight.port)
					off [selectedVideoInputMonitorRight]
					
					if (audioFollowingVideoOutput == dvDvxVidOutMonitorRight.port)
					{
						if (signalStatusDvxInputMonitorLeft == DVX_SIGNAL_STATUS_VALID_SIGNAL)
						{
							dvxSwitchAudioOnly (dvDvxMain, selectedVideoInputMonitorLeft, dvDvxAudOutSpeakers.port)
							audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
						}
						else
						{
							dvxSwitchAudioOnly (dvDvxMain, DVX_PORT_AUD_IN_NONE, dvDvxAudOutSpeakers.port)
							dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
							off [selectedAudioInput]
							off [audioFollowingVideoOutput]
						}
					}
				}
			}
		}
	}
}


#define INCLUDE_DVX_NOTIFY_AUDIO_OUT_MUTE_CALLBACK
define_function dvxNotifyAudioOutMute (dev dvxAudioOutput, char muteStatus[])
{
	// dvxAudioOutput is the D:P:S of the video output port on the DVX switcher. The output number can be taken from dvDvxAudioOutput.PORT
	// muteStatus is the mute status (STATUS_ENABLE | STATUS_DISABLE)
	
	dvx.audioOutputs[dvxAudioOutput.port].muteStatus = muteStatus
	
	if (dvxAudioOutput == dvDvxAudOutSpeakers)
	{
		switch (muteStatus)
		{
			case STATUS_ENABLE:    moderoEnableButtonFeedback (dvTpTableAudio, BTN_AUDIO_VOLUME_MUTE)
			
			case STATUS_DISABLE:   moderoDisableButtonFeedback (dvTpTableAudio, BTN_AUDIO_VOLUME_MUTE)
		}
	}
}


#define INCLUDE_DVX_NOTIFY_AUDIO_OUT_VOLUME_CALLBACK
define_function dvxNotifyAudioOutVolume (dev dvxAudioOutput, integer volume)
{
	// dvxAudioOutput is the D:P:S of the video output port on the DVX switcher. The output number can be taken from dvDvxAudioOutput.PORT
	// volume is the volume value (range: 0 to 100)
	
	dvx.audioOutputs[dvxAudioOutput.port].volume = volume
	
	if (dvxAudioOutput == dvDvxAudOutSpeakers)
	{
		send_level dvTpTableAudio, BTN_LVL_VOLUME_DISPLAY, volume
	}
}

#define INCLUDE_DVX_NOTIFY_AUDIO_OUT_MAXIMUM_VOLUME_CALLBACK
define_function dvxNotifyAudioOutMaximumVolume (dev dvxAudioOutput, integer maxVol)
{
	// dvxAudioOutput is the D:P:S of the video output port on the DVX switcher. The output number can be taken from dvDvxAudioOutput.PORT
	// maxVol is the maximum volume setting for the audio output port (range: 0 to 100)
	
	if (dvxAudioOutput == dvDvxAudOutSpeakers)
	{
		moderoSetButtonBargraphUpperLimit (dvTpTableAudio, BTN_ADR_VOLUME_BARGRAPH_CONTROL, /*MODERO_BUTTON_STATE_ALL,*/ maxVol)
		moderoSetButtonBargraphUpperLimit (dvTpTableAudio, BTN_ADR_VOLUME_BARGRAPH_DISPLAY, /*MODERO_BUTTON_STATE_ALL,*/ maxVol)
	}
}


/*
 * --------------------
 * Override dxlink-listener callback functions
 * --------------------
 */



#define INCLUDE_DXLINK_NOTIFY_TX_VIDEO_INPUT_STATUS_DIGITAL_CALLBACK
define_function dxlinkNotifyTxVideoInputStatusDigital (dev dxlinkTxDigitalVideoInput, char signalStatus[])
{
	// dxlinkTxDigitalVideoInput is the digital video input port on the DXLink Tx
	// signalStatus is the input signal status (DXLINK_SIGNAL_STATUS_NO_SIGNAL | DXLINK_SIGNAL_STATUS_UNKNOWN | DXLINK_SIGNAL_STATUS_VALID_SIGNAL)
	
	switch (signalStatus)
	{
		case DXLINK_SIGNAL_STATUS_UNKNOWN:    {}
		
		case DXLINK_SIGNAL_STATUS_NO_SIGNAL:  {}
		
		case DXLINK_SIGNAL_STATUS_VALID_SIGNAL:
		{
			tableInputDetected (dxlinkTxDigitalVideoInput)
		}
	}
}



/*
 * --------------------
 * Override pdu-listener callback functions
 * --------------------
 */


/*
#define INCLUDE_PDU_NOTIFY_OVER_CURRENT_CALLBACK
define_function pduNotifyOverCurrent (dev pduPort1, integer outlet, float current)
{
	// pduPort1 is port 1 on the PDU
	// outlet is the outlet of the PDU which is reporting overcurrent. If nPduOutlet is zero (0) then entire PDU is over current.
	// current is the current (in Amps)
}
*/

/*
#define INCLUDE_PDU_NOTIFY_PERSIST_STATE_ALL_OUTLETS_CALLBACK
define_function pduNotifyPersistStateAllOutlets (dev pduPort1, integer outletPersistStates[])
{
	// pduPort1 is port 1 on the PDU
	// outletPersistStates is an array containing the persist state of each outlet on the PDU
}
*/

#define INCLUDE_PDU_NOTIFY_POWER_SENSE_TRIGGER_CALLBACK
define_function pduNotifyPowerSenseTrigger (dev pduPort1, integer outlet, float triggerValue)
{
	// pduPort1 is port 1 on the PDU
	// outlet is the outlet of the PDU which is reporting the power sense trigger value
	// triggerValue is the power sense trigger value
	
	moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_TRIGGER[outlet], MODERO_BUTTON_STATE_ALL, ftoa(triggerValue))
}


#define INCLUDE_PDU_NOTIFY_OUTLET_OVER_POWER_SENSE_TRIGGER_CALLBACK
define_function pduNotifyOutletOverPowerSenseTrigger (dev pduOutletPort)
{
	// dvPduOutlet is an outlet device on the PDU which has gone over the power sense trigger value
	select
	{
		active (pduOutletPort == dvPduOutlet1):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[1], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet2):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[2], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet3):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[3], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet4):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[4], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet5):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[5], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet6):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[6], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet7):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[7], MODERO_BUTTON_STATE_ALL, 'Above')
		active (pduOutletPort == dvPduOutlet8):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[8], MODERO_BUTTON_STATE_ALL, 'Above')
	}
}


#define INCLUDE_PDU_NOTIFY_OUTLET_UNDER_POWER_SENSE_TRIGGER_CALLBACK
define_function pduNotifyOutletUnderPowerSenseTrigger (dev pduOutletPort)
{
	// pduOutletPort is an outlet device on the PDU which has gone under the power sense trigger value
	select
	{
		active (pduOutletPort == dvPduOutlet1):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[1], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet2):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[2], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet3):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[3], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet4):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[4], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet5):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[5], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet6):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[6], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet7):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[7], MODERO_BUTTON_STATE_ALL, 'Below')
		active (pduOutletPort == dvPduOutlet8):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_SENSE_STATUS[8], MODERO_BUTTON_STATE_ALL, 'Below')
	}
}


#define INCLUDE_PDU_NOTIFY_OUTLET_RELAY_CALLBACK
define_function pduNotifyOutletRelay (dev pduOutletPort, integer relayStatus)
{
	// dvPduOutlet is an outlet device on the PDU
	// nRelayStatus indicates whether the relay is on (TRUE) or off (FALSE)
	switch (relayStatus)
	{
		case TRUE:
		{
			select
			{
				active (pduOutletPort == dvPduOutlet1):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[1], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet2):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[2], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet3):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[3], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet4):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[4], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet5):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[5], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet6):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[6], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet7):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[7], MODERO_BUTTON_STATE_ALL, 'On')
				active (pduOutletPort == dvPduOutlet8):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[8], MODERO_BUTTON_STATE_ALL, 'On')
			}
		}
		case FALSE:
		{
			select
			{
				active (pduOutletPort == dvPduOutlet1):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[1], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet2):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[2], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet3):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[3], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet4):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[4], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet5):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[5], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet6):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[6], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet7):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[7], MODERO_BUTTON_STATE_ALL, 'Off')
				active (pduOutletPort == dvPduOutlet8):     moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_RELAY_STATUS[8], MODERO_BUTTON_STATE_ALL, 'Off')
			}
		}
	}
}


/*
#define INCLUDE_PDU_NOTIFY_SERIAL_NUMBER_CALLBACK
define_function fnPdyNotifySerialNumber (dev pduPort1, char serialNumber[])
{
	// pduPort1 is port 1 on the PDU
	// serialNumber is the serial number of the PDU
}
*/

/*
#define INCLUDE_PDU_NOTIFY_VERSION_CALLBACK
define_function pduNotifyVersion (dev pduPort1, float version)
{
	// pduPort1 is port 1 on the PDU
	// version is the version of firmware running on the PDU
}
*/

#define INCLUDE_PDU_NOTIFY_INPUT_VOLTAGE_CALLBACK
define_function pduNotifyInputVoltage (dev pduPort1, float voltage)
{
	// pduPort1 is the first device on the PDU
	// voltage is the input voltage (V): Resolution to 0.1V (data scale factor = 10)
	moderoSetButtonText (dvTpTablePower, BTN_ADR_POWER_INPUT_VOLTAGE, MODERO_BUTTON_STATE_ALL, ftoa(voltage))
}


#define INCLUDE_PDU_NOTIFY_TEMPERATURE_CALLBACK
define_function pduNotifyTemperature (dev pduPort1, float temperature)
{
	// pduPort1 is the first device on the PDU
	// temperature is the temperature (degrees C or F): Resolution to 0.1C (data scale factor = 10)
	moderoSetButtonText (dvTpTablePower, BTN_ADR_POWER_TEMPERATURE, MODERO_BUTTON_STATE_ALL, ftoa(temperature))
}


#define INCLUDE_PDU_NOTIFY_OUTLET_POWER_CALLBACK
define_function pduNotifyOutletPower (dev pduOutletPort, float wattage)
{
	// pduOutletPort is the outlet on the PDU reporting its power
	// wattage is the power (W): Resolution to 0.1W (data scale factor = 10)
	select
	{
		active (pduOutletPort == dvPduOutlet1):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[1], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet2):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[2], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet3):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[3], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet4):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[4], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet5):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[5], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet6):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[6], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet7):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[7], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
		active (pduOutletPort == dvPduOutlet8):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CONSUMPTION[8], MODERO_BUTTON_STATE_ALL, ftoa(wattage))
	}
}


#define INCLUDE_PDU_NOTIFY_OUTLET_CURRENT_CALLBACK
define_function pduNotifyOutletCurrent (dev pduOutletPort, float current)
{
	// pduOutletPort is the outlet on the PDU reporting its current
	// current is the curren (A): Resolution to 0.1A (data scale factor = 10)
	select
	{
		active (pduOutletPort == dvPduOutlet1):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[1], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet2):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[2], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet3):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[3], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet4):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[4], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet5):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[5], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet6):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[6], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet7):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[7], MODERO_BUTTON_STATE_ALL, ftoa(current))
		active (pduOutletPort == dvPduOutlet8):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_CURRENT_DRAW[8], MODERO_BUTTON_STATE_ALL, ftoa(current))
	}
}


/*
#define INCLUDE_PDU_NOTIFY_OUTLET_POWER_FACTOR_CALLBACK
define_function pduNotifyOutletPowerFactor (dev pduOutletPort, float powerFactor)
{
	// pduOutletPort is the outlet on the PDU reporting its power factor
	// powerFactor is the Power Factor: W/VA, 2 decimal places (data scale factor = 100).
	//     - "Power Factor" is the ratio of real power to apparent power.
}
*/


#define INCLUDE_PDU_NOTIFY_OUTLET_POWER_CALLBACK
define_function pduNotifyOutletEnergy (dev pduOutletPort, float accumulatedEnergy)
{
	// pduOutletPort is the outlet on the PDU reporting its accumulated energy
	// accumulatedEnergy is the accumulated energy reading or power over time (W-hr): Resolution to 0.1W-hr (data scale factor = 10)
	select
	{
		active (pduOutletPort == dvPduOutlet1):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[1], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet2):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[2], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet3):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[3], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet4):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[4], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet5):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[5], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet6):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[6], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet7):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[7], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
		active (pduOutletPort == dvPduOutlet8):   moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_ENERGY_USAGE[8], MODERO_BUTTON_STATE_ALL, ftoa(accumulatedEnergy))
	}
}


#define INCLUDE_PDU_NOTIFY_AXLINK_VOLTAGE_CALLBACK
define_function pduNotifyAxlinkVoltage (dev pduPort2, float voltage)
{
	// pduPort2 is an Axlink bus on the PDU
	// voltage is the voltage (V): Resolution to 0.1V (data scale factor = 10)
	moderoSetButtonText (dvTpTablePower, BTN_ADR_POWER_AXLINK_VOLTAGE, MODERO_BUTTON_STATE_ALL, ftoa(voltage))
}


/*
#define INCLUDE_PDU_NOTIFY_AXLINK_POWER
define_function pduNotifyAxlinkPower (dev pduAxlinkBus, float power)
{
	// pduAxlinkBus is an Axlink bus on the PDU
	// power is the power (W): Resolution to 0.1W (data scale factor = 10)
}
*/

/*
#define INCLUDE_PDU_NOTIFY_AXLINK_CURRENT
define_function pduNotifyAxlinkCurrent (dev pduAxlinkBus, float current)
{
	// pduAxlinkBus is an Axlink bus on the PDU
	// current is the curren (A): Resolution to 0.1A (data scale factor = 10)
}
*/


#define INCLUDE_PDU_NOTIFY_TEMPERATURE_SCALE_CELCIUS
define_function pduNotifyTemperatureScaleCelcius (dev pduPort1)
{
	// pduPort1 is the first device on the PDU
}

#define INCLUDE_PDU_NOTIFY_TEMPERATURE_SCALE_FAHRENHEIT
define_function pduNotifyTemperatureScaleFahrenheit (dev pduPort1)
{
	// pduPort1 is the first device on the PDU
}








/*
 * --------------------
 * Override controlports-listener callback functions
 * --------------------
 */


#define INCLUDE_CONTROLPORTS_NOTIFY_IO_INPUT_ON_CALLBACK
define_function amxControlPortNotifyIoInputOff (dev ioPort, integer ioChanCde)
{
	// ioPort is the IO port.
	// ioChanCde is the IO channel code.
	
	cancel_wait 'WAITING_TO_MAKE_SURE_ROOM_IS_EMPTY'
	
	if (ioPort == dvDvxIos)
	{
		switch (ioChanCde)
		{
			case IO_OCCUPANCY_SENSOR:
			{
				// occupancy has been detected - meaning the room was previously vacant
				isRoomOccupied = TRUE
				
				// Set lights to "all on" mode as people have entered the room
				lightsEnablePresetAllOn ()
				
				// wake up the touch panel
				moderoWake (dvTpTableMain)
				
				// start taking snapshots (just in case the person who triggered the occ sensor wants to go to the source selection page)
				//startMultiPreviewSnapshots ()
			}
		}
	}
}



#define INCLUDE_CONTROLPORTS_NOTIFY_IO_INPUT_OFF_CALLBACK
define_function amxControlPortNotifyIoInputOn (dev ioPort, integer ioChanCde)
{
	// ioPort is the IO port.
	// ioChanCde is the IO channel code.
	
	if (ioPort == dvDvxIos)
	{
		switch (ioChanCde)
		{
			case IO_OCCUPANCY_SENSOR:
			{
				wait 100 'WAITING_TO_MAKE_SURE_ROOM_IS_EMPTY'
				{
				
					// room is now unoccupied (note: Will take 8 minutes minimum to trigger after person leaves room)
					isRoomOccupied = FALSE
					
					// Set lights to "all off" mode as there have been no people in the room for at least 8 minutes
					lightsEnablePresetAllOff ()
					
					// Flip the touch panel to the splash screen
					moderoSetPage (dvTpTableMain, PAGE_NAME_SPLASH_SCREEN)
					
					// Send the panel to sleep
					moderoSleep (dvTpTableMain)
					
					// Stop taking snapshots
					//stopMultiPreviewSnapshots ()
					
					// shutdown the system if it was being used (i.e., someone just walked away without pressing the shutdown button on the panel)
					if (isSystemAvInUse)
					{
						countTimesPeopleLeftWithoutShuttingDownSystem++
						shutdownAvSystem ()
					}
				}
			}
		}
	}
}













#end_if