package models
{
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.core.service.ServiceLoader;
	import com.desktop.system.core.service.events.ServiceEvent;
	import com.desktop.system.interfaces.IServiceReqester;
	import com.desktop.system.vos.ResourceConfigVo;
	import com.desktop.system.vos.WebServiceRequestVo;
	
	import flash.events.IEventDispatcher;
	import flash.utils.setTimeout;
	
	import mx.styles.IStyleManager2;
	import mx.styles.StyleManager;
	
	import vos.DesktopAppearanceVo;
	import vos.GridConfigVo;
	
	public class DesktopModel extends BaseModel
	{
		
		public static const DESKTOP_CREATE_APPEARANCE_CONFIG_OPERATION:String = "createDesktopAppearance";
		public static const DESKTOP_READ_APPEARANCES_CONFIG_OPERATION:String = "readDesktopAppearances";
		public static const DESKTOP_READ_DEFAULT_APPEARANCE_CONFIG_OPERATION:String = "readDefaultDesktopAppearance";
		public static const DESKTOP_UPDATE_APPEARANCE_CONFIG_OPERATION:String = "updateDesktopAppearance";
		
		public static const DESKTOP_READ_GRID_CONFIG_OPERATION:String = "readGridConfig";
		public static const DESKTOP_UPDATE_GRID_CONFIG_OPERATION:String = "updateGridConfig";
		
		public static const DESKTOP_WALLPAPER_TYPE_COLOR:String = "color";
		public static const DESKTOP_WALLPAPER_TYPE_IMAGE:String = "image";
		
		public static const DESKTOP_ICON_RESOURCE_TYPE_MODULE:uint = 1;
		public static const DESKTOP_ICON_RESOURCE_TYPE_IMAGE:uint = 2;
		public static const DESKTOP_ICON_RESOURCE_TYPE_TEXT:uint = 3;

		
		private var __styleManager:IStyleManager2;
		private var __current_appearance:DesktopAppearanceVo;
		
		public function DesktopModel( resourceConfigVo:ResourceConfigVo, target:IEventDispatcher=null)
		{
			super( resourceConfigVo, target);
			__styleManager = StyleManager.getStyleManager( null );
		}
		
		public function get currentAppearance():DesktopAppearanceVo
		{
			return __current_appearance;
		}
		
		public function set currentAppearance( da:DesktopAppearanceVo ):void
		{
			__current_appearance = da;
			
			taskBarAlpha = Number( da.desktop_appearance_taskbar_alpha );
			taskBarBackgroundColor = uint( da.desktop_appearance_taskbar_color );
			
			windowBackgroundAlpha = Number( da.desktop_appearance_window_background_alpha );
			windowBackgroundColor = uint( da.desktop_appearance_window_background_color );
			windowBorderAlpha = Number( da.desktop_appearance_window_border_alpha );
			windowBorderColor = uint( da.desktop_appearance_window_border_color );
			
			wallpaperType = da.desktop_appearance_wallpaper_type;
			wallpaperColor = uint( da.desktop_appearance_wallpaper_color );
			wallpaperImageUrl = da.desktop_appearance_wallpaper_url;
			
			iconSize = uint( da.desktop_appearance_icon_size );
			fontSize = uint( da.desktop_appearance_font_size );
			
			controllButtonSize = uint( da.desktop_appearance_controll_button_size );
			
			taskBarPosition = da.desktop_appearance_taskbar_position;
			taskBarThickness = uint( da.desktop_appearance_taskbar_thickness );
			taskBarLabelVisible = BaseModel.getStringBoolean( da.desktop_appearance_taskbar_label_visible );
			
		}
		
		public function set taskBarThickness( value:uint ):void
		{
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.DesktopComponent" ).setStyle( "taskBarThickness", value );
		}
		
		public function set iconSize( value:uint ):void
		{
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.Button.Icon" ).setStyle( "iconWidth", value );
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.Button.Icon" ).setStyle( "iconHeight", value );
		}
		
		public function set fontSize( value:uint ):void
		{
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.DesktopComponent" ).setStyle( "fontSize", value );
			__styleManager.getStyleDeclaration( "spark.components.Button" ).setStyle( "fontSize", value );
			__styleManager.getStyleDeclaration( "mx.controls.ToolTip" ).setStyle( "fontSize", value );
			__styleManager.getStyleDeclaration( "spark.components.FormItem" ).setStyle( "fontSize", value );
			__styleManager.getStyleDeclaration( "spark.components.DataGrid" ).setStyle( "fontSize", value );
			__styleManager.getStyleDeclaration( "mx.containers.Accordion" ).setStyle( "fontSize", value );
			__styleManager.getStyleDeclaration( "spark.components.NumericStepper" ).setStyle( "fontSize", value );
			
		}
		
		public function set wallpaperType( type:String ):void
		{
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.DesktopComponent" ).setStyle( "wallpaperType", type );
		}
		
		public function set wallpaperImageUrl( url:String ):void
		{
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.DesktopComponent" ).setStyle( "wallpaperImageUrl", url );	
		}
		
		public function set wallpaperColor( color:uint ):void
		{
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.DesktopComponent" ).setStyle( "wallpaperColor", color );
		}
		
		public function set windowBorderColor( value:uint ):void
		{
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.Window.DesktopNotification" ).setStyle( "borderColor", value );
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.Window.DesktopWindow" ).setStyle( "borderColor", value  );
		}
		
		public function set windowBackgroundColor( value:uint ):void
		{
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.Window.DesktopNotification" ).setStyle( "backgroundColor", value );
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.Window.DesktopWindow" ).setStyle( "backgroundColor", value );
		}
		
		public function set windowBackgroundAlpha( value:Number ):void
		{
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.Window.DesktopNotification" ).setStyle( "backgroundAlpha", value );
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.Window.DesktopWindow" ).setStyle( "backgroundAlpha", value  );
		}
		
		
		public function set windowBorderAlpha( value:Number ):void
		{
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.Window.DesktopNotification" ).setStyle( "backgroundAlpha", value );
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.Window.DesktopWindow" ).setStyle( "borderAlpha", value  );
		}
		
		public function set controllButtonSize( value:uint ):void
		{
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.Button.DesktopControllButton" ).setStyle( "iconWidth", value );
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.Button.DesktopControllButton" ).setStyle( "iconHeight", value );
		}
		
		public function set taskBarPosition( value:String ):void
		{
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.DesktopComponent" ).setStyle( "taskBarPosition", value );
		}
		
		public function set taskBarLabelVisible( value:Boolean ):void
		{
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.NavBars.TaskBar" ).setStyle( "labelVisible", value  );
		}
		
		public function set taskBarBackgroundColor( value:uint ):void
		{
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.NavBars.TaskBar" ).setStyle( "backgroundColor", value );
		}
		
		public function set taskBarAlpha( value:Number ):void
		{
			__styleManager.getStyleDeclaration( "com.desktop.ui.Components.NavBars.TaskBar" ).setStyle( "backgroundAlpha", value );
		}
		
		public function createDesktopAppearance( d:DesktopAppearanceVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "desktop";
				web.action = DESKTOP_CREATE_APPEARANCE_CONFIG_OPERATION;
				web.data = _getUrlVariablesFromVo( d );
				
			_startOperation( web, service );
		}
		
		public function readDesktopAppearances( requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "desktop";
				web.action = DESKTOP_READ_APPEARANCES_CONFIG_OPERATION;
				
				web.voClasses = new Object();
				web.voClasses.DesktopAppearanceVo = "vos.DesktopAppearanceVo";
				
			_startOperation( web, service );
		}
		
		public function readDefaultDesktopAppearance( requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
			service.addEventListener( ServiceEvent.COMPLETE, _finishOperation );
			service.addEventListener( ServiceEvent.ERROR, _finishOperation );
			service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "desktop";
				web.action = DESKTOP_READ_DEFAULT_APPEARANCE_CONFIG_OPERATION;
				
				web.voClasses = new Object();
				web.voClasses.DesktopAppearanceVo = "vos.DesktopAppearanceVo";
			
			_startOperation( web, service );
		}
		
		public function updateDesktopAppearance( d:DesktopAppearanceVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.addEventListener( ServiceEvent.COMPLETE, _finishOperation );
				service.addEventListener( ServiceEvent.ERROR, _finishOperation );
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "desktop";
				web.action = DESKTOP_UPDATE_APPEARANCE_CONFIG_OPERATION;
				web.data = _getUrlVariablesFromVo( d ); 
					
			_startOperation( web, service );
		}
		
		public function readGridConfig( r:GridConfigVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.addEventListener( ServiceEvent.COMPLETE, _finishOperation );
				service.addEventListener( ServiceEvent.ERROR, _finishOperation );
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "desktop";
				web.action = DESKTOP_READ_GRID_CONFIG_OPERATION;
			
			web.data = _getUrlVariablesFromVo( r );
			
			_startOperation( web, service );
		}
		
		public function updateGridConfig( d:GridConfigVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.addEventListener( ServiceEvent.COMPLETE, _finishOperation );
				service.addEventListener( ServiceEvent.ERROR, _finishOperation );
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "desktop";
				web.action = DESKTOP_UPDATE_GRID_CONFIG_OPERATION;
			
				web.data = _getUrlVariablesFromVo( d );
			
			_startOperation( web, service );
		}
		
	}
}