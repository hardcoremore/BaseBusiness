package controllers
{
	import com.desktop.system.core.BaseController;
	import com.desktop.system.events.ResourceEvent;
	import com.desktop.system.events.SystemEvent;
	import com.desktop.system.interfaces.IModuleBase;
	import com.desktop.system.interfaces.IResourceHolder;
	import com.desktop.system.interfaces.IResourceLoader;
	import com.desktop.system.managers.ResourceLoadManager;
	import com.desktop.system.utility.ResourceLoadStatus;
	import com.desktop.system.utility.ResourceTypes;
	import com.desktop.system.vos.LoadResourceRequestVo;
	import com.desktop.system.vos.NotificationVo;
	import com.desktop.ui.Components.Button.DesktopButton;
	import com.desktop.ui.Components.Button.DesktopControllButton;
	import com.desktop.ui.Components.DesktopComponent;
	import com.desktop.ui.Components.Window.DesktopNotification;
	import com.desktop.ui.Components.Window.DesktopWindow;
	import com.desktop.ui.vos.ResourceHolderVo;
	
	import mx.core.IVisualElement;
	import mx.core.IVisualElementContainer;
	import mx.effects.Resize;
	import mx.events.FlexEvent;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import utility.Icons;
	
	public class ResourceRequestController extends BaseController
	{
		
		protected var _desktop:DesktopComponent;
		protected var _resourceLoadManager:IResourceLoader = ResourceLoadManager.instance;
		protected var _notifications:Vector.<IResourceHolder>;		
		
		
		public function ResourceRequestController()
		{
			_resourceLoadManager.addEventListener( ResourceEvent.RESOURCE_LOADED, _resourceLoaded );
			_resourceLoadManager.addEventListener( ResourceEvent.RESOURCE_LOADING_ERROR, _resourceLoadingError );
			_resourceLoadManager.addEventListener( ResourceEvent.RESOURCE_LOADING, _resourceLoading );
		}
		
		public function set desktop( d:DesktopComponent ):void
		{
			_desktop = d;
			_desktop.addEventListener( ResourceEvent.RESOURCE_LOAD_REQUEST, _resourceLoadRequest );
			_desktop.addEventListener( ResourceEvent.RESOURCE_REQUEST_UNLOAD, _resourceUnloadHandler );
		}
		
		public  function getResourceLoadingMessage( r:LoadResourceRequestVo ):String
		{
			var m:String;
			
			switch( r.type )
			{
				case ResourceTypes.MODULE:
					m = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "module" ) + " ";
					break;
				
				case ResourceTypes.GRAPHICS_SWF:
					m = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "image" ) + " ";	
					break;	
			}
			
			if( r.status.statusCode == ResourceLoadStatus.RESOURCE_LOAD_COMPLETED )
			{
				m += r.name + " " + resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "isLoaded" ) + ".";
			}
			else
			{
				m += r.name + " " + resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "isLoading" ) + " " + 
					Math.round( r.status.percentLoaded ) + "%";
			}
			
			return m;
		}
		/**************************
		 * 
		 * 	LOAD MANAGER EVENTS
		 * 
		 ***************************/		
		
		protected function _resourceLoadRequest( event:ResourceEvent ):void
		{	
			_resourceLoadManager.loadResource( event.resourceInfo );
		}
		
		protected function _resourceLoading( event:ResourceEvent ):void
		{
			if( event.resourceInfo )
			{
				if( event.resourceInfo.notifier )
				{
					var nvo:NotificationVo = new NotificationVo();
						nvo.id = event.resourceInfo.resourceId;
						nvo.title = resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "loading" );
						nvo.text = getResourceLoadingMessage( event.resourceInfo );
						nvo.icon = resourceManager.getClass( this.config.LOCALE_CONFIG.systemIconsResourceName, "loadingIcon", this.session.skinsLocaleName );
					
					event.resourceInfo.notifier.notify( nvo );
				}
				
				if( event.resourceInfo && event.resourceInfo.resourceHolderConfig && event.resourceInfo.resourceHolderConfig.cObject )
				{
					if( event.resourceInfo.resourceHolderConfig.cObject is DesktopControllButton )
					{
						( event.resourceInfo.resourceHolderConfig.cObject as DesktopControllButton ).percent = event.resourceInfo.status.percentLoaded;
					}
				}
				
			}	
		}
		
		protected function _resourceLoaded( event:ResourceEvent ):void
		{
			if( event.resourceInfo )
			{
				if(  event.resourceInfo.notifier )
				{
					var nvo:NotificationVo = new NotificationVo();
						nvo.autoCloseTime = this.config.DESKTOP_CONFIG.notificationAutoCloseTime;
						nvo.id = event.resourceInfo.resourceId;
						nvo.title = resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "loading" );
						nvo.text = getResourceLoadingMessage( event.resourceInfo );
						nvo.icon = resourceManager.getClass( this.config.LOCALE_CONFIG.systemIconsResourceName, "loadingIcon", this.session.skinsLocaleName ) ;
					
					event.resourceInfo.notifier.notify( nvo );
				}
				
				if( event.resourceInfo.createResourceHolderAutomatically )
				{		
					var rhc:ResourceHolderVo;
					var m:IModuleBase = event.resourceInfo.resource as IModuleBase;
					
					if( m ) 
					{
						// if not found on module try to pull it from resourceInfo
						if( m.resourceHolderConfig )
						{
							rhc = m.resourceHolderConfig;
						}
						else
						{
							// create default rhc if it is not found on module or resourceInfo
							if( ! event.resourceInfo.resourceHolderConfig )
							{
								rhc = new ResourceHolderVo();
								rhc.title = event.resourceInfo.name;
								rhc.titleBarIcon = event.resourceInfo.icon;
								rhc.minimizable = true;
								rhc.maximizable = true;
								rhc.resizable = true;
								
								event.resourceInfo.resourceHolderConfig = rhc;
							}
							else
							{
								rhc = event.resourceInfo.resourceHolderConfig;
							}
							
							m.resourceHolderConfig = rhc;
						}
						
						m.init();
					}
					
					rhc.id = event.resourceInfo.resourceId;
					
					var w:IResourceHolder = _desktop.addResourceHolder( rhc );
						if( m ) m.resourceHolder = w;
					
					var moduleVisual:IVisualElement = event.resourceInfo.resource as IVisualElement;
					
					 if( w )
					 {
						 w.resourceInfo = event.resourceInfo;
						 w.addElement( moduleVisual );
					 }	
				}
			}
		}
		
		protected function _resourceUnloadHandler( event:ResourceEvent ):void
		{
			_resourceLoadManager.unloadResource( event.resourceInfo );
		}
		
		protected function _resourceLoadingError( event:ResourceEvent ):void
		{
			if( event.resourceInfo && event.resourceInfo.notifier )
			{
				var nvo:NotificationVo = new NotificationVo( 
					resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "error" ),
					resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "module" ) + " " +
					event.resourceInfo.name + " " +
					resourceManager.getString( this.config.LOCALE_CONFIG.messagesResourceName, "failedToLoad" ),
					resourceManager.getClass( this.config.LOCALE_CONFIG.systemIconsResourceName, "deleteErrorIcon", this.session.skinsLocaleName ),
					0,
					event.resourceInfo.resourceId											 
				);
				
				event.resourceInfo.notifier.notify( nvo );
			}
			
		}
	}
}