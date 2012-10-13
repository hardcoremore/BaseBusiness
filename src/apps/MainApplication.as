package apps
{
	import com.desktop.system.core.ApplicationBase;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.events.ModuleEvent;
	import com.desktop.system.events.ResourceEvent;
	import com.desktop.system.events.SystemEvent;
	import com.desktop.system.interfaces.IConfig;
	import com.desktop.system.interfaces.ILoadResourceRequester;
	import com.desktop.system.interfaces.IModuleBase;
	import com.desktop.system.interfaces.IResourceLoader;
	import com.desktop.system.interfaces.IServiceReqester;
	import com.desktop.system.managers.ResourceLoadManager;
	import com.desktop.system.utility.ModelQueeLoader;
	import com.desktop.system.utility.QueeLoader;
	import com.desktop.system.utility.ResourceLoadStatus;
	import com.desktop.system.utility.ResourceTypes;
	import com.desktop.system.vos.LoadResourceRequestVo;
	import com.desktop.system.vos.ModelLoaderQueeRequestVo;
	import com.desktop.system.vos.NotificationVo;
	import com.desktop.ui.Components.DesktopComponent;
	import com.desktop.ui.Components.Group.LoadingContainer;
	import com.desktop.ui.Events.DesktopEvent;
	import com.desktop.ui.vos.ButtonVo;
	import com.desktop.ui.vos.ResourceHolderVo;
	
	import controllers.ResourceRequestController;
	
	import factories.ModelFactory;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.setTimeout;
	
	import interfaces.modules.IConfigModule;
	
	import models.DesktopModel;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.IFlexDisplayObject;
	import mx.core.IVisualElementContainer;
	import mx.events.ResizeEvent;
	import mx.managers.PopUpManager;
	
	import skins.Default.components.Group.LoadingContainerSkin;
	
	import vos.AuthenticationVo;
	import vos.DesktopAppearanceVo;
	
	public class MainApplication extends ApplicationBase implements ILoadResourceRequester, IServiceReqester
	{
		private var __queeLoader:QueeLoader;
		
		private var __resourceRequestController:ResourceRequestController;
		
		
		
		/***
		 * 
		 *  MODULES PROPERTIES 
		 * 
		 ****/
		private var __customers_resource_request:LoadResourceRequestVo;
		private var __employees_resource_request:LoadResourceRequestVo;
		private var __storage_resource_request:LoadResourceRequestVo;
		private var __users_resource_request:LoadResourceRequestVo;
		private var __storage_input_module_request:LoadResourceRequestVo;
		private var __invoices_input_module_request:LoadResourceRequestVo;
		
		public static var DESKTOP_CMP:DesktopComponent;
		
		public static var MAIN_MENU_DATA:ArrayList;
		
		private static var __configModule:IConfigModule;
		
		private var __cri:LoadResourceRequestVo;
		
		private var __resourceLoader:IResourceLoader;
		
		private var __loadingContainer:LoadingContainer;
		
		private var __desktop_model:DesktopModel;
		
		private var __user_appearance:DesktopAppearanceVo;
		
		
		public function MainApplication( config:IConfig, renderTo:IVisualElementContainer )
		{
			super( config, renderTo );
			
			__resourceLoader = ResourceLoadManager.instance;
			
			__cri = new LoadResourceRequestVo( "desktopConfigModule", 
					this.session.config.RESOURCE_CONFIG.moduleBasePath + "ConfigModule.swf", 
					ResourceTypes.MODULE
				);
			
			__cri.createResourceHolderAutomatically = true;
			__cri.requester = this;
			
			__desktop_model = ModelFactory.desktopModel();
			
		}
		
		
		override public function initializeApplication():void
		{
			super.initializeApplication();
			
			__loadingContainer = new LoadingContainer();
			__loadingContainer.setStyle( "skinClass", LoadingContainerSkin );
			__loadingContainer.percentHeight = 100;
			__loadingContainer.percentWidth = 100;
			
			displayContainer.addElement( __loadingContainer );
			
			MAIN_MENU_DATA = new ArrayList();
		}
		
		override public function startApp():void
		{
			super.startApp();
			
			var language_resource_module:LoadResourceRequestVo = new LoadResourceRequestVo(
				"language_" + authenticationModel.language,
				this.config.LOCALE_CONFIG.resourceModulePath + "locale/" + authenticationModel.language + "_LocaleResourceModule.swf",
				ResourceTypes.RESOURCE_MODULE				
			);
			
			language_resource_module.resourceModuleLocale = authenticationModel.language;
			
			var skin_resource_module:LoadResourceRequestVo = new LoadResourceRequestVo(
				"default_skinClasses",
				this.config.LOCALE_CONFIG.resourceModulePath + "skins/Default_SkinResourceModule.swf",
				ResourceTypes.RESOURCE_MODULE
			);
			
			var icons_resource_module:LoadResourceRequestVo = new LoadResourceRequestVo(
				"default_systemIconClasses",
				this.config.LOCALE_CONFIG.resourceModulePath + "skins/Default_SystemIconsResourceModule.swf",
				ResourceTypes.RESOURCE_MODULE
			);
			
			__queeLoader = new QueeLoader();
			__queeLoader.addEventListener( com.desktop.system.events.ResourceEvent.QUEE_COMPLETED, _queeCompletedEventHandler );
			__queeLoader.addEventListener( com.desktop.system.events.ResourceEvent.RESOURCE_LOADING, _queeResourceLoadingEventHandler );
			__queeLoader.addEventListener( com.desktop.system.events.ResourceEvent.RESOURCE_LOADED, _resourceLoadedEventHandler );
			
			__queeLoader.addToQuee( icons_resource_module );
			__queeLoader.addToQuee( skin_resource_module );
			__queeLoader.addToQuee( language_resource_module );
			
			__loadingContainer.loading = true;
			__queeLoader.load();
			
			
		}
		
		
/************************************
 * 
 * EVENT HANDLERS
 * 
 ***********************************/
		
		protected function _queeResourceLoadingEventHandler( event:com.desktop.system.events.ResourceEvent ):void
		{
			//trace( "Quee loading. Id: " + event.resourceInfo.resourceId, "System Memory: " + ( System.totalMemory / 1024 ) );
			__loadingContainer.loadingMessage = Math.round( event.queePercentLoaded ).toString() + "%";
		}
		
		protected function _resourceLoadedEventHandler( event:com.desktop.system.events.ResourceEvent ):void
		{
			//trace( "Resource LOADED: " + event.resourceInfo.resourceId,  "System Memory: " + ( System.totalMemory / 1024 ) );
		}
		
		protected function _queeCompletedEventHandler( event:ResourceEvent ):void
		{
			__queeLoader.unload();
			__queeLoader = null;
			
			__cri.name = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "config" );
			__cri.icon = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "settingsIcon", this.session.skinsLocaleName );
			
			var rhc:ResourceHolderVo = new ResourceHolderVo();
				rhc.titleBarIcon = __cri.icon;
				rhc.title = __cri.name;
				rhc.hideOnClose = true;
				rhc.minimizable = true;
				rhc.resizable = true;
				
			__cri.resourceHolderConfig = rhc;
				
			__customers_resource_request = new LoadResourceRequestVo(
				"customersModule",
				this.config.RESOURCE_CONFIG.moduleBasePath + "CustomersModule.swf",
				ResourceTypes.MODULE, 
				resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "customers" )
			);
			
			__employees_resource_request = new LoadResourceRequestVo(
				"employeesModule",
				this.config.RESOURCE_CONFIG.moduleBasePath + "EmployeesModule.swf",
				ResourceTypes.MODULE, 
				resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "employees" )
			);
			
			__storage_resource_request = new LoadResourceRequestVo(
				"storageModule",
				this.config.RESOURCE_CONFIG.moduleBasePath + "StorageModule.swf",
				ResourceTypes.MODULE, 
				resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "storage" )
			);
			
			__users_resource_request = new LoadResourceRequestVo(	
				"usersModule",
				this.config.RESOURCE_CONFIG.moduleBasePath + "UsersModule.swf",
				ResourceTypes.MODULE, 
				resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "users" )
			);
			
			__storage_input_module_request = new LoadResourceRequestVo(	
				"storageInputModule",
				this.config.RESOURCE_CONFIG.moduleBasePath + "StorageInputModule.swf",
				ResourceTypes.MODULE, 
				resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "storageInput" )
			);
			
			__invoices_input_module_request = new LoadResourceRequestVo(	
				"invoicesModule",
				this.config.RESOURCE_CONFIG.moduleBasePath + "InvoicesModule.swf",
				ResourceTypes.MODULE, 
				resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "invoices" )
			);
			
			
			__customers_resource_request.icon = resourceManager.getClass( this.config.LOCALE_CONFIG.systemIconsResourceName, "customersModuleIcon", session.skinsLocaleName );
			__employees_resource_request.icon = resourceManager.getClass( this.config.LOCALE_CONFIG.systemIconsResourceName, "employeesModuleIcon", session.skinsLocaleName );
			__storage_resource_request.icon = resourceManager.getClass( this.config.LOCALE_CONFIG.systemIconsResourceName, "storageModuleIcon", session.skinsLocaleName );
			__users_resource_request.icon = resourceManager.getClass( this.config.LOCALE_CONFIG.systemIconsResourceName, "usersIcon", session.skinsLocaleName );
			__storage_input_module_request.icon = resourceManager.getClass( this.config.LOCALE_CONFIG.systemIconsResourceName, "itemsModuleIcon", session.skinsLocaleName );
			__invoices_input_module_request.icon = resourceManager.getClass( this.config.LOCALE_CONFIG.systemIconsResourceName, "invoiceIcon", session.skinsLocaleName );
			
			__desktop_model.readDefaultDesktopAppearance( this );
		}
		
		public function modelLoadingData( event:ModelDataChangeEvent ):void{}
		
		public function modelLoadingDataError( event:ModelDataChangeEvent ):void{}
		
		public function modelLoadingDataComplete( event:ModelDataChangeEvent ):void
		{
			__loadingContainer.loading = false;
			
			if( event.operationName == DesktopModel.DESKTOP_READ_DEFAULT_APPEARANCE_CONFIG_OPERATION )
			{ 
				__user_appearance = event.response.result  as DesktopAppearanceVo;		
				_startDesktop();
			}
		}
		
		
		protected function _startDesktop():void
		{
			DESKTOP_CMP = new DesktopComponent();
			DESKTOP_CMP.setStyle( "skinClass", resourceManager.getClass( this.config.LOCALE_CONFIG.skinsResourceName, "desktopComponent", session.skinsLocaleName ) );
			//DESKTOP_CMP.setStyle( "skinClass", DesktopSkin );
			
			
			
			DESKTOP_CMP.addEventListener( DesktopEvent.DESKTOP_INITIALISED, _desktopInitialisedEvent );
			DESKTOP_CMP.addEventListener( SystemEvent.SHOW_CONFIG, _systemShowConfigEventHandler );
			
			__resourceRequestController = new ResourceRequestController();
			__resourceRequestController.desktop = DESKTOP_CMP;
			
			DESKTOP_CMP.initDesktop();
			
			displayContainer.addElement( DESKTOP_CMP );
			__desktop_model.currentAppearance = __user_appearance;
		}
		
		protected function _desktopInitialisedEvent( event:DesktopEvent ):void
		{
			trace( "DESKTOP INITIALIZED." );
			
			var partneri_icon:ButtonVo = new ButtonVo(
				50, 350, 
				resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "customers" ),
				__customers_resource_request
			);
			
			
			var employees_icon:ButtonVo = new ButtonVo(
				200, 350, 
				resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "employees" ),
				__employees_resource_request
			);
			
			var storage_icon:ButtonVo = new ButtonVo(
				350, 350, 
				resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "storage" ),
				__storage_resource_request
			);
			
			var storage_input_icon:ButtonVo = new ButtonVo(
				500, 350, 
				resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "storageInput" ),
				__storage_input_module_request
			);
			
			
			var invoices_icon:ButtonVo = new ButtonVo(
				650, 350, 
				resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "invoices" ),
				__invoices_input_module_request
			);
			
			var users_icon:ButtonVo = new ButtonVo(
				800, 350, 
				resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "users" ),
				__users_resource_request
			);
			
			DESKTOP_CMP.addIcon( partneri_icon );
			DESKTOP_CMP.addIcon( employees_icon );
			DESKTOP_CMP.addIcon( storage_icon );
			DESKTOP_CMP.addIcon( storage_input_icon );
			DESKTOP_CMP.addIcon( invoices_icon );
			DESKTOP_CMP.addIcon( users_icon );
			
			( displayContainer as IEventDispatcher ).addEventListener( ResizeEvent.RESIZE, DESKTOP_CMP.onMainResize );
			
			
			DESKTOP_CMP.notify( new NotificationVo( 
				resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "welcome" ),
				resourceManager.getString( this.config.LOCALE_CONFIG.messagesResourceName, "welcomeMessage" ),
				resourceManager.getClass( this.config.LOCALE_CONFIG.systemIconsResourceName, "systemIcon", this.session.skinsLocaleName ),
				4000
			)); 
			
			var quee:ModelQueeLoader = new ModelQueeLoader();
			
			var r1:ModelLoaderQueeRequestVo = new ModelLoaderQueeRequestVo();
			r1.model = __desktop_model;
			r1.method = __desktop_model.readDefaultDesktopAppearance;
			r1.functionParams = [ this ];
			
			quee.addToQuee( r1 );
			
			var r2:ModelLoaderQueeRequestVo = new ModelLoaderQueeRequestVo();
			r2.model = __desktop_model;
			r2.method = __desktop_model.readDesktopAppearances;
			r2.functionParams = [ this ];
			
			quee.addToQuee( r2 );
			
			quee.loadQuee();
		}
		
		protected function _systemShowConfigEventHandler( event:SystemEvent ):void
		{
			if( __configModule  )
			{
				( __configModule as IModuleBase ).resourceHolder.toFront();
			}
			else
			{
				__resourceLoader.loadResource( __cri );
			}
			
		}
		
		public function updateResourceLoadStatus( resource:LoadResourceRequestVo ):void
		{
			var nvo:NotificationVo = new NotificationVo( 
				resourceManager.getString( this.config.LOCALE_CONFIG.dictonaryResourceName, "loading" ),
				__resourceRequestController.getResourceLoadingMessage( __cri ),
				resourceManager.getClass( this.config.LOCALE_CONFIG.systemIconsResourceName, "loadingIcon", this.session.skinsLocaleName ),
				0,
				__cri.resourceId							 
			);	
			
			
			DESKTOP_CMP.notify( nvo );
			
			if( resource.status.statusCode == ResourceLoadStatus.RESOURCE_LOAD_COMPLETED )
			{
				if( resource.resourceId == __cri.resourceId )
				{
					__configModule = resource.resource as IConfigModule;
					
					( __configModule as EventDispatcher ).addEventListener( ModuleEvent.MODULE_UNLOAD, __configModuleUnload );
					nvo.autoCloseTime = this.session.config.DESKTOP_CONFIG.notificationAutoCloseTime;
					
					DESKTOP_CMP.notify( nvo );
				}
			}
		}
		
		protected function __configModuleUnload( event:ModuleEvent ):void
		{
			__configModule = null;
		}
	}
}