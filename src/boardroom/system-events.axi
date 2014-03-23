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


data_event [dvPtzCam]
{
	online:
	{
		amxIrSetMode (data.device, IR_MODE_IR)
	}
}

data_event [dvDvxMain]
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

data_event [dvTpDragAndDrop10]
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

button_event [dvTpTableDebug,1]
{
	push:
	{
		channelOff (dvTpTableDebug, 1)
		moderoDisableButtonPushes (dvTpTableDebug, 2)
		sendCommand (vdvMultiPreview, "'STOP_VIDEO_PREVIEW'")
	}
}

data_event [vdvDragAndDrop19]
{
	online:
	{
		// Define drag/drop items - they will automatically be enabled by the module
		addDragItemsAll (vdvDragAndDrop19)
		addDropAreasAll (vdvDragAndDrop19)
		
		if (getSystemMode() != SYSTEM_MODE_PRESENTATION)
			disableDropAreasAll (vdvDragAndDrop19)
	}
	
	string:
	{
		stack_var char header[50]
		
		header = remove_string (data.text,DELIM_HEADER,1)
		
		switch (header)
		{
			case 'DRAG_ITEM_SELECTED-':
			{
				enableDropItemsAll (vdvDragAndDrop19)
				
				channelOn (dvTpTableDebug, 1)
				
				moderoEnableButtonPushes (dvTpTableDebug, 2)
			}
			
			case 'DRAG_ITEM_DESELECTED-':
			{
				stack_var integer idDragItem
				
				idDragItem = atoi(data.text)
				
				// reset the draggable popup position by hiding it and then showing it again
				resetDraggablePopup (vdvDragAndDrop19, idDragItem)
				
				disableDropAreasAll (vdvDragAndDrop19)
				
				//channelOff (dvTpTableDebug, 1)	// maybe don't do this here
			}
			
			case 'DRAG_ITEM_ENTER_DROP_AREA-':
			{
				stack_var integer idDragItem
				stack_var integer idDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				select
				{
					active (idDropArea == dvDvxVidOutMonitorLeft.port):
					{
						channelOn (dvTpTableVideo, BTN_DROP_AREA_19_PANEL_HIGHLIGHT_MONITOR_LEFT)
					}
					
					active (idDropArea == dvDvxVidOutMonitorRight.port):
					{
						channelOn (dvTpTableVideo, BTN_DROP_AREA_19_PANEL_HIGHLIGHT_MONITOR_RIGHT)
					}
				}
			}
			
			case 'DRAG_ITEM_EXIT_DROP_AREA-':
			{
				stack_var integer idDragItem
				stack_var integer idDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				select
				{
					active (idDropArea == dvDvxVidOutMonitorLeft.port):
					{
						channelOff (dvTpTableVideo, BTN_DROP_AREA_19_PANEL_HIGHLIGHT_MONITOR_LEFT)
					}
					
					active (idDropArea == dvDvxVidOutMonitorRight.port):
					{
						channelOff (dvTpTableVideo, BTN_DROP_AREA_19_PANEL_HIGHLIGHT_MONITOR_RIGHT)
					}
				}
			}
			
			case 'DRAG_ITEM_DROPPED_ON_DROP_AREA-':
			{
				stack_var integer idDragItem
				stack_var integer idDropArea
				stack_var integer btnDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				disableDropAreasAll (vdvDragAndDrop19)
				
				resetDraggablePopup (vdvDragAndDrop19, idDragItem)
				
				select
				{
					active (idDropArea == dvDvxVidOutMonitorLeft.port):
					{
						channelOff (dvTpTableDebug, 1)
						
						showSourceOnDisplay (idDragItem, idDropArea)
						
						sendCommand (vdvMultiPreview, "'STOP_VIDEO_PREVIEW'")
						
						channelOff (dvTpTableVideo, BTN_DROP_AREA_19_PANEL_HIGHLIGHT_MONITOR_LEFT)
						
						/*moderoButtonCopyAttribute (dvTpTableVideo, 
						                           PORT_TP_VIDEO, 
						                           btnAdrsVideoSnapshotPreviews[idDragItem], 
						                           MODERO_BUTTON_STATE_OFF,
						                           BTN_ADR_VIDEO_MONITOR_LEFT_PREVIEW_SNAPSHOT, 
						                           MODERO_BUTTON_STATE_ALL,
						                           MODERO_BUTTON_ATTRIBUTE_BITMAP)*/
					}
					
					active (idDropArea == dvDvxVidOutMonitorRight.port):
					{
						channelOff (dvTpTableDebug, 1)
						
						showSourceOnDisplay (idDragItem, idDropArea)
						
						sendCommand (vdvMultiPreview, "'STOP_VIDEO_PREVIEW'")
						
						channelOff (dvTpTableVideo, BTN_DROP_AREA_19_PANEL_HIGHLIGHT_MONITOR_RIGHT)
						
						/*moderoButtonCopyAttribute (dvTpTableVideo, 
						                           PORT_TP_VIDEO, 
						                           btnAdrsVideoSnapshotPreviews[idDragItem], 
						                           MODERO_BUTTON_STATE_OFF,
						                           BTN_ADR_VIDEO_MONITOR_RIGHT_PREVIEW_SNAPSHOT, 
						                           MODERO_BUTTON_STATE_ALL,
						                           MODERO_BUTTON_ATTRIBUTE_BITMAP)*/
					}
					
					active (idDropArea == dvDvxVidOutMultiPreview.port):
					{
						showSourceOnDisplay (idDragItem, idDropArea)
						
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
		// Define drag items - they will automatically be enabled by the module
		addDragItemsAll (vdvDragAndDrop10)
	}
	
	string:
	{
		stack_var char header[50]
		local_var integer isClockwiseOrientation
		
		header = remove_string (data.text,DELIM_HEADER,1)
		
		switch (header)
		{
			case 'DRAG_ITEM_SELECTED-':
			{
				stack_var integer idDragItem
				stack_var integer idDragItemsToBlock[3]
				stack_var integer i
				
				idDragItem = atoi(data.text)
				
				// remove the other drag items (don't want to allow multiple item selection in this instance)
				select
				{
					active (idDragItem == dvDvxVidInTableHdmi1.port):
					{
						idDragItemsToBlock[1] = dvDvxVidInTableDisplayPort.port
						idDragItemsToBlock[2] = dvDvxVidInTableHdmi2.port
						idDragItemsToBlock[3] = dvDvxVidInTableVga.port
						
						moderoSetButtonBitmap (dvTpDragAndDrop10, BTN_DRAG_AND_DROP_INSTRUCTIONS_10, MODERO_BUTTON_STATE_ON, IMAGE_FILE_NAME_DRAG_AND_DROP_INSTRUCTIONS_HDMI_1)
					}
					
					active (idDragItem == dvDvxVidInTableHdmi2.port):
					{
						idDragItemsToBlock[1] = dvDvxVidInTableDisplayPort.port
						idDragItemsToBlock[2] = dvDvxVidInTableHdmi1.port
						idDragItemsToBlock[3] = dvDvxVidInTableVga.port
						
						moderoSetButtonBitmap (dvTpDragAndDrop10, BTN_DRAG_AND_DROP_INSTRUCTIONS_10, MODERO_BUTTON_STATE_ON, IMAGE_FILE_NAME_DRAG_AND_DROP_INSTRUCTIONS_HDMI_2)
					}
					
					active (idDragItem == dvDvxVidInTableVga.port):
					{
						idDragItemsToBlock[1] = dvDvxVidInTableDisplayPort.port
						idDragItemsToBlock[2] = dvDvxVidInTableHdmi1.port
						idDragItemsToBlock[3] = dvDvxVidInTableHdmi2.port
						
						moderoSetButtonBitmap (dvTpDragAndDrop10, BTN_DRAG_AND_DROP_INSTRUCTIONS_10, MODERO_BUTTON_STATE_ON, IMAGE_FILE_NAME_DRAG_AND_DROP_INSTRUCTIONS_VGA)
					}
					
					active (idDragItem == dvDvxVidInTableDisplayPort.port):
					{
						idDragItemsToBlock[1] = dvDvxVidInTableHdmi1.port
						idDragItemsToBlock[2] = dvDvxVidInTableHdmi2.port
						idDragItemsToBlock[3] = dvDvxVidInTableVga.port
						
						moderoSetButtonBitmap (dvTpDragAndDrop10, BTN_DRAG_AND_DROP_INSTRUCTIONS_10, MODERO_BUTTON_STATE_ON, IMAGE_FILE_NAME_DRAG_AND_DROP_INSTRUCTIONS_DISPLAYPORT)
					}
				}
				
				// make it impossible to select the other drag areas
				for (i = 1; i <= MAX_LENGTH_ARRAY(idDragItemsToBlock); i++)
				{
					disableDragItem (vdvDragAndDrop10, idDragItemsToBlock[i])
					blockDragItem (vdvDragAndDrop10, idDragItemsToBlock[i])
				}
				
				// Define drop areas based on which side was selected
				select
				{
					active (idDragItem == dvDvxVidInTableHdmi1.port OR idDragItem == dvDvxVidInTableVga.port):
					{
						isClockwiseOrientation = true
						
						// NOTE: Don't call addPanelDropArea from here!
						// 10" is a special case where the  an assignment of the drop areas to the displays is dynamic
						// based on which sources (drag items) are selected by the user so as to orient buttons and graphics to
						// the side of the panel that the user is located.
						sendCommand (vdvDragAndDrop10, "'DEFINE_DROP_AREA-',buildDragAndDropParameterString(dvDvxVidOutMonitorLeft.port, dropAreaLeftOrientationMonitorLeft)")
						sendCommand (vdvDragAndDrop10, "'DEFINE_DROP_AREA-',buildDragAndDropParameterString(dvDvxVidOutMonitorRight.port, dropAreaLeftOrientationMonitorRight)")
						
						/*moderoSetButtonText (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A, MODERO_BUTTON_STATE_ALL, 'Left')
						moderoSetButtonText (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B, MODERO_BUTTON_STATE_ALL, 'Right')*/
						
						moderoSetButtonBitmap (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A_DROP_ICON, MODERO_BUTTON_STATE_ALL, IMAGE_FILE_NAME_DROP_ICON_ROTATE_90_DEGREES_CLOCKWISE)
						moderoSetButtonBitmap (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B_DROP_ICON, MODERO_BUTTON_STATE_ALL, IMAGE_FILE_NAME_DROP_ICON_ROTATE_90_DEGREES_CLOCKWISE)
					}
					
					active (idDragItem == dvDvxVidInTableHdmi2.port OR idDragItem == dvDvxVidInTableDisplayPort.port):
					{
						isClockwiseOrientation = false
						
						// NOTE: Don't call addPanelDropArea from here!
						// 10" is a special case where the  an assignment of the drop areas to the displays is dynamic
						// based on which sources (drag items) are selected by the user so as to orient buttons and graphics to
						// the side of the panel that the user is located.
						sendCommand (vdvDragAndDrop10, "'DEFINE_DROP_AREA-',buildDragAndDropParameterString(dvDvxVidOutMonitorLeft.port, dropAreaRightOrientationMonitorLeft)")
						sendCommand (vdvDragAndDrop10, "'DEFINE_DROP_AREA-',buildDragAndDropParameterString(dvDvxVidOutMonitorRight.port, dropAreaRightOrientationMonitorRight)")
						
						/*moderoSetButtonText (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A, MODERO_BUTTON_STATE_ALL, 'Right')
						moderoSetButtonText (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B, MODERO_BUTTON_STATE_ALL, 'Left')*/
						
						moderoSetButtonBitmap (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A_DROP_ICON, MODERO_BUTTON_STATE_ALL, IMAGE_FILE_NAME_DROP_ICON_ROTATE_90_DEGREES_COUNTER_CLOCKWISE)
						moderoSetButtonBitmap (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B_DROP_ICON, MODERO_BUTTON_STATE_ALL, IMAGE_FILE_NAME_DROP_ICON_ROTATE_90_DEGREES_COUNTER_CLOCKWISE)
					}
				}
				
				// hide audio/lighting control popups
				moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_CONTROLS_AUDIO)
				moderoDisablePopup (dvTpDragAndDrop10, POPUP_NAME_CONTROLS_LIGHTING)
				
				// show buttons for the monitors
				cancel_wait 'FIRST_TIME_USER'
				moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A, 0, 30, 2)
				moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B, 0, 30, 2)
				moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A_DROP_ICON, 0, 30, 2)
				moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B_DROP_ICON, 0, 30, 2)
				
				channelOn (dvTpDragAndDrop10, BTN_DRAG_AND_DROP_INSTRUCTIONS_10)
				//moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DRAG_AND_DROP_INSTRUCTIONS_10, 0, 30, 2)
			}
			
			case 'DRAG_ITEM_DESELECTED-':
			{
				stack_var integer idDragItem
				
				idDragItem = atoi(data.text)
				
				// Define drag items again
				enableDragItemsAll (vdvDragAndDrop10)
				
				// delete the drop areas for the monitors
				disableDropAreasAll (vdvDragAndDrop10)
				
				// reset the draggable popup position by hiding it and then showing it again
				resetDraggablePopup (vdvDragAndDrop10, idDragItem)
				
				// unblock all of the drag items
				unblockDragItemsAll (vdvDragAndDrop10)
				
				// hide the buttons for the monitors after a short time
				// allows user unfamiliar with the drag and drop interface to read innstructions
				wait 20 'FIRST_TIME_USER'
				{
					moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A, 30, 1, 3)
					moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B, 30, 1, 3)
					moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A_DROP_ICON, 0, 1, 3)
					moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B_DROP_ICON, 0, 1, 3)
					
					// show audio/lighting control popups
					moderoEnablePopupOnPage (dvTpDragAndDrop10, POPUP_NAME_CONTROLS_AUDIO, PAGE_NAME_MAIN)
					moderoEnablePopupOnPage (dvTpDragAndDrop10, POPUP_NAME_CONTROLS_LIGHTING, PAGE_NAME_MAIN)
					
					channelOff (dvTpDragAndDrop10, BTN_DRAG_AND_DROP_INSTRUCTIONS_10)
					//moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DRAG_AND_DROP_INSTRUCTIONS_10, 0, 1, 3)
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
					active (idDropArea == dvDvxVidOutMonitorLeft.port):
					{
						if (isClockwiseOrientation)
							btnDropArea = BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A
						else
							btnDropArea = BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B
					}
					active (idDropArea == dvDvxVidOutMonitorRight.port):
					{
						if (isClockwiseOrientation)
							btnDropArea = BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B
						else
							btnDropArea = BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A
					}
				}
				
				moderoEnableButtonAnimate (dvTpDragAndDrop10, btnDropArea, 30, 60, 1)
				
				//channelOn (dvTpDragAndDrop10, btnDropArea)
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
					active (idDropArea == dvDvxVidOutMonitorLeft.port):
					{
						if (isClockwiseOrientation)
							btnDropArea = BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A
						else
							btnDropArea = BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B
					}
					active (idDropArea == dvDvxVidOutMonitorRight.port):
					{
						if (isClockwiseOrientation)
							btnDropArea = BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B
						else
							btnDropArea = BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A
					}
				}
				
				moderoEnableButtonAnimate (dvTpDragAndDrop10, btnDropArea, 60, 30, 2)
				
				//channelOff (dvTpDragAndDrop10, btnDropArea)
			}
			
			case 'DRAG_ITEM_DROPPED_ON_DROP_AREA-':
			{
				stack_var integer idDragItem
				stack_var integer idDropArea
				stack_var integer btnDropArea
				
				idDragItem = atoi(remove_string(data.text,DELIM_PARAM,1))
				idDropArea = atoi(data.text)
				
				// Define drag items again
				enableDragItemsAll (vdvDragAndDrop10)
				
				// unblock all of the drag items
				unblockDragItemsAll (vdvDragAndDrop10)
				
				// delete the drop areas for the monitors
				disableDropAreasAll (vdvDragAndDrop10)
				
				// hide the buttons for the monitors
				#warn '@TODO'
				
				// switch the selected input to the selected output
				showSourceOnDisplay (idDragItem, idDropArea)
				
				moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A, 0, 1, 0)
				moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B, 0, 1, 0)
				moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_A_DROP_ICON, 0, 1, 0)
				moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DROP_AREA_10_INCH_PANEL_DESTINATION_B_DROP_ICON, 0, 1, 0)
				
				// show audio/lighting control popups
				moderoEnablePopupOnPage (dvTpDragAndDrop10, POPUP_NAME_CONTROLS_AUDIO, PAGE_NAME_MAIN)
				moderoEnablePopupOnPage (dvTpDragAndDrop10, POPUP_NAME_CONTROLS_LIGHTING, PAGE_NAME_MAIN)
				
				channelOff (dvTpDragAndDrop10, BTN_DRAG_AND_DROP_INSTRUCTIONS_10)
				//moderoEnableButtonAnimate (dvTpDragAndDrop10, BTN_DRAG_AND_DROP_INSTRUCTIONS_10, 0, 1, 0)
				
				//channelOff (dvTpDragAndDrop10, btnDropArea)
				
				// reset the draggable popup position by hiding it and then showing it again
				resetDraggablePopup (vdvDragAndDrop10, idDragItem)
			}
		}
	}
}

// Configure Resolutions for Multi-Preview Input and associated DVX Output
/*data_event [dvDvxVidOutMultiPreview]
data_event [dvTpTableMain]
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
}*/



data_event [dvPduMain1]
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

data_event [dvTpTableMain]
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
		
		switch (getSystemMode())
		{
			case SYSTEM_MODE_AV_OFF:
			{
				// flip to the splash screen
				moderoSetPage (dvTpTableMain, PAGE_NAME_SPLASH_SCREEN)
				// hide all popups
				moderoDisableAllPopups (dvTpTableMain)
				// reset all animations
				channelOff (dvTpTableDebug, 1)
				// stop live video preview
				disableVideoPreview ()
			}
			case SYSTEM_MODE_PRESENTATION:
			{
				// hide all popups
				moderoDisableAllPopups (dvTpTableMain)
				// flip to the user page
				moderoSetPage (dvTpTableMain, PAGE_NAME_MAIN_USER)
				// display the presentation popup
				moderoEnablePopup (dvTpTableMain, POPUP_NAME_SOURCE_SELECTION)
				// show the drag and drop popups
				enableDragItemsAll (vdvDragAndDrop19)
				showDraggablePopupsAll (vdvDragAndDrop19)
				// turn off animation
				channelOff (dvTpTableDebug, 1)
				// stop live video preview
				disableVideoPreview ()
			}
			case SYSTEM_MODE_VIDEO_CONFERENCE:
			{
				// hide all popups
				moderoDisableAllPopups (dvTpTableMain)
				// flip to the user page
				moderoSetPage (dvTpTableMain, PAGE_NAME_MAIN_USER)
				// show the VC main popup
				moderoEnablePopup (dvTpTableMain, POPUP_NAME_VIDEO_CONFERENCE_MAIN)
				// show the VC dial popup
				moderoEnablePopup (dvTpTableMain, POPUP_NAME_VIDEO_CONFERENCE_DIAL_ADDRESS)
			}
		}
	}
}

data_event [dvTpTableMain]
{
	string:
	{
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','data_event[dvTpTableMain] - string:'"
		send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','data.text = ',data.text"
		
		// start taking snapshots of each input as soon as the video preview popup closes
		if (find_string(data.text, '@PPF-popup-video-preview',1) == 1)
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','else if(find_string(data.text, "@PPF-popup-video-preview",1) == 1)'"
			// turn off the video being previewed flag
			isVideoBeingPreviewed = FALSE
			//startMultiPreviewSnapshots ()
		}
		else if( data.text == 'AWAKE' )	// panel just woke up
		{
			// this could have been caused by:
			// - user triggering panels' motion sensor
			// - user touching panels' touch overlay without triggering motion sensor somehow
			// - user VNC'ing to the panel
			// - program telling panel to wake up (i.e., if occ sensor triggers)
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','else if( data.text == "AWAKE" )'"
			
			if (isSystemAvInUse = FALSE)
				// turn on the lights
				lightsEnablePresetAllOn ()
		}
		else if( data.text == 'ASLEEP' )	// panel just went to sleep
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','else if( data.text == "ASLEEP" )'"
		}
		else if( data.text == 'STANDBY' )	// panel just went into standby
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','else if( data.text == "STANDBY" )'"
		}
		else if( data.text == 'SHUTDOWN' )	// panel just shut down
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','else if( data.text == "SHUTDOWN" )'"
		}
		else if( data.text == 'STARTUP' )	// panel just booted
		{
			send_string 0, "'DEBUG::',__FILE__,'::',itoa(__LINE__),'::','else if( data.text == "STARTUP" )'"
		}
	}
}


data_event [dvTpTableVideo]
{
	online:
	{
		moderoEnableButtonScaleToFit (dvTpTableVideo, BTN_ADR_VIDEO_MONITOR_LEFT_PREVIEW_SNAPSHOT, MODERO_BUTTON_STATE_ALL)
		moderoEnableButtonScaleToFit (dvTpTableVideo, BTN_ADR_VIDEO_MONITOR_RIGHT_PREVIEW_SNAPSHOT, MODERO_BUTTON_STATE_ALL)
	}
}


/*
 * --------------------
 * Button events
 * --------------------
 */



button_event [dvTpTableAudio,0]
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

/*
button_event [dvTpTableVideo,BTNS_VIDEO_MONITOR_LEFT_INPUT_SELECTION]
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
*/

/*
button_event [dvTpTableVideo,BTNS_VIDEO_MONITOR_RIGHT_INPUT_SELECTION]
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
*/

/*
button_event [dvTpTableVideo,0]
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
*/

button_event [dvTpTableLighting,0]
{
	push:
	{
		switch (button.input.channel)
		{
			case BTN_LIGHTING_PRESET_ALL_OFF:
			{
				lightsEnablePresetAllOff()
			}
		}
	}
}

button_event [dvTpTableBlinds,0]
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

button_event [dvTpTablePower,0]
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

button_event [dvTpTableCamera,0]
{
	push:
	{
		min_to [button.input]
		
		switch (button.input.channel)
		{
			case BTN_CAMERA_FOCUS_NEAR:  irOn (dvPtzCam, CAM1_FOCUS_NEAR)
			case BTN_CAMERA_FOCUS_FAR:   irOn (dvPtzCam, CAM1_FOCUS_FAR)
			case BTN_CAMERA_ZOOM_IN:     irOn (dvPtzCam, CAM1_ZOOM_FAST_TELE)
			case BTN_CAMERA_ZOOM_OUT:    irOn (dvPtzCam, CAM1_ZOOM_FAST_WIDE)
			case BTN_CAMERA_PAN_LEFT:    irOn (dvPtzCam, CAM1_REVERSE)
			case BTN_CAMERA_PAN_RIGHT:   irOn (dvPtzCam, CAM1_FORWARD)
			case BTN_CAMERA_TILT_DOWN:   irOn (dvPtzCam, CAM1_DOWN)
			case BTN_CAMERA_TILT_UP:     irOn (dvPtzCam, CAM1_UP)
			
			case BTN_CAMERA_HOME:
			{
				irPulse (dvPtzCam, CAM1_HOME)
			}
		}
	}
	release:
	{
		switch (button.input.channel)
		{
			case BTN_CAMERA_FOCUS_NEAR:  irOff (dvPtzCam, CAM1_FOCUS_NEAR)
			case BTN_CAMERA_FOCUS_FAR:   irOff (dvPtzCam, CAM1_FOCUS_FAR)
			case BTN_CAMERA_ZOOM_IN:     irOff (dvPtzCam, CAM1_ZOOM_FAST_TELE)
			case BTN_CAMERA_ZOOM_OUT:    irOff (dvPtzCam, CAM1_ZOOM_FAST_WIDE)
			case BTN_CAMERA_PAN_LEFT:    irOff (dvPtzCam, CAM1_REVERSE)
			case BTN_CAMERA_PAN_RIGHT:   irOff (dvPtzCam, CAM1_FORWARD)
			case BTN_CAMERA_TILT_DOWN:   irOff (dvPtzCam, CAM1_DOWN)
			case BTN_CAMERA_TILT_UP:     irOff (dvPtzCam, CAM1_UP)
		}
	}
}

button_event [dvTpTableDebug,0]
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

button_event [dvTpTableMain, 0]
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
				// NOTE: page flips done on the panel
				selectPresentationMode ()
			}
			
			case BTN_MAIN_PRESENTATION:
			{
				selectPresentationMode ()
			}
			
			case BTN_MAIN_VIDEO_CONFERENCE:
			{
				selectVcMode ()
			}
		}
	}
}


/*
 * --------------------
 * Level events
 * --------------------
 */

level_event [dvTpTableAudio, BTN_LVL_VOLUME_CONTROL]
{
	dvxSetAudioOutputVolume (dvDvxAudOutSpeakers, level.value)
}

level_event [dvTpTableLighting, BTN_LVL_LIGHTING_CONTROL]
{
	local_var integer newLightLevel
	
	newLightLevel = level.value
	
	// update display bargraph on 19" panel
	sendLevel (dvTpTableLighting, BTN_LVL_LIGHTING_DISPLAY , newLightLevel)
	
	if (level.value == 0)
	{
		// turn on feedback for the lights off button
		channelOn (dvTpTableLighting, BTN_LIGHTING_PRESET_ALL_OFF)
	}
	else
	{
		// turn off feedback for the lights off button
		channelOff (dvTpTableLighting, BTN_LIGHTING_PRESET_ALL_OFF)
	}
	
	wait waitTimeLightingUpdateFromBargraph
	{
		lightsSetLevelWithFade (LIGHTING_ADDRESS_BOARDROOM, newLightLevel, lightingDelaySecondsFromBargraphAdjust)
	}
}


/*
 * --------------------
 * Timeline events
 * --------------------
 */



/*
 * --------------------
 * Custom events
 * --------------------
 */


#end_if