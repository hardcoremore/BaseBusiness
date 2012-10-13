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
	
	import interfaces.modules.IUsersModule;
	import interfaces.modules.sub.ISaveUserModule;
	
	import models.CustomersModel;
	import models.SystemModel;
	import models.UsersModel;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.collections.XMLListCollection;
	import mx.controls.Alert;
	import mx.core.IVisualElement;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.modules.ModuleBase;
	
	import skins.Default.modules.CustomersModuleSkin;
	import skins.Default.modules.UsersModuleSkin;
	
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
	
	import vos.DataHolderColumnVo;
	import vos.UserVo;
	
	
	public class UsersModule extends SystemModuleBase implements IUsersModule, ILoadResourceRequester
	{
		
		[SkinPart(required="false")]
		public var newUserButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var updateUserButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var usersDataHolder:DataGrid;
		
		[SkinPart(required="true")]
		public var usersPaging:Paging;
		
		
		private var __saveUserModule:ISaveUserModule
		private var __updateUserModule:ISaveUserModule;
		//private var __customersConfigModule:ICustomersConfigModule;
		
		private var __users_model:UsersModel;
		
		private var __usersDataHolderColumns:IList;
		private var __customersDataGridColumnSelector:DataGridColumnSelector;
		
		public function UsersModule()
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
			
			__users_model = ModelFactory.usersModel();
			__users_model.addEventListener( ModelDataChangeEvent.MODEL_LOADING_DATA_COMPLETE, _modelLoadingDataCompleteEventHandler );
			
			//setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "customersModule", this.session.skinsLocaleName ) );
			setStyle( "skinClass", UsersModuleSkin );
		}
			
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == newUserButton )
			{
				newUserButton.addEventListener( MouseEvent.CLICK, _saveUserButtonClickHandler );
			}
			
			if( instance == updateUserButton )
			{
				updateUserButton.addEventListener( MouseEvent.CLICK, _saveUserButtonClickHandler );
			}
			
			if( instance == usersPaging )
			{
				usersPaging.addEventListener( PageEvent.PAGE_CHANGE, _customersPagingChangeEventHandler );				
			}
			
			if( instance == usersDataHolder )
			{
				usersDataHolder.addEventListener( GridSortEvent.SORT_CHANGING, _customerSortChangingEventHandler );
				usersDataHolder.addEventListener( GridSelectionEvent.SELECTION_CHANGE, _customersDataHolderSelectionChange );
				usersDataHolder.addEventListener( FlexEvent.VALUE_COMMIT, _customersDataHolderValueCommit );
				
				__usersDataHolderColumns = _createColumnVos( usersDataHolder.columns );
				
				_readUsersColumns();
			}
		}
		
		override public function modelLoadingData(event:ModelDataChangeEvent):void
		{
			usersDataHolder.enabled = false;
		}
		
		override public function modelLoadingDataComplete(event:ModelDataChangeEvent):void
		{
			if( event.operationName == CustomersModel.CUSTOMERS_READ_OPERATION )
			{
				usersDataHolder.enabled = true;
				
				var sdc:SaveData;
				
				if( __updateUserModule )
					sdc = __updateUserModule.saveDataComponent;
				
				_updateReadData( event.response, usersDataHolder, usersPaging, sdc );
				
			}
			else if( event.operationName == SystemModel.SYSTEM_READ_DATA_HOLDER_COLUMNS_OPERATION )
			{
				var cols:IList = event.response.result as IList;
				
				usersDataHolder.columns = setupDataGridColumns( __usersDataHolderColumns, cols );
				__usersDataHolderColumns = cols;
			}
		}
		
		override public function get resourceHolderConfig():ResourceHolderVo
		{ 
			var rh:ResourceHolderVo = new ResourceHolderVo();
				rh.title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "users" );
				rh.width = 1200;
				rh.height = 800;
				rh.maximizable = true;
				rh.resizable = true;
				rh.minimizable = true;
				rh.maximized = true;
				rh.titleBarIcon = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "usersIcon", this.session.skinsLocaleName );
			
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
				if( __updateUserModule )
					usersDataHolder.dataProvider.itemUpdated( __updateUserModule.data as UserVo );
			}
		}
		
		protected function _customerSortChangingEventHandler( event:GridSortEvent ):void
		{
			event.preventDefault();
		}
		
		protected function _customersDataHolderSelectionChange( event:GridSelectionEvent ):void
		{
			var selectedUser:UserVo = usersDataHolder.selectedItem as UserVo;
			
			if( selectedUser )
			{
				if( __updateUserModule )
				{
					__updateUserModule.data = usersDataHolder.selectedItem;
				}
				
				if( __updateUserModule && __updateUserModule.saveDataComponent )
				{
					__updateUserModule.saveDataComponent.previewDataIndex = usersDataHolder.selectedIndex;
				}
			}
		}
		
		protected function _customersDataHolderValueCommit( event:FlexEvent ):void
		{
			var selectedCustomer:UserVo = usersDataHolder.selectedItem as UserVo;
			
			if( selectedCustomer && __updateUserModule )
			{
				__updateUserModule.data = selectedCustomer;
			}
		}
		
		protected function _saveUserButtonClickHandler( event:MouseEvent ):void
		{
			var title:String;
			var icon:Class;
			
			if( event.currentTarget == newUserButton )
			{
				if( __saveUserModule )
				{
					if( __saveUserModule.resourceHolder )
						__saveUserModule.resourceHolder.toFront();
					
					return;
				}
				else
				{
					title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "newUser" );
					icon = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "addIcon", this.session.skinsLocaleName );
					newUserButton.enabled = false;
				}
			}
			else if( event.currentTarget == updateUserButton )
			{
				if( __updateUserModule )
				{
					if( __updateUserModule.resourceHolder )
						__updateUserModule.resourceHolder.toFront();
					
					return;
				}
				else
				{
					title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "updateUser" );
					icon = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "updateIcon", this.session.skinsLocaleName );
					updateUserButton.enabled = false;
				}
			}
			
			var lvo:LoadResourceRequestVo = new LoadResourceRequestVo(
				event.currentTarget.id,
				this.session.config.RESOURCE_CONFIG.moduleBasePath + "sub/" + "SaveUserModule.swf",
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
			if( usersDataHolder )
				usersDataHolder.selectedIndex = event.previewDataIndex;
		}
		
		protected function _saveDataComponentPreviewIndexChangeEventHandler( event:SaveDataEvent ):void
		{
			if( usersDataHolder )
			{
				usersDataHolder.selectedIndex = event.previewDataIndex;
			}
		}
		
		protected function _customersPagingChangeEventHandler( event:PageEvent ):void
		{
			_readUsers();
		}
		
		override protected function _creationComplete( event:FlexEvent ):void
		{		
			super._creationComplete( event );
			_setupOrder( usersDataHolder, usersPaging );
			_readUsers();
		}
		
		override protected function _configButtonClickEventHandler(event:MouseEvent):void
		{
//			if( ! __customersConfigModule )
//			{
//				configButton.enabled = false;
//				
//				var lvo:LoadResourceRequestVo = new LoadResourceRequestVo(
//					event.currentTarget.id,
//					this.session.config.RESOURCE_CONFIG.moduleBasePath + "sub/" + "CustomersConfigModule.swf",
//					ResourceTypes.MODULE
//				);
//				
//				var rhc:ResourceHolderVo = BaseModel.createConfigResourceHolderVo( resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "customers" ) );
//					rhc.parent = resourceHolder;
//					rhc.maximizable = false;
//				
//				lvo.createResourceHolderAutomatically = true;
//				lvo.requester = this;
//				lvo.getNew = true;
//				
//				lvo.resourceHolderConfig = rhc;
//				
//				var e:ResourceEvent = new ResourceEvent( ResourceEvent.RESOURCE_LOAD_REQUEST, true );
//					e.resourceInfo = lvo;
//				
//				dispatchEvent( e );
//			}
//			else
//			{
//				_configResourceHolder.toFront();
//			}
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
					
				if( resource.resourceId == newUserButton.id )
				{	
					__saveUserModule = ISaveUserModule( resource.resource );
					__saveUserModule.resourceHolderConfig.parent = this.resourceHolder;
					
					__saveUserModule.mode = CrudOperations.CREATE;
					
					newUserButton.enabled = true;
					
					__saveUserModule.saveDataComponent.addEventListener( SaveDataEvent.PREVIEW_DATA_INDEX_CHANGE, _saveDataComponentPreviewIndexChangeEventHandler );
				}
				else if( resource.resourceId == updateUserButton.id )
				{
					__updateUserModule = ISaveUserModule( resource.resource );
					__updateUserModule.resourceHolderConfig.parent = this.resourceHolder;
					
					__updateUserModule.mode = CrudOperations.UPDATE;
					
					updateUserButton.enabled = true;
					
					var si:Object = usersDataHolder.selectedItem;
					
					if( si ) 
						__updateUserModule.data = si;
	
					__updateUserModule.saveDataComponent.addEventListener( SaveDataEvent.PREVIEW_DATA_INDEX_CHANGE, _previewIndexChange ); 
						
					if( currentReadData )
					{
						__updateUserModule.saveDataComponent.previewDataLength = currentReadData.numRows;
						
						if( usersDataHolder )
							__updateUserModule.saveDataComponent.previewDataIndex = usersDataHolder.selectedIndex;
					}
				}
				else if( resource.resourceId == configButton.id )
				{
//					__customersConfigModule = ICustomersConfigModule( resource.resource );
//					__customersConfigModule.data = __usersDataHolderColumns;
//					_configResourceHolder = __customersConfigModule.resourceHolder;
//					configButton.enabled = true;
//					
				}
			}
			
		}
		
		
		/**
		 * ===========================
		 * 
		 * 	PROTECTED METHODS
		 * ===========================
		 **/

		protected function _readUsers():void
		{
			var r:ReadVo = new ReadVo();
				r.numRows = usersPaging.rowsPerPage;
				r.pageNum = usersPaging.pageNumber;
				r.sortColumnName = usersPaging.sortColumnName || usersPaging.orderColumnsList.selectedItem.value;
				r.sortColumnDirection = usersPaging.sortColumnDirection;
				
			__users_model.read( r, this ); 
		}
		
		protected function _readUsersColumns():void
		{
			//systemModel.readDataHolderColumns( CustomersModel.CUSTOMERS_DATA_HOLDER_ID, this.session.user.user_id, this ); 
		}
	}
}