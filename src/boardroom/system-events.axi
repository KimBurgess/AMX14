program_name='system-events'

#if_not_defined __SYSTEM_EVENTS__
#define __SYSTEM_EVENTS__

#include 'system-devices'
#include 'system-structures'
#include 'system-constants'
#include 'system-variables'
#include 'system-functions'
#include 'system-library-api'
#include 'system-library-control'

/*
 * --------------------
 * Events
 * --------------------
 */

define_event


/*
 * --------------------
 * Data events
 * --------------------
 */

data_event[dvDvxMain]
{
	online:
	{
		dvxRequestVideoInputNameAll (dvDvxMain)
		dvxRequestVideoInputStatusAll (dvDvxMain)
		dvxRequestInputVideo (dvDvxMain, dvDvxVidOutMonitorLeft.port)
		dvxRequestInputVideo (dvDvxMain, dvDvxVidOutMonitorRight.port)
		dvxRequestInputAudio (dvDvxMain, dvDvxAudOutSpeakers.port)
		dvxRequestAudioOutputMute (dvDvxAudOutSpeakers)
		dvxSetAudioOutputMaximumVolume (dvDvxAudOutSpeakers, volumeMax)
		dvxRequestAudioOutputVolume (dvDvxAudOutSpeakers)
	}
}

data_event[dvTpDragAndDrop10]
{
	online:
	{
		// request bitmaps of sources
		moderoRequestButtonBitmapName (dvTpDragAndDrop10, BTN_DRAG_ITEM_SOURCE_HDMI_1, MODERO_BUTTON_STATE_OFF)
		moderoRequestButtonBitmapName (dvTpDragAndDrop10, BTN_DRAG_ITEM_SOURCE_HDMI_2, MODERO_BUTTON_STATE_OFF)
		moderoRequestButtonBitmapName (dvTpDragAndDrop10, BTN_DRAG_ITEM_SOURCE_VGA, MODERO_BUTTON_STATE_OFF)
		moderoRequestButtonBitmapName (dvTpDragAndDrop10, BTN_DRAG_ITEM_SOURCE_DISPLAYPORT, MODERO_BUTTON_STATE_OFF)
	}
}

data_event [vdvDragAndDrop19]
{
	online:
	{
		// Define drop areas
		//send_command vdvDragAndDrop, 'DEFINE_DROP_AREA-<id>,<left>,<top>,<width>,<height>'
		
		// Define drop items
		//send_command vdvDragAndDrop, 'DEFINE_DRAG_ITEM-<id>,<left>,<top>,<width>,<height>'
		sendCommand (vdvDragAndDrop19, "'DEFINE_DRAG_ITEM-',itoa(dvDvxVidIn1.port),',601,400,134,105'")
		sendCommand (vdvDragAndDrop19, "'DEFINE_DRAG_ITEM-',itoa(dvDvxVidIn3.port),',747,400,134,105'")
		sendCommand (vdvDragAndDrop19, "'DEFINE_DRAG_ITEM-',itoa(dvDvxVidIn4.port),',893,400,134,105'")
		sendCommand (vdvDragAndDrop19, "'DEFINE_DRAG_ITEM-',itoa(dvDvxVidIn5.port),',1039,400,134,105'")
		sendCommand (vdvDragAndDrop19, "'DEFINE_DRAG_ITEM-',itoa(dvDvxVidIn8.port),',1185,400,134,105'")
	}
	
	string:
	{
		stack_var char header[50]
		
		header = remove_string (data.text,DELIM_HEADER,1)
		
		switch (header)
		{
			case 'DRAG_ITEM_SELECTED-':
			{
				sendCommand (vdvDragAndDrop19, "'DEFINE_DROP_AREA-',itoa(dvDvxVidOutMonitorLeft.port),',205,164,320,180'")
				sendCommand (vdvDragAndDrop19, "'DEFINE_DROP_AREA-',itoa(dvDvxVidOutMonitorRight.port),',1396,164,320,180'")
				sendCommand (vdvDragAndDrop19, "'DEFINE_DROP_AREA-',itoa(dvDvxVidOutMultiPreview.port),',771,164,379,183'")
				channelOn (dvTpTableDebug, 1)
			}
			
			case 'DRAG_ITEM_DESELECTED-':
			{
				stack_var integer idDragItem
				
				idDragItem = atoi(data.text)
				
				// reset the draggable popup position by hiding it and then showing it again
				moderoDisablePopup (dvTpDragAndDrop19, "'draggable-source-',itoa(idDragItem)")
				moderoEnablePopup (dvTpDragAndDrop19, "'draggable-source-',itoa(idDragItem)")
				
				sendCommand (vdvDragAndDrop19, "'DELETE_DROP_AREA-',itoa(dvDvxVidOutMonitorLeft.port)")
				sendCommand (vdvDragAndDrop19, "'DELETE_DROP_AREA-',itoa(dvDvxVidOutMonitorRight.port)")
				sendCommand (vdvDragAndDrop19, "'DELETE_DROP_AREA-',itoa(dvDvxVidOutMultiPreview.port)")
				
				channelOff (dvTpTableDebug, 1)
			}
			
			case 'DRAG_ITEM_ENTER_DROP_AREA-': {}
			
			case 'DRAG_ITEM_EXIT_DROP_AREA-': {}
			
			case 'DRAG_ITEM_DROPPED_ON_DROP_AREA-':
			{
				stack_var integer idDragItem
				stack_var integer idDropArea
				stack_var integer btnDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				sendCommand (vdvDragAndDrop19, "'DELETE_DROP_AREA-',itoa(dvDvxVidOutMonitorLeft.port)")
				sendCommand (vdvDragAndDrop19, "'DELETE_DROP_AREA-',itoa(dvDvxVidOutMonitorRight.port)")
				sendCommand (vdvDragAndDrop19, "'DELETE_DROP_AREA-',itoa(dvDvxVidOutMultiPreview.port)")
				
				
				moderoDisablePopup (dvTpDragAndDrop19, "'draggable-source-',itoa(idDragItem)")
				moderoEnablePopup (dvTpDragAndDrop19, "'draggable-source-',itoa(idDragItem)")
				
				select
				{
					active (idDropArea == dvDvxVidOutMonitorLeft.port):
					{
						channelOff (dvTpTableDebug, 1)
						dvxSwitchVideoOnly (dvDvxMain, idDragItem, dvDvxVidOutMonitorLeft.port)
						sendCommand (vdvMultiPreview, "'STOP_VIDEO_PREVIEW'")
					}
					
					active (idDropArea == dvDvxVidOutMonitorRight.port):
					{
						channelOff (dvTpTableDebug, 1)
						dvxSwitchVideoOnly (dvDvxMain, idDragItem, dvDvxVidOutMonitorRight.port)
						sendCommand (vdvMultiPreview, "'STOP_VIDEO_PREVIEW'")
					}
					
					active (idDropArea == dvDvxVidOutMultiPreview.port):
					{
						sendCommand (vdvMultiPreview, "'START_VIDEO_PREVIEW-',itoa(idDragItem)")
					}
				}
				
				
				
			}
			
			case 'DRAG_ITEM_NOT_LEFT_DRAG_AREA_WITHIN_TIME-': {}
		}
	}
}


data_event [vdvDragAndDrop10]
{
	online:
	{
		// Define drop areas
		//send_command vdvDragAndDrop, 'DEFINE_DROP_AREA-<id>,<left>,<top>,<width>,<height>'
		sendCommand (vdvDragAndDrop10, "'DEFINE_DROP_AREA-',itoa(dvDvxVidOutMonitorLeft.port),',78,0,307,213'")
		sendCommand (vdvDragAndDrop10, "'DEFINE_DROP_AREA-',itoa(dvDvxVidOutMonitorRight.port),',417,0,307,213'")
		
		// Define drop items
		//send_command vdvDragAndDrop, 'DEFINE_DRAG_ITEM-<id>,<left>,<top>,<width>,<height>'
		sendCommand (vdvDragAndDrop10, "'DEFINE_DRAG_ITEM-',itoa(dvDvxVidInTableHdmi1.port),',102,543,215,137'")
		sendCommand (vdvDragAndDrop10, "'DEFINE_DRAG_ITEM-',itoa(dvDvxVidInTableHdmi2.port),',483,543,215,137'")
		sendCommand (vdvDragAndDrop10, "'DEFINE_DRAG_ITEM-',itoa(dvDvxVidInTableVga.port),',102,822,215,137'")
		sendCommand (vdvDragAndDrop10, "'DEFINE_DRAG_ITEM-',itoa(dvDvxVidInTableDisplayPort.port),',483,822,215,137'")
	}
	
	string:
	{
		stack_var char header[50]
		
		header = remove_string (data.text,DELIM_HEADER,1)
		
		switch (header)
		{
			case 'DRAG_ITEM_SELECTED-': {}
			
			case 'DRAG_ITEM_DESELECTED-':
			{
				stack_var integer idDragItem
				
				idDragItem = atoi(data.text)
				
				// reset the draggable popup position by hiding it and then showing it again
				select
				{
					active (idDragItem == dvDvxVidInTableHdmi1.port):
					{
						moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_HDMI_1)
						moderoEnablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_HDMI_1)
					}
					active (idDragItem == dvDvxVidInTableHdmi2.port):
					{
						moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_HDMI_2)
						moderoEnablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_HDMI_2)
					}
					active (idDragItem == dvDvxVidInTableVga.port):
					{
						moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_VGA)
						moderoEnablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_VGA)
					}
					active (idDragItem == dvDvxVidInTableDisplayPort.port):
					{
						moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_DISPLAYPORT)
						moderoEnablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_DISPLAYPORT)
					}
				}
			}
			
			case 'DRAG_ITEM_ENTER_DROP_AREA-':
			{
				stack_var integer idDragItem
				stack_var integer idDropArea
				stack_var integer btnDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				select
				{
					active (idDropArea == dvDvxVidOutMonitorLeft.port):     btnDropArea = BTN_DROP_AREA_DESTINATION_MONITOR_LEFT
					active (idDropArea == dvDvxVidOutMonitorRight.port):    btnDropArea = BTN_DROP_AREA_DESTINATION_MONITOR_RIGHT
				}
				
				channelOn (dvTpDragAndDrop10, btnDropArea)
			}
			
			case 'DRAG_ITEM_EXIT_DROP_AREA-':
			{
				stack_var integer idDragItem
				stack_var integer idDropArea
				stack_var integer btnDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				select
				{
					active (idDropArea == dvDvxVidOutMonitorLeft.port):     btnDropArea = BTN_DROP_AREA_DESTINATION_MONITOR_LEFT
					active (idDropArea == dvDvxVidOutMonitorRight.port):    btnDropArea = BTN_DROP_AREA_DESTINATION_MONITOR_RIGHT
				}
				
				channelOff (dvTpDragAndDrop10, btnDropArea)
			}
			
			case 'DRAG_ITEM_DROPPED_ON_DROP_AREA-':
			{
				stack_var integer idDragItem
				stack_var integer idDropArea
				stack_var integer btnDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				dvxSwitchVideoOnly (dvDvxMain, idDragItem, idDropArea)
				
				select
				{
					active (idDropArea == dvDvxVidOutMonitorLeft.port):     btnDropArea = BTN_DROP_AREA_DESTINATION_MONITOR_LEFT
					active (idDropArea == dvDvxVidOutMonitorRight.port):    btnDropArea = BTN_DROP_AREA_DESTINATION_MONITOR_RIGHT
				}
				
				channelOff (dvTpDragAndDrop10, btnDropArea)
				
				moderoSetButtonBitmap (dvTpDragAndDrop10, btnDropArea, MODERO_BUTTON_STATE_OFF, draggableItemBitmapNames[idDragItem])
				
				// reset the draggable popup position by hiding it and then showing it again
				select
				{
					active (idDragItem == dvDvxVidInTableHdmi1.port):
					{
						moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_HDMI_1)
						moderoEnablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_HDMI_1)
					}
					active (idDragItem == dvDvxVidInTableHdmi2.port):
					{
						moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_HDMI_2)
						moderoEnablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_HDMI_2)
					}
					active (idDragItem == dvDvxVidInTableVga.port):
					{
						moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_VGA)
						moderoEnablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_VGA)
					}
					active (idDragItem == dvDvxVidInTableDisplayPort.port):
					{
						moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_DISPLAYPORT)
						moderoEnablePopup (dvTpDragAndDrop10, POPUP_NAME_DRAGGABLE_SOURCE_TABLE_DISPLAYPORT)
					}
				}
			}
		}
	}
}

// Configure Resolutions for Multi-Preview Input and associated DVX Output
data_event[dvDvxVidOutMultiPreview]
data_event[dvTpTableMain]
{
	online:
	{
		select
		{
			active (data.device == dvDvxVidOutMultiPreview):
			{
				dvxSetVideoOutputResolution (dvDvxVidOutMultiPreview, DVX_VIDEO_OUTPUT_RESOLUTION_1280x720p_60HZ)
				dvxSetVideoOutputAspectRatio (dvDvxVidOutMultiPreview, DVX_ASPECT_RATIO_STRETCH)
			}
			
			active (data.device == dvTpTableMain):
				moderoSetMultiPreviewInputFormatAndResolution (dvTpTableMain, MODERO_MULTI_PREVIEW_INPUT_FORMAT_HDMI, MODERO_MULTI_PREVIEW_INPUT_RESOLUTION_HDMI_1280x720p30HZ)
		}
	}
}

data_event[dvPduMain1]
{
	online:
	{
		pduRequestVersion (dvPduMain1)
		pduRequestSerialNumber (dvPduMain1)
		pduRequestPersistStateAllOutlets (dvPduMain1)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_1)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_2)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_3)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_4)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_5)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_6)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_7)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_8)
		WAIT 50   // putting a wait here because the PDU seems to set the temp scale back to fahrenheit if it is set to celcius immediately after coming online
		pduSetTempScaleCelcius (dvPduMain1)
	}
}

data_event[dvTpTableMain]
{
	online:
	{
		/*
		 * --------------------
		 * Request info from connected devices.
		 * 
		 * This will solicit a response which will in turn update button feedback.
		 * --------------------
		 */
		
		// DVX
		dvxRequestVideoInputNameAll (dvDvxMain)
		dvxRequestVideoInputStatusAll (dvDvxMain)
		dvxRequestInputVideo (dvDvxMain, dvDvxVidOutMonitorLeft.port)
		dvxRequestInputVideo (dvDvxMain, dvDvxVidOutMonitorRight.port)
		dvxRequestInputAudio (dvDvxMain, dvDvxAudOutSpeakers.port)
		dvxRequestAudioOutputMute (dvDvxAudOutSpeakers)
		dvxRequestAudioOutputVolume (dvDvxAudOutSpeakers)
		dvxRequestAudioOutputMaximumVolume (dvDvxAudOutSpeakers)
		
		// DXLink Rx - Left monitor
		dxlinkRequestRxVideoOutputResolution (dvRxMonitorLeftVidOut)
		dxlinkRequestRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut)
		dxlinkRequestRxVideoOutputScaleMode (dvRxMonitorLeftVidOut)
		
		// DXLink Rx - Right monitor
		dxlinkRequestRxVideoOutputResolution (dvRxMonitorRightVidOut)
		dxlinkRequestRxVideoOutputAspectRatio (dvRxMonitorRightVidOut)
		dxlinkRequestRxVideoOutputScaleMode (dvRxMonitorRightVidOut)
		
		// DXLink Tx's
		dxlinkRequestTxVideoInputAutoSelect (dvTxTable1Main)
		dxlinkRequestTxVideoInputAutoSelect (dvTxTable2Main)
		dxlinkRequestTxVideoInputAutoSelect (dvTxTable3Main)
		dxlinkRequestTxVideoInputAutoSelect (dvTxTable4Main)
		dxlinkRequestTxSelectedVideoInput (dvTxTable1Main)
		dxlinkRequestTxSelectedVideoInput (dvTxTable2Main)
		dxlinkRequestTxSelectedVideoInput (dvTxTable3Main)
		dxlinkRequestTxSelectedVideoInput (dvTxTable4Main)
		dxlinkRequestTxVideoInputSignalStatusAnalog (dvTxTable1VidInAnalog)
		dxlinkRequestTxVideoInputSignalStatusAnalog (dvTxTable2VidInAnalog)
		dxlinkRequestTxVideoInputSignalStatusAnalog (dvTxTable3VidInAnalog)
		dxlinkRequestTxVideoInputSignalStatusAnalog (dvTxTable4VidInAnalog)
		dxlinkRequestTxVideoInputSignalStatusDigital (dvTxTable1VidInDigital)
		dxlinkRequestTxVideoInputSignalStatusDigital (dvTxTable2VidInDigital)
		dxlinkRequestTxVideoInputSignalStatusDigital (dvTxTable3VidInDigital)
		dxlinkRequestTxVideoInputSignalStatusDigital (dvTxTable4VidInDigital)
		
		// PDU
		pduRequestVersion (dvPduMain1)
		pduRequestSerialNumber (dvPduMain1)
		pduRequestPersistStateAllOutlets (dvPduMain1)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_1)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_2)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_3)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_4)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_5)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_6)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_7)
		pduRequestPowerTriggerSenseValue (dvPduMain1, PDU_OUTLET_8)
		
		// Update button text for PDU button labels
		{
			stack_var integer i
			
			for (i = 1; i <= PDU_MAX_OUTLETS; i++)
			{
				moderoSetButtonText (dvTpTablePower, BTNS_ADR_POWER_OUTLET_LABELS[i], MODERO_BUTTON_STATE_ALL, LABELS_PDU_OUTLETS[i])
			}
		}
	}
}

data_event[dvTxTable1Main]
data_event[dvTxTable2Main]
data_event[dvTxTable3Main]
data_event[dvTxTable4Main]
{
	online:
	{
		dxlinkRequestTxVideoInputAutoSelect (data.device)
		dxlinkRequestTxSelectedVideoInput (data.device)
	}
}

data_event[dvTxTable1VidInAnalog]
data_event[dvTxTable2VidInAnalog]
data_event[dvTxTable3VidInAnalog]
data_event[dvTxTable4VidInAnalog]
{                 
	online:
	{
		dxlinkRequestTxVideoInputSignalStatusAnalog (data.device)
		
	}
}

data_event[dvTxTable1VidInDigital]
data_event[dvTxTable2VidInDigital]
data_event[dvTxTable3VidInDigital]
data_event[dvTxTable4VidInDigital]
{                 
	online:
	{
		dxlinkRequestTxVideoInputSignalStatusDigital (data.device)
		
	}
}

data_event[dvRxMonitorLeftVidOut]
data_event[dvRxMonitorRightVidOut]
{
	online:
	{
		dxlinkRequestRxVideoOutputResolution (data.device)
		dxlinkRequestRxVideoOutputAspectRatio (data.device)
		dxlinkRequestRxVideoOutputScaleMode (data.device)
	}
}


/*
 * --------------------
 * Button events
 * --------------------
 */






button_event[dvTpTableAudio,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_AUDIO_VOLUME_DN:    dvxEnableAudioOutputVolumeRampDown (dvDvxAudOutSpeakers)
			case BTN_AUDIO_VOLUME_UP:    dvxEnableAudioOutputVolumeRampUp (dvDvxAudOutSpeakers)
			case BTN_AUDIO_VOLUME_MUTE:  dvxCycleAudioOutputVolumeMute (dvDvxAudOutSpeakers)
			
			case BTN_AUDIO_INPUT_01:     dvxSwitchAudioOnly (dvDvxMain, 1, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_02:     dvxSwitchAudioOnly (dvDvxMain, 2, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_03:     dvxSwitchAudioOnly (dvDvxMain, 3, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_04:     dvxSwitchAudioOnly (dvDvxMain, 4, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_05:     dvxSwitchAudioOnly (dvDvxMain, 5, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_06:     dvxSwitchAudioOnly (dvDvxMain, 6, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_07:     dvxSwitchAudioOnly (dvDvxMain, 7, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_08:     dvxSwitchAudioOnly (dvDvxMain, 8, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_09:     dvxSwitchAudioOnly (dvDvxMain, 9, dvDvxAudOutSpeakers.port)
			case BTN_AUDIO_INPUT_10:     dvxSwitchAudioOnly (dvDvxMain, 10, dvDvxAudOutSpeakers.port)
			
			case BTN_AUDIO_FOLLOW_MONITOR_LEFT:
			{
				audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
				dvxSwitchAudioOnly (dvDvxMain, selectedVideoInputMonitorLeft, dvDvxAudOutSpeakers.port)
			}
			case BTN_AUDIO_FOLLOW_MONITOR_RIGHT:
			{
				audioFollowingVideoOutput = dvDvxVidOutMonitorRight.port
				dvxSwitchAudioOnly (dvDvxMain, selectedVideoInputMonitorRight, dvDvxAudOutSpeakers.port)
			}
		}
	}
	release:
	{
		switch (button.input.channel)
		{
			case BTN_AUDIO_VOLUME_DN:    dvxDisableAudioOutputVolumeRampDown (dvDvxAudOutSpeakers)
			case BTN_AUDIO_VOLUME_UP:    dvxDisableAudioOutputVolumeRampUp (dvDvxAudOutSpeakers)
		}
	}
}

button_event[dvTpTableVideo,BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION]
{
	hold[waitTimeVideoPreview]:
	{
		loadVideoPreviewWindow (dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION)])
	}
	release:
	{
		if (!isVideoBeingPreviewed)
		{
			necMonitorSetPowerOn (vdvMonitorLeft)
			
			dvxSwitchVideoOnly (dvDvxMain, dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION)].port, dvDvxVidOutMonitorLeft.port)
			
			if (dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION)] == dvDvxVidInPc)
			{
				wakeOnLan (MAC_ADDRESS_PC)
			}
			
			if ( (selectedAudioInput == DVX_PORT_AUD_IN_NONE) or
			     ((audioFollowingVideoOutput == dvDvxVidOutMonitorRight.port) and (signalStatusDvxInputMonitorRight != DVX_SIGNAL_STATUS_VALID_SIGNAL))  )
			{
				audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
			}
			
			if (audioFollowingVideoOutput == dvDvxVidOutMonitorLeft.port)
			{
				dvxSwitchAudioOnly (dvDvxMain, dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION)].port, dvDvxAudOutSpeakers.port)
			}
			
			// set flag to indicate that system is in use
			isSystemAvInUse = TRUE
		}
		
		// turn off the video being previewed flag
		//isVideoBeingPreviewed = FALSE	// moved to data_event to capture video preview popup hiding
	}
}

button_event[dvTpTableVideo,BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION]
{
	hold[waitTimeVideoPreview]:
	{
		loadVideoPreviewWindow (dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION)])
	}
	release:
	{
		if (!isVideoBeingPreviewed)
		{
			necMonitorSetPowerOn (vdvMonitorRight)
			
			dvxSwitchVideoOnly (dvDvxMain, dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION)].port, dvDvxVidOutMonitorRight.port)
			
			if (dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION)] == dvDvxVidInPc)
			{
				wakeOnLan (MAC_ADDRESS_PC)
			}
			
			if ( (selectedAudioInput == DVX_PORT_AUD_IN_NONE) or
			     ((audioFollowingVideoOutput == dvDvxVidOutMonitorLeft.port) and (signalStatusDvxInputMonitorLeft != DVX_SIGNAL_STATUS_VALID_SIGNAL))    )
			{
				audioFollowingVideoOutput = dvDvxVidOutMonitorRight.port
			}
			
			if (audioFollowingVideoOutput == dvDvxVidOutMonitorRight.port)
			{
				dvxSwitchAudioOnly (dvDvxMain, dvDvxVidInPorts[get_last(BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION)].port, dvDvxAudOutSpeakers.port)
			}
			
			// set flag to indicate that system is in use
			isSystemAvInUse = TRUE
		}
		
		// turn off the video being previewed flag
		//isVideoBeingPreviewed = FALSE   // moved to data_event to capture video preview popup hiding
	}
}

button_event[dvTpTableVideo,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_VIDEO_MONITOR_LEFT_OFF:     necMonitorSetPowerOff (vdvMonitorLeft)
			case BTN_VIDEO_MONITOR_LEFT_ON:      necMonitorSetPowerOn (vdvMonitorLeft)
			case BTN_VIDEO_MONITOR_RIGHT_OFF:    necMonitorSetPowerOff (vdvMonitorRight)
			case BTN_VIDEO_MONITOR_RIGHT_ON:     necMonitorSetPowerOn (vdvMonitorRight)
			
			case BTN_VIDEO_QUERY_LYNC_CALL_NO:   {}  // ignore
			case BTN_VIDEO_QUERY_LYNC_CALL_YES:
			{
				lightsEnablePresetVc ()
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_DN)
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_DN)
				dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
			}
			
			case BTN_VIDEO_LYNC_MONITOR_LEFT:
			{
				min_to [button.input]   // feedback for the button
				recallCameraPreset (CAMERA_PRESET_1)
				wakeOnLan (MAC_ADDRESS_PC)
				dvxSwitchVideoOnly (dvDvxMain, dvDvxVidInPc.port, dvDvxVidOutMonitorLeft.port)
				dvxSwitchAudioOnly (dvDvxMain, dvDvxVidInPc.port, dvDvxAudOutSpeakers.port)
				audioFollowingVideoOutput = dvDvxVidOutMonitorLeft.port
				lightsEnablePresetVc ()
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_DN)
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_DN)
				dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
				necMonitorSetPowerOn (vdvMonitorLeft)
				// set flag to indicate that system is in use
				isSystemAvInUse = TRUE
			}
			
			case BTN_VIDEO_LYNC_MONITOR_RIGHT:
			{
				min_to [button.input]   // feedback for the button
				recallCameraPreset (CAMERA_PRESET_2)
				wakeOnLan (MAC_ADDRESS_PC)
				dvxSwitchVideoOnly (dvDvxMain, dvDvxVidInPc.port, dvDvxVidOutMonitorRight.port)
				dvxSwitchAudioOnly (dvDvxMain, dvDvxVidInPc.port, dvDvxAudOutSpeakers.port)
				audioFollowingVideoOutput = dvDvxVidOutMonitorRight.port
				lightsEnablePresetVc ()
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_DN)
				amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_DN)
				dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, volumeDefault)
				necMonitorSetPowerOn (vdvMonitorRight)
				// set flag to indicate that system is in use
				isSystemAvInUse = TRUE
			}
		}
	}
}

button_event[dvTpTableLighting,0]
{
	push:
	{
		min_to [button.input]
		
		switch (button.input.channel)
		{
			case BTN_LIGHTING_PRESET_ALL_OFF:    lightsOff (LIGHTING_ADDRESS_BOARDROOM)
		}
	}
}

button_event[dvTpTableBlinds,0]
{
	push:
	{
		min_to [button.input]
		
		switch (button.input.channel)
		{
			case BTN_BLIND_1_UP:     amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_UP)
			case BTN_BLIND_1_DOWN:   amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_CORNER_WINDOW_DN)
			case BTN_BLIND_1_STOP:   amxRelayPulse (dvRelaysDvx, REL_DVX_BLOCKOUTS_CORNER_WINDOW_STOP)
			
			case BTN_BLIND_2_UP:     amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_UP)
			case BTN_BLIND_2_DOWN:   amxRelayPulse (dvRelaysRelBox, REL_BLOCKOUTS_WALL_WINDOW_DN)
			case BTN_BLIND_2_STOP:   amxRelayPulse (dvRelaysDvx, REL_DVX_BLOCKOUTS_WALL_WINDOW_STOP)
			
			case BTN_SHADE_1_UP:     amxRelayPulse (dvRelaysRelBox, REL_SHADES_CORNER_WINDOW_UP)
			case BTN_SHADE_1_DOWN:   amxRelayPulse (dvRelaysRelBox, REL_SHADES_CORNER_WINDOW_DN)
			case BTN_SHADE_1_STOP:   amxRelayPulse (dvRelaysDvx, REL_DVX_SHADES_CORNER_WINDOW_STOP)
			
			case BTN_SHADE_2_UP:     amxRelayPulse (dvRelaysRelBox, REL_SHADES_WALL_WINDOW_UP)
			case BTN_SHADE_2_DOWN:   amxRelayPulse (dvRelaysRelBox, REL_SHADES_WALL_WINDOW_DN)
			case BTN_SHADE_2_STOP:   amxRelayPulse (dvRelaysDvx, REL_DVX_SHADES_WALL_WINDOW_STOP)
		}                      
	}
}

button_event[dvTpTablePower,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_POWER_TOGGLE_MONITOR_LEFT:  pduToggleRelayPower (dvPduOutletMonitorLeft)
			case BTN_POWER_TOGGLE_MONITOR_RIGHT: pduToggleRelayPower (dvPduOutletMonitorRight)
			case BTN_POWER_TOGGLE_PDXL2:         pduToggleRelayPower (dvPduOutletPdxl2)
			
			case BTN_POWER_TOGGLE_MULTI_PREVIEW:
			{
				// Cycle power on the PDU
				pduDisableRelayPower (dvPduOutletMultiPreview)
				wait waitTimePowerCycle
				{
					pduEnableRelayPower (dvPduOutletMultiPreview)
				}
			}
			
			case BTN_POWER_TOGGLE_PC:        pduToggleRelayPower (dvPduOutletPc)
			//case BTN_POWER_TOGGLE_DVX:     pduToggleRelayPower (dvPduOutletDvx)    // don't allow user to turn power off to DVX
			case BTN_POWER_TOGGLE_FAN_1:     pduToggleRelayPower (dvPduOutletFan1)
			case BTN_POWER_TOGGLE_FAN_2:     pduToggleRelayPower (dvPduOutletFan2)
			
			case BTN_POWER_TEMPERATURE_SCALE_TOGGLE:     channelToggle (dvPduMain1,PDU_CHANNEL_TEMP_SCALE)
			case BTN_POWER_TEMPERATURE_SCALE_CELCIUS:    pduSetTempScaleCelcius (dvPduMain1)
			case BTN_POWER_TEMPERATURE_SCALE_FAHRENHEIT: pduSetTempScaleFahrenheit (dvPduMain1)
		}
	}
}

button_event[dvTpTableCamera,0]
{
	push:
	{
		min_to [button.input]
		
		switch (button.input.channel)
		{
			case BTN_CAMERA_FOCUS_NEAR:  agentUsbPtzWebCamFocusNearStandardSpeed (dvPtzCam)
			case BTN_CAMERA_FOCUS_FAR:   agentUsbPtzWebCamFocusFarStandardSpeed (dvPtzCam)
			case BTN_CAMERA_ZOOM_IN:     agentUsbPtzWebCamZoomInStandardSpeed (dvPtzCam)
			case BTN_CAMERA_ZOOM_OUT:    agentUsbPtzWebCamZoomOutStandardSpeed (dvPtzCam)
			case BTN_CAMERA_PAN_LEFT:    agentUsbPtzWebCamPanLeft (dvPtzCam, panSpeed)
			case BTN_CAMERA_PAN_RIGHT:   agentUsbPtzWebCamPanRight (dvPtzCam, panSpeed)
			case BTN_CAMERA_TILT_DOWN:   agentUsbPtzWebCamTiltDown (dvPtzCam, tiltSpeed)
			case BTN_CAMERA_TILT_UP:     agentUsbPtzWebCamTiltUp (dvPtzCam, tiltSpeed)
			
			case BTN_CAMERA_PRESET_1:
			{
				recallCameraPreset (CAMERA_PRESET_1)
			}
			case BTN_CAMERA_PRESET_2:
			{
				recallCameraPreset (CAMERA_PRESET_2)
			}
			case BTN_CAMERA_PRESET_3:
			{
				recallCameraPreset (CAMERA_PRESET_3)
			}
		}
	}
	release:
	{
		switch (button.input.channel)
		{
			case BTN_CAMERA_FOCUS_NEAR:  agentUsbPtzWebCamFocusOff (dvPtzCam)
			case BTN_CAMERA_FOCUS_FAR:   agentUsbPtzWebCamFocusOff (dvPtzCam)
			case BTN_CAMERA_ZOOM_IN:     agentUsbPtzWebCamZoomOff (dvPtzCam)
			case BTN_CAMERA_ZOOM_OUT:    agentUsbPtzWebCamZoomOff (dvPtzCam)
			case BTN_CAMERA_PAN_LEFT:    agentUsbPtzWebCamPanOff (dvPtzCam)
			case BTN_CAMERA_PAN_RIGHT:   agentUsbPtzWebCamPanOff (dvPtzCam)
			case BTN_CAMERA_TILT_DOWN:   agentUsbPtzWebCamTiltOff (dvPtzCam)
			case BTN_CAMERA_TILT_UP:     agentUsbPtzWebCamTiltOff (dvPtzCam)
		}
	}
}

button_event[dvTpTableDxlink,0]
{
	push:
	{
		// button feedback
		on[button.input]
		
		switch (button.input.channel)
		{
			// TX - Auto
			case BTN_DXLINK_TX_AUTO_1:   dxlinkEnableTxVideoInputAutoSelectPriotityDigital (dvTxTable1Main)
			case BTN_DXLINK_TX_AUTO_2:   dxlinkEnableTxVideoInputAutoSelectPriotityDigital (dvTxTable2Main)
			case BTN_DXLINK_TX_AUTO_3:   dxlinkEnableTxVideoInputAutoSelectPriotityDigital (dvTxTable3Main)
			case BTN_DXLINK_TX_AUTO_4:   dxlinkEnableTxVideoInputAutoSelectPriotityDigital (dvTxTable4Main)
			
			// TX - HDMI
			case BTN_DXLINK_TX_HDMI_1:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable1Main)
				dxlinkSetTxVideoInputFormatDigital (dvTxTable1VidInDigital, VIDEO_SIGNAL_FORMAT_HDMI)
				dxlinkSetTxVideoInputDigital (dvTxTable1Main)
			}
			case BTN_DXLINK_TX_HDMI_2:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable2Main)
				dxlinkSetTxVideoInputFormatDigital (dvTxTable2VidInDigital, VIDEO_SIGNAL_FORMAT_HDMI)
				dxlinkSetTxVideoInputDigital (dvTxTable2Main)
			}
			case BTN_DXLINK_TX_HDMI_3:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable3Main)
				dxlinkSetTxVideoInputFormatDigital (dvTxTable3VidInDigital, VIDEO_SIGNAL_FORMAT_HDMI)
				dxlinkSetTxVideoInputDigital (dvTxTable3Main)
			}
			case BTN_DXLINK_TX_HDMI_4:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable4Main)
				dxlinkSetTxVideoInputFormatDigital (dvTxTable4VidInDigital, VIDEO_SIGNAL_FORMAT_HDMI)
				dxlinkSetTxVideoInputDigital (dvTxTable4Main)
			}
			
			// TX - VGA
			case BTN_DXLINK_TX_VGA_1:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable1Main)
				dxlinkSetTxVideoInputFormatAnalog (dvTxTable1VidInAnalog, VIDEO_SIGNAL_FORMAT_VGA)
				dxlinkSetTxVideoInputAnalog (dvTxTable1Main)
			}
			case BTN_DXLINK_TX_VGA_2:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable2Main)
				dxlinkSetTxVideoInputFormatAnalog (dvTxTable2VidInAnalog, VIDEO_SIGNAL_FORMAT_VGA)
				dxlinkSetTxVideoInputAnalog (dvTxTable2Main)
			}
			case BTN_DXLINK_TX_VGA_3:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable3Main)
				dxlinkSetTxVideoInputFormatAnalog (dvTxTable3VidInAnalog, VIDEO_SIGNAL_FORMAT_VGA)
				dxlinkSetTxVideoInputAnalog (dvTxTable3Main)
			}
			case BTN_DXLINK_TX_VGA_4:
			{
				dxlinkDisableTxVideoInputAutoSelect (dvTxTable4Main)
				dxlinkSetTxVideoInputFormatAnalog (dvTxTable4VidInAnalog, VIDEO_SIGNAL_FORMAT_VGA)
				dxlinkSetTxVideoInputAnalog (dvTxTable4Main)
			}
			
			// RX - Scaler Auto
			case BTN_DXLINK_RX_SCALER_AUTO_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorLeftVidOut, DXLINK_SCALE_MODE_AUTO)
			}
			case BTN_DXLINK_RX_SCALER_AUTO_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorRightVidOut, DXLINK_SCALE_MODE_AUTO)
			}
			
			// RX - Scaler Bypass
			case BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorLeftVidOut, DXLINK_SCALE_MODE_BYPASS)
			}
			case BTN_DXLINK_RX_SCALER_BYPASS_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorRightVidOut, DXLINK_SCALE_MODE_BYPASS)
			}
			
			// RX - Scaler Manual
			case BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorLeftVidOut, DXLINK_SCALE_MODE_MANUAL)
			}
			case BTN_DXLINK_RX_SCALER_MANUAL_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputScaleMode (dvRxMonitorRightVidOut, DXLINK_SCALE_MODE_MANUAL)
			}
			
			// RX - Aspect Maintain
			case BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut, DXLINK_ASPECT_RATIO_MAINTAIN)
			}
			case BTN_DXLINK_RX_ASPECT_MAINTAIN_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorRightVidOut, DXLINK_ASPECT_RATIO_MAINTAIN)
			}
			
			// RX - Aspect Stretch
			case BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut, DXLINK_ASPECT_RATIO_STRETCH)
			}
			case BTN_DXLINK_RX_ASPECT_STRETCH_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorRightVidOut, DXLINK_ASPECT_RATIO_STRETCH)
			}
			
			// RX - Aspect Zoom
			case BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut, DXLINK_ASPECT_RATIO_ZOOM)
			}
			case BTN_DXLINK_RX_ASPECT_ZOOM_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorRightVidOut, DXLINK_ASPECT_RATIO_ZOOM)
			}
			
			// RX - Aspect Anamorphic
			case BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_LEFT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorLeftVidOut, DXLINK_ASPECT_RATIO_ANAMORPHIC)
			}
			case BTN_DXLINK_RX_ASPECT_ANAMORPHIC_MONITOR_RIGHT:
			{
				dxlinkSetRxVideoOutputAspectRatio (dvRxMonitorRightVidOut, DXLINK_ASPECT_RATIO_ANAMORPHIC)
			}
		}                                                                        
	}
}

button_event[dvTpTableDebug,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_DEBUG_REBUILD_EVENT_TABLE:
			{
				rebuild_event ()
				debugPrint ('**** Event Table Rebuilt ****')
			}
			case BTN_DEBUG_WAKE_ON_LAN_PC:
			{
				wakeOnLan (MAC_ADDRESS_PC)
			}
		}
	}
}

button_event[dvTpTableMain, 0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_MAIN_SHUT_DOWN:
			{
				shutdownAvSystem ()
			}
			
			case BTN_MAIN_SPLASH_SCREEN:
			{
				//startMultiPreviewSnapshots ()
				
				// page flips done on the panel
			}
		}
	}
}



/*
 * --------------------
 * Level events
 * --------------------
 */

level_event[dvTpTableAudio, BTN_LVL_VOLUME_CONTROL]
{
	dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, level.value)
}



/*
 * --------------------
 * Timeline events
 * --------------------
 */

timeline_event[TIMELINE_ID_MULTI_PREVIEW_SNAPSHOTS]
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
				moderoResourceForceRefreshPrefetchFromCache (dvTpTableVideo, dynamicImageName, MODERO_RESOURCE_NOTIFICATION_OFF)
				moderoSetButtonBitmapResource (dvTpTableVideo, BTN_ADRS_VIDEO_MONITOR_LEFT_INPUT_SELECTION[slotId],MODERO_BUTTON_STATE_ALL,"'MXA_PREVIEW_',itoa(slotId)")
				moderoSetButtonBitmapResource (dvTpTableVideo, BTN_ADRS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION[slotId],MODERO_BUTTON_STATE_ALL,"'MXA_PREVIEW_',itoa(slotId)")
			}
		}
	}
}



/*
 * --------------------
 * Custom events
 * --------------------
 */


#warn 'BUG: amx-au-gc-boardroom-main - custom event for streaming status not triggering'

custom_event[dvTpTableMain,0,MODERO_CUSTOM_EVENT_ID_STREAMING_VIDEO]
custom_event[dvTpTableVideo,0,MODERO_CUSTOM_EVENT_ID_STREAMING_VIDEO]
custom_event[dvTpTableMain,1,MODERO_CUSTOM_EVENT_ID_STREAMING_VIDEO]
custom_event[dvTpTableVideo,1,MODERO_CUSTOM_EVENT_ID_STREAMING_VIDEO]
{
	debugPrint ("'custom_event[dvTpTableMain,1,MODERO_CUSTOM_EVENT_ID_STREAMING_VIDEO]'")
	debugPrint ("'custom.device = [',debugDevToString(custom.device),']'")
	debugPrint ("'custom.id = <>',itoa(custom.id)")
	debugPrint ("'custom.type = <>',itoa(custom.type)")
	debugPrint ("'custom.flag = <>',itoa(custom.flag)")
	debugPrint ("'custom.value1 = <>',itoa(custom.value1)")
	debugPrint ("'custom.value2 = <>',itoa(custom.value2)")
	debugPrint ("'custom.value3 = <>',itoa(custom.value3)")
	debugPrint ("'custom.text = "',custom.text,'"'")
	
	switch (custom.flag)
	{
		case 1:	// start
		{
			
		}
		case 2:	// stop
		{
			//startMultiPreviewSnapshots ()
		}
	}
}


data_event[dvTpTableMain]
{
	string:
	{
		// start taking snapshots of each input as soon as the video preview popup closes
		if (find_string(data.text, '@PPF-popup-video-preview',1) == 1)
		{
			// turn off the video being previewed flag
			isVideoBeingPreviewed = FALSE
			//startMultiPreviewSnapshots ()
		}
	}
}


level_event[dvTpTableLighting,BTN_LVL_LIGHTING_CONTROL]
{
	// set lights
	lightsSetLevelWithFade (LIGHTING_ADDRESS_BOARDROOM, level.value, 0)
	// update display bargraph
	sendLevel (dvTpTableLighting, BTN_LVL_LIGHTING_DISPLAY , level.value)
}

#end_if