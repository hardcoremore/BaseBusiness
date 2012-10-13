package modules
{
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.core.SystemModuleBase;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.events.ResourceEvent;
	import com.desktop.system.interfaces.ILoadResourceRequester;
	import com.desktop.system.interfaces.IModuleBase;
	import com.desktop.system.interfaces.IResourceHolder;
	import com.desktop.system.utility.CrudOperations;
	import com.desktop.system.utility.ResourceLoadStatus;
	import com.desktop.system.utility.ResourceTypes;
	import com.desktop.system.vos.LoadResourceRequestVo;
	import com.desktop.system.vos.ReadVo;
	import com.desktop.ui.Components.Button.DesktopControllButton;
	import com.desktop.ui.Components.Group.LoadingContainer;
	import com.desktop.ui.Components.Window.DesktopAlert;
	import com.desktop.ui.vos.ResourceHolderVo;
	
	import components.DataGridColumnSelector;
	import components.Paging;
	import components.app.SaveData;
	import components.events.PageEvent;
	import components.events.SaveDataEvent;
	
	import factories.ModelFactory;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import interfaces.modules.ICustomersModule;
	import interfaces.modules.sub.ICustomersConfigModule;
	import interfaces.modules.sub.ISaveCustomerModule;
	
	import models.CustomersModel;
	import models.SystemModel;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.collections.XMLListCollection;
	import mx.controls.Alert;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.modules.ModuleBase;
	
	import skins.Default.modules.CustomersModuleSkin;
	
	import spark.collections.SortField;
	import spark.components.Button;
	import spark.components.DataGrid;
	import spark.components.DataRenderer;
	import spark.components.Group;
	import spark.components.SkinnableContainer;
	import spark.components.ToggleButton;
	import spark.components.gridClasses.GridColumn;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.GridSelectionEvent;
	import spark.events.GridSortEvent;
	
	import vos.CustomersVo;
	import vos.DataHolderColumnVo;
	
	
	public class CustomersModule extends SystemModuleBase implements ICustomersModule, ILoadResourceRequester
	{
		
		[SkinPart(required="false")]
		public var newCustomerButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var updateCustomerButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var customersDataHolder:DataGrid;
		
		[SkinPart(required="true")]
		public var customersPaging:Paging;
		
		
		private var __saveCustomerModule:ISaveCustomerModule;
		private var __updateCustomerModule:ISaveCustomerModule;
		private var __customersConfigModule:ICustomersConfigModule;
		
		private var __customers_model:CustomersModel;
		
		private var __customersDataHolderColumns:IList;
		private var __customersDataGridColumnSelector:DataGridColumnSelector;
		
		public function CustomersModule()
		{
			super();
		}
		
		/**
		 * ===========================
		 * 
		 * 	OVERRIDEN METHODS
		 * ===========================
		 **/
		
		override public function init():void
		{
			super.init();
			
			__customers_model = ModelFactory.customersModel();
			__customers_model.addEventListener( ModelDataChangeEvent.MODEL_LOADING_DATA_COMPLETE, _modelLoadingDataCompleteEventHandler );
			setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "customersModule", this.session.skinsLocaleName ) );
		}
			
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == newCustomerButton )
			{
				newCustomerButton.addEventListener( MouseEvent.CLICK, _saveCustomerButtonClickHandler );
			}
			
			if( instance == updateCustomerButton )
			{
				updateCustomerButton.addEventListener( MouseEvent.CLICK, _saveCustomerButtonClickHandler );
			}
			
			if( instance == customersPaging )
			{
				customersPaging.addEventListener( PageEvent.PAGE_CHANGE, _customersPagingChangeEventHandler );				
			}
			
			if( instance == customersDataHolder )
			{
				customersDataHolder.addEventListener( GridSortEvent.SORT_CHANGING, _customerSortChangingEventHandler );
				customersDataHolder.addEventListener( GridSelectionEvent.SELECTION_CHANGE, _customersDataHolderSelectionChange );
				customersDataHolder.addEventListener( FlexEvent.VALUE_COMMIT, _customersDataHolderValueCommit );
				
				__customersDataHolderColumns = _createColumnVos( customersDataHolder.columns );
				
				_readCustomersColumns();
			}
		}
		
		override public function modelLoadingData(event:ModelDataChangeEvent):void
		{
			customersDataHolder.enabled = false;
		}
		
		override public function modelLoadingDataComplete(event:ModelDataChangeEvent):void
		{
			if( event.operationName == CustomersModel.CUSTOMERS_READ_OPERATION )
			{
				customersDataHolder.enabled = true;
				
				var sdc:SaveData;
				
				if( __updateCustomerModule )
					sdc = __updateCustomerModule.saveDataComponent;
				
				_updateReadData( event.response, customersDataHolder, customersPaging, sdc );
				
			}
			else if( event.operationName == SystemModel.SYSTEM_READ_DATA_HOLDER_COLUMNS_OPERATION )
			{
				var cols:IList = event.response.result as IList;
				
				customersDataHolder.columns = setupDataGridColumns( __customersDataHolderColumns, cols );
				__customersDataHolderColumns = cols;
			}
		}
		
		override public function get resourceHolderConfig():ResourceHolderVo
		{ 
			var rh:ResourceHolderVo = new ResourceHolderVo();
			rh.title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "customers" );
			rh.width = 1200;
			rh.height = 800;
			rh.maximizable = true;
			rh.resizable = true;
			rh.minimizable = true;
			rh.maximized = true;
			rh.titleBarIcon = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "customersModuleIcon", this.session.skinsLocaleName );
			
			return rh;
		}
		
		override public function unload():void
		{
			/***
			 var e:ResourceEvent = new ResourceEvent( ResourceEvent.RESOURCE_REQUEST_UNLOAD );
			 e.resourceInfo = __updateAssociatesLRRVO;
			 
			 dispatchEvent( e );
			 
			 __updateAssociatesLRRVO = null;
			 __updateAssociates = null;
			 
			 **/
			super.unload();
		}
		
		
		
		/**
		 * ===========================
		 * 
		 * 	EVENTS
		 * ===========================
		 **/
		
		protected function _modelLoadingDataCompleteEventHandler( event:ModelDataChangeEvent ):void
		{
			if( event.operationName == CustomersModel.CUSTOMERS_UPDATE_OPERATION )
			{				
				if( __updateCustomerModule )
					customersDataHolder.dataProvider.itemUpdated( __updateCustomerModule.data as CustomersVo );
			}
		}
		
		protected function _customerSortChangingEventHandler( event:GridSortEvent ):void
		{
			event.preventDefault();
		}
		
		protected function _customersDataHolderSelectionChange( event:GridSelectionEvent ):void
		{
			var selectedCustomer:CustomersVo = customersDataHolder.selectedItem as CustomersVo;
			
			if( selectedCustomer )
			{
				if( __updateCustomerModule )
				{
					__updateCustomerModule.data = customersDataHolder.selectedItem;
				}
				
				if( __updateCustomerModule && __updateCustomerModule.saveDataComponent )
				{
					__updateCustomerModule.saveDataComponent.previewDataIndex = customersDataHolder.selectedIndex;
				}
			}
		}
		
		protected function _customersDataHolderValueCommit( event:FlexEvent ):void
		{
			var selectedCustomer:CustomersVo = customersDataHolder.selectedItem as CustomersVo;
			
			if( selectedCustomer && __updateCustomerModule )
			{
				__updateCustomerModule.data = selectedCustomer;
			}
		}
		
		protected function _saveCustomerButtonClickHandler( event:MouseEvent ):void
		{
			var title:String;
			var icon:Class;
			
			if( event.currentTarget == newCustomerButton )
			{
				if( __saveCustomerModule )
				{
					if( __saveCustomerModule.resourceHolder )
						__saveCustomerModule.resourceHolder.toFront();
					
					return;
				}
				else
				{
					title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "newCustomer" );
					icon = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "addIcon", this.session.skinsLocaleName );
					newCustomerButton.enabled = false;
				}
			}
			else if( event.currentTarget == updateCustomerButton )
			{
				if( __updateCustomerModule )
				{
					if( __updateCustomerModule.resourceHolder )
						__updateCustomerModule.resourceHolder.toFront();
					
					return;
				}
				else
				{
					title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "updateCustomer" );
					icon = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "updateIcon", this.session.skinsLocaleName );
					updateCustomerButton.enabled = false;
				}
			}
			
			var lvo:LoadResourceRequestVo = new LoadResourceRequestVo(
				event.currentTarget.id,
				this.session.config.RESOURCE_CONFIG.moduleBasePath + "sub/" + "SaveCustomerModule.swf",
				ResourceTypes.MODULE, 
				title, 
				icon
			);
			
			lvo.createResourceHolderAutomatically = true;
			lvo.requester = this;
			lvo.getNew = true;
			
			var rhc:ResourceHolderVo = new ResourceHolderVo();
			rhc.child = true;
			rhc.parent = this.resourceHolder;
			rhc.cObject = event.currentTarget as IVisualElement;
			rhc.hideOnClose = true;
			rhc.title = title;
			rhc.titleBarIcon = icon;
			rhc.resizable = true;
			
			lvo.resourceHolderConfig = rhc;
			
			var e:ResourceEvent = new ResourceEvent( ResourceEvent.RESOURCE_LOAD_REQUEST, true );
				e.resourceInfo = lvo;
			
			dispatchEvent( e );
		}
		
		protected function _previewIndexChange( event:SaveDataEvent ):void
		{
			if( customersDataHolder )
				( customersDataHolder as  DataGrid ).selectedIndex = event.previewDataIndex;
		}
		
		protected function _saveDataComponentPreviewIndexChangeEventHandler( event:SaveDataEvent ):void
		{
			if( customersDataHolder )
			{
				customersDataHolder.selectedIndex = event.previewDataIndex;
			}
		}
		
		protected function _customersPagingChangeEventHandler( event:PageEvent ):void
		{
			_readCustomers();
		}
		
		override protected function _creationComplete( event:FlexEvent ):void
		{		
			super._creationComplete( event );
			_setupOrder( customersDataHolder, customersPaging );
			_readCustomers();
		}
		
		override protected function _configButtonClickEventHandler(event:MouseEvent):void
		{
			if( ! __customersConfigModule )
			{
				configButton.enabled = false;
				
				var lvo:LoadResourceRequestVo = new LoadResourceRequestVo(
					event.currentTarget.id,
					this.session.config.RESOURCE_CONFIG.moduleBasePath + "sub/" + "CustomersConfigModule.swf",
					ResourceTypes.MODULE
				);
				
				var rhc:ResourceHolderVo = BaseModel.createConfigResourceHolderVo( resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "customers" ) );
					rhc.parent = resourceHolder;
					rhc.maximizable = false;
				
				lvo.createResourceHolderAutomatically = true;
				lvo.requester = this;
				lvo.getNew = true;
				
				lvo.resourceHolderConfig = rhc;
				
				var e:ResourceEvent = new ResourceEvent( ResourceEvent.RESOURCE_LOAD_REQUEST, true );
					e.resourceInfo = lvo;
				
				dispatchEvent( e );
			}
			else
			{
				_configResourceHolder.toFront();
			}
		}
		
		/**
		 * ===========================
		 * 
		 * 	PUBLIC METHODS
		 * ===========================
		 **/
		public function updateResourceLoadStatus( resource:LoadResourceRequestVo ):void
		{
			if( resource.status.statusCode == ResourceLoadStatus.RESOURCE_LOAD_COMPLETED )
			{
				var mi:IModuleBase = resource.resource as IModuleBase;
					
				if( resource.resourceId == newCustomerButton.id )
				{	
					__saveCustomerModule = ISaveCustomerModule( resource.resource );
					__saveCustomerModule.resourceHolderConfig.parent = this.resourceHolder;
					
					__saveCustomerModule.mode = CrudOperations.CREATE;
					
					newCustomerButton.enabled = true;
					
					__saveCustomerModule.saveDataComponent.addEventListener( SaveDataEvent.PREVIEW_DATA_INDEX_CHANGE, _saveDataComponentPreviewIndexChangeEventHandler );
				}
				else if( resource.resourceId == updateCustomerButton.id )
				{
					__updateCustomerModule = ISaveCustomerModule( resource.resource );
					__updateCustomerModule.resourceHolderConfig.parent = this.resourceHolder;
					
					__updateCustomerModule.mode = CrudOperations.UPDATE;
					
					updateCustomerButton.enabled = true;
					
					var si:Object = customersDataHolder.selectedItem;
					
					if( si ) 
						__updateCustomerModule.data = si;
	
					__updateCustomerModule.saveDataComponent.addEventListener( SaveDataEvent.PREVIEW_DATA_INDEX_CHANGE, _previewIndexChange ); 
						
					if( currentReadData )
					{
						__updateCustomerModule.saveDataComponent.previewDataLength = currentReadData.numRows;
						
						if( customersDataHolder )
							__updateCustomerModule.saveDataComponent.previewDataIndex = customersDataHolder.selectedIndex;
					}
				}
				else if( resource.resourceId == configButton.id )
				{
					__customersConfigModule = ICustomersConfigModule( resource.resource );
					__customersConfigModule.data = __customersDataHolderColumns;
					_configResourceHolder = __customersConfigModule.resourceHolder;
					configButton.enabled = true;
					
				}
			}
			
		}
		
		
		/**
		 * ===========================
		 * 
		 * 	PROTECTED METHODS
		 * ===========================
		 **/

		protected function _readCustomers():void
		{
			var r:ReadVo = new ReadVo();
				r.numRows = customersPaging.rowsPerPage;
				r.pageNum = customersPaging.pageNumber;
				r.sortColumnName = customersPaging.sortColumnName || customersPaging.orderColumnsList.selectedItem.value;
				r.sortColumnDirection = customersPaging.sortColumnDirection;
				
			__customers_model.read( r, this ); 
		}
		
		protected function _readCustomersColumns():void
		{
			systemModel.readDataHolderColumns( CustomersModel.CUSTOMERS_DATA_HOLDER_ID, this.session.user.user_id, this ); 
		}
	}
}