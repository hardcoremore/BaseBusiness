package modules
{
	import com.desktop.system.Application.Library.ui.FormHelper;
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.core.SystemModuleBase;
	import com.desktop.system.events.LanguageChangedEvent;
	import com.desktop.system.events.ModelDataChangeEvent;
	
	import factories.ModelFactory;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import interfaces.modules.IConfigModule;
	
	import models.DesktopModel;
	
	import mx.containers.ViewStack;
	import mx.controls.ColorPicker;
	import mx.events.ColorPickerEvent;
	
	import spark.components.Button;
	import spark.components.CheckBox;
	import spark.components.ComboBox;
	import spark.components.DataGrid;
	import spark.components.HSlider;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.events.GridSelectionEvent;
	import spark.events.IndexChangeEvent;
	
	import vos.DesktopAppearanceVo;
	
	public class ConfigModule extends SystemModuleBase implements IConfigModule
	{
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var autoLockSlider:HSlider;
		
		/**
		 *  @public
		 */
		
		[SkinPart(required="false")]
		public var languageCb:ComboBox;
		
		/**
		 *  @public
		 */
		
		[SkinPart(required="true")]
		public var taskBarPositionComboBox:ComboBox;
		
		/**
		 *  @public
		 */
		
		[SkinPart(required="true")]
		public var taskBarLabelVisibleCheckBox:CheckBox;
		
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var newThemeButton:Button;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var saveThemeButton:Button;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var applyThemeButton:Button;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var refreshButton:Button;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var deleteThemeButton:Button;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var taskBarThicknessSlider:HSlider;
		
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var fontSizeSlider:HSlider;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var windowBackgroundColorPicker:ColorPicker;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var iconSizeSlider:HSlider;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var desktopWallPaperType:ComboBox;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var wallpaperImageUrlInput:TextInput;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var desktopWallpaperColorPicker:ColorPicker;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var windowBackgroundAlphaSlider:HSlider;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var windowBorderColorColorPicker:ColorPicker;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var windowBorderAlphaSlider:HSlider;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var taskBarBackgroundColorColorPicker:ColorPicker;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var taskBarBackgroundAlphaSlider:HSlider;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var controllButtonSizeSlider:HSlider;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var appearancesDataHolder:DataGrid;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var desktop_appearance_default:CheckBox;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var desktop_appearance_name:TextInput;
		
		/**
		 *  @public
		 */
		[SkinPart(required="true")]
		public var configFormNavigators:ViewStack;
		
		private var __desktop_model:DesktopModel;
		
		public function ConfigModule()
		{
			super();
		}
		
		override public function init():void
		{
			super.init();
			
			__desktop_model = ModelFactory.desktopModel();
			
			setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "configModule", this.session.skinsLocaleName ) );
			
			//setStyle( "skinClass", ConfigModuleSkin );
		}
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			
			if( instance == autoLockSlider )
			{
				autoLockSlider.addEventListener(Event.CHANGE, onAutoLockSlideChange);
			}
			else if( instance == languageCb )
			{
				languageCb.addEventListener(IndexChangeEvent.CHANGE, languageCb_changeHandler);
			}
			else if( instance == taskBarPositionComboBox )
			{
				taskBarPositionComboBox.addEventListener(IndexChangeEvent.CHANGE, taskBarPosition_changeHandler);
			}
			else if( instance == taskBarLabelVisibleCheckBox )
			{
				taskBarLabelVisibleCheckBox.addEventListener( MouseEvent.CLICK, taskBarLabelVisible_changeHandler);
			}
			else if( instance == taskBarThicknessSlider )
			{
				taskBarThicknessSlider.addEventListener( Event.CHANGE, _taskBarThicknessSliderEventHandler );
			}
			else if( instance == fontSizeSlider )
			{
				fontSizeSlider.addEventListener( Event.CHANGE,_fontSizeSliderEventHandler );
			}
			else if( instance == iconSizeSlider )
			{
				iconSizeSlider.addEventListener( Event.CHANGE,  _iconSizeSliderEventHandler );
			}
			else if( instance == desktopWallPaperType )
			{
				desktopWallPaperType.addEventListener( IndexChangeEvent.CHANGE, _wallpaperTypeChange );
			}
			else if( instance == wallpaperImageUrlInput )
			{
				wallpaperImageUrlInput.addEventListener( Event.CHANGE, _wallpaperImageUrlChange );
			}
			else if( instance == desktopWallpaperColorPicker )
			{
				desktopWallpaperColorPicker.addEventListener( ColorPickerEvent.CHANGE, _wallpaperColorChange );
			}
			else if( instance == windowBackgroundColorPicker )
			{
				windowBackgroundColorPicker.addEventListener( ColorPickerEvent.CHANGE, _windowBackgroundColorPickerChange );
			}
			else if( instance == windowBackgroundAlphaSlider )
			{
				windowBackgroundAlphaSlider.addEventListener( Event.CHANGE, _windowBackgroundAlphaChanged );
			}
			else if( instance == windowBorderColorColorPicker )
			{
				windowBorderColorColorPicker.addEventListener( ColorPickerEvent.CHANGE, _windowBorderColorColorPickerChange );
		    }
			else if( instance == windowBorderAlphaSlider )
			{
				windowBorderAlphaSlider.addEventListener( Event.CHANGE, _windowBorderAlphaChanged );
			}
			else if( instance == taskBarBackgroundAlphaSlider )
			{
				taskBarBackgroundAlphaSlider.addEventListener( Event.CHANGE, _taskBarBackgroundAlphaChanged );
			}
			else if( instance == taskBarBackgroundColorColorPicker )
			{
				taskBarBackgroundColorColorPicker.addEventListener( ColorPickerEvent.CHANGE, _taskbarBackgroundColorPickerChange );
			}	
			else if( instance == controllButtonSizeSlider )
			{
				controllButtonSizeSlider.addEventListener( Event.CHANGE, _controllButtonSizeSliderChanged );
			}
			else if( instance == appearancesDataHolder )
			{
				__desktop_model.readDesktopAppearances( this );
				appearancesDataHolder.addEventListener( GridSelectionEvent.SELECTION_CHANGE, _appearancesSelectionChangeEventHandler );
			}
			else if( instance == newThemeButton )
			{
				newThemeButton.addEventListener( MouseEvent.CLICK, _saveThemeClickHandler );
			}
			else if( instance == saveThemeButton )
			{
				saveThemeButton.addEventListener( MouseEvent.CLICK, _saveThemeClickHandler );
			}
			else if( instance == refreshButton )
			{
				refreshButton.addEventListener( MouseEvent.CLICK, _refreshThemesClickHandler );
			}
			else if( instance == applyThemeButton )
			{
				applyThemeButton.addEventListener( MouseEvent.CLICK, _applyButtonClickHandler );
			}
			
			super.partAdded(partName, instance);
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			
			if( instance == autoLockSlider )
				autoLockSlider.removeEventListener(Event.CHANGE, onAutoLockSlideChange);
			
			if( instance == languageCb )
				languageCb.removeEventListener(IndexChangeEvent.CHANGE, languageCb_changeHandler)
			
			if( instance == taskBarPositionComboBox )
				taskBarPositionComboBox.removeEventListener(IndexChangeEvent.CHANGE, taskBarPosition_changeHandler)
			
			if( instance == taskBarLabelVisibleCheckBox )
				taskBarLabelVisibleCheckBox.removeEventListener(IndexChangeEvent.CHANGE, taskBarLabelVisible_changeHandler)
			
			super.partRemoved(partName, instance);
		}
		
		override public function modelLoadingDataComplete(event:ModelDataChangeEvent):void
		{
			loadingContainer.loading = false;
			if( event.operationName == DesktopModel.DESKTOP_READ_APPEARANCES_CONFIG_OPERATION )
			{
				_updateReadData( event.response, appearancesDataHolder );
				saveThemeButton.enabled = false;
			}
			else if( event.operationName == DesktopModel.DESKTOP_CREATE_APPEARANCE_CONFIG_OPERATION )
			{
				addRowToDataProvider( appearancesDataHolder as DataGrid, event.response.result );
			}
			else if( event.operationName == DesktopModel.DESKTOP_UPDATE_APPEARANCE_CONFIG_OPERATION )
			{
				__desktop_model.readDesktopAppearances( this );
				setAppearanceForm( __desktop_model.currentAppearance );
			}
		}
		
		override public function modelLoadingData(event:ModelDataChangeEvent):void
		{
			loadingContainer.loading = true;
		}
		
		public function setAppearanceForm( da:DesktopAppearanceVo ):void
		{			
			if( configFormNavigators && da )
			{
				desktop_appearance_default.selected = BaseModel.getStringBoolean( da.desktop_appearance_default );
				desktop_appearance_name.text = da.desktop_appearance_name;
				controllButtonSizeSlider.value = da.desktop_appearance_controll_button_size;
				fontSizeSlider.value = da.desktop_appearance_font_size;
				iconSizeSlider.value = da.desktop_appearance_icon_size;
				
				wallpaperImageUrlInput.text = da.desktop_appearance_wallpaper_url;
				desktopWallpaperColorPicker.selectedColor = da.desktop_appearance_wallpaper_color;
				FormHelper.setComboBoxSelectedValue( desktopWallPaperType, "value", da.desktop_appearance_wallpaper_type );
				
				taskBarBackgroundAlphaSlider.value = da.desktop_appearance_taskbar_alpha;
				taskBarBackgroundColorColorPicker.selectedColor = da.desktop_appearance_taskbar_color;
				taskBarLabelVisibleCheckBox.selected = BaseModel.getStringBoolean( da.desktop_appearance_taskbar_label_visible );
				FormHelper.setComboBoxSelectedValue( taskBarPositionComboBox, "value", da.desktop_appearance_taskbar_position ); 
				taskBarThicknessSlider.value = da.desktop_appearance_taskbar_thickness;
				windowBackgroundAlphaSlider.value = da.desktop_appearance_window_background_alpha;
				windowBackgroundColorPicker.selectedColor = da.desktop_appearance_window_background_color;
				windowBorderAlphaSlider.value = da.desktop_appearance_window_border_alpha;
				windowBorderColorColorPicker.selectedColor = da.desktop_appearance_window_border_color;
			}
		}
		
		protected function _getCurrentAppearance():DesktopAppearanceVo
		{
			var da:DesktopAppearanceVo = new DesktopAppearanceVo();
				da.desktop_appearance_controll_button_size = controllButtonSizeSlider.value;
				da.desktop_appearance_default = desktop_appearance_default.selected ? "1" : "0";
				da.desktop_appearance_font_size = fontSizeSlider.value;
				da.desktop_appearance_icon_size = iconSizeSlider.value;
				
				da.desktop_appearance_wallpaper_color = desktopWallpaperColorPicker.selectedColor;
				da.desktop_appearance_wallpaper_type = desktopWallPaperType.selectedItem.value;
				da.desktop_appearance_wallpaper_url = wallpaperImageUrlInput.text;
				
				da.desktop_appearance_name = desktop_appearance_name.text;
				da.desktop_appearance_taskbar_alpha = taskBarBackgroundAlphaSlider.value;
				da.desktop_appearance_taskbar_color = taskBarBackgroundColorColorPicker.selectedColor;
				da.desktop_appearance_taskbar_label_visible = taskBarLabelVisibleCheckBox.selected ? "1" : "0";
				da.desktop_appearance_taskbar_position = taskBarPositionComboBox.selectedItem.value;
				da.desktop_appearance_taskbar_thickness = taskBarThicknessSlider.value;
				da.desktop_appearance_window_background_alpha = windowBackgroundAlphaSlider.value;
				da.desktop_appearance_window_background_color = windowBackgroundColorPicker.selectedColor;
				da.desktop_appearance_window_border_alpha = windowBorderAlphaSlider.value;
				da.desktop_appearance_window_border_color = windowBorderColorColorPicker.selectedColor;
			
			return da;
		}
		
		protected function _saveThemeClickHandler( event:MouseEvent ):void
		{
			var ap:DesktopAppearanceVo = _getCurrentAppearance();
			
			if( event.currentTarget == newThemeButton )
			{
				__desktop_model.createDesktopAppearance( ap, this )
			}
			else if( event.currentTarget == saveThemeButton )
			{
				ap.desktop_appearance_id = appearancesDataHolder.selectedItem.desktop_appearance_id;
				__desktop_model.updateDesktopAppearance( ap, this );	
			}
		}
		
		protected function _appearancesSelectionChangeEventHandler( event:GridSelectionEvent ):void
		{
			if( appearancesDataHolder.selectedIndex == -1 ) 
				return;
			
			saveThemeButton.enabled = true;
			applyThemeButton.enabled = true;
			setAppearanceForm( appearancesDataHolder.selectedItem as DesktopAppearanceVo );
		}
				
		protected function _applyButtonClickHandler( event:MouseEvent ):void
		{
			var ap:DesktopAppearanceVo = appearancesDataHolder.selectedItem as DesktopAppearanceVo; 
				applyThemeButton.enabled = false;
				__desktop_model.currentAppearance = ap;
		}
		
		protected function _refreshThemesClickHandler( event:MouseEvent ):void
		{
			saveThemeButton.enabled = false;
			__desktop_model.readDesktopAppearances( this );
		}
		
		protected function _taskBarThicknessSliderEventHandler( event:Event ):void
		{
			applyThemeButton.enabled = true;
			
			if( appearancesDataHolder.selectedItem )
				saveThemeButton.enabled = true;
			
			__desktop_model.taskBarThickness = taskBarThicknessSlider.value;
		}
		
		protected function _iconSizeSliderEventHandler( event:Event ):void
		{
			
			applyThemeButton.enabled = true;
			
			if( appearancesDataHolder.selectedItem )
				saveThemeButton.enabled = true;
			
			__desktop_model.iconSize = iconSizeSlider.value;
		}
		
		protected function _fontSizeSliderEventHandler( event:Event ):void
		{
			
			if( appearancesDataHolder.selectedItem )
				saveThemeButton.enabled = true;
			
			__desktop_model.fontSize = fontSizeSlider.value;
		}
		
		protected function _wallpaperTypeChange( event:IndexChangeEvent ):void
		{
			applyThemeButton.enabled = true;
			
			if( appearancesDataHolder.selectedItem )
				saveThemeButton.enabled = true;
			
			__desktop_model.wallpaperType = event.target.selectedItem.value;
			
			if( event.target.selectedItem.value == DesktopModel.DESKTOP_WALLPAPER_TYPE_COLOR )
			{
				wallpaperImageUrlInput.enabled = false;
				desktopWallpaperColorPicker.enabled = true;
			}
			else
			{
				wallpaperImageUrlInput.enabled = true;
				desktopWallpaperColorPicker.enabled = false;
			}
			
			trace( "WALLPAPER TYPE CHANGE" );
		}
		
		protected function _wallpaperImageUrlChange( event:Event ):void
		{
			applyThemeButton.enabled = true;
			
			if( appearancesDataHolder.selectedItem )
				saveThemeButton.enabled = true;
			
			__desktop_model.wallpaperImageUrl = event.target.text;
		}
		
		protected function _wallpaperColorChange( event:ColorPickerEvent ):void
		{
			applyThemeButton.enabled = true;
			
			if( appearancesDataHolder.selectedItem )
				saveThemeButton.enabled = true;
			
			trace( "WALL PAPER COLOR CHANGE: " + event.color );
			
			__desktop_model.wallpaperColor = event.color;
		}
		
		protected function _windowBackgroundColorPickerChange( event:ColorPickerEvent ):void
		{
			applyThemeButton.enabled = true;
			
			if( appearancesDataHolder.selectedItem )
				saveThemeButton.enabled = true;
			
			__desktop_model.windowBackgroundColor = event.color;
		}
		
		protected function _windowBorderColorColorPickerChange( event:ColorPickerEvent ):void
		{
			applyThemeButton.enabled = true;
			
			if( appearancesDataHolder.selectedItem )
				saveThemeButton.enabled = true;
			
			__desktop_model.windowBorderColor = event.color;
		}
		
		protected function _windowBackgroundAlphaChanged( event:Event ):void
		{
			applyThemeButton.enabled = true;
			
			if( appearancesDataHolder.selectedItem )
				saveThemeButton.enabled = true;
			
			__desktop_model.windowBackgroundAlpha = windowBackgroundAlphaSlider.value;
		}
		
		protected function _windowBorderAlphaChanged( event:Event ):void
		{
			applyThemeButton.enabled = true;
			
			if( appearancesDataHolder.selectedItem )
				saveThemeButton.enabled = true;
			
			__desktop_model.windowBorderAlpha = windowBorderAlphaSlider.value;
		}
		
		protected function _controllButtonSizeSliderChanged( event:Event ):void
		{
			applyThemeButton.enabled = true;
			
			if( appearancesDataHolder.selectedItem )
				saveThemeButton.enabled = true;
			
			__desktop_model.controllButtonSize = controllButtonSizeSlider.value;
		}
		
		protected function languageCb_changeHandler(event:IndexChangeEvent):void
		{
			//dispatchEvent( new LanguageChangedEvent(LanguageChangedEvent.LANGUAGE_CHANGED, languageCb.selectedItem.value) );
		}
		
		protected function onAutoLockSlideChange(event:Event):void	
		{	
			/*
			var s:SliderBase = event.target as SliderBase;
			
			dispatchEvent( new SliderValueChangeEvent(SliderValueChangeEvent.SLIDER_VALUE_CHANGE, s.value, s) );
			*/
		}
		
		protected function taskBarPosition_changeHandler( event:IndexChangeEvent ):void	
		{	
			applyThemeButton.enabled = true;
			
			if( appearancesDataHolder.selectedItem )
				saveThemeButton.enabled = true;
			
			__desktop_model.taskBarPosition = taskBarPositionComboBox.selectedItem.value;
		}
		
		protected function taskBarLabelVisible_changeHandler( event:MouseEvent):void
		{	
			applyThemeButton.enabled = true;
			
			if( appearancesDataHolder.selectedItem )
				saveThemeButton.enabled = true;
			
			__desktop_model.taskBarLabelVisible = taskBarLabelVisibleCheckBox.selected;
		}
		
		protected function _taskbarBackgroundColorPickerChange( event:ColorPickerEvent ):void
		{
			applyThemeButton.enabled = true;
			
			if( appearancesDataHolder.selectedItem )
				saveThemeButton.enabled = true;
			
			__desktop_model.taskBarBackgroundColor = event.color
		}
		
		protected function _taskBarBackgroundAlphaChanged( event:Event):void
		{
			applyThemeButton.enabled = true;
			
			if( appearancesDataHolder.selectedItem )
				saveThemeButton.enabled = true;
			
			__desktop_model.taskBarAlpha = taskBarBackgroundAlphaSlider.value;
		}
		
	}	
}