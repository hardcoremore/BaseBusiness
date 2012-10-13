package modules
{
	import com.desktop.system.Application.Library.ui.FormHelper;
	import com.desktop.system.core.SystemModuleBase;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.events.ResourceEvent;
	import com.desktop.system.interfaces.ILoadResourceRequester;
	import com.desktop.system.interfaces.IModuleBase;
	import com.desktop.system.utility.CrudOperations;
	import com.desktop.system.utility.ResourceLoadStatus;
	import com.desktop.system.utility.ResourceTypes;
	import com.desktop.system.vos.LoadResourceRequestVo;
	import com.desktop.system.vos.ReadVo;
	import com.desktop.ui.Components.Button.DesktopControllButton;
	import com.desktop.ui.vos.ResourceHolderVo;
	
	import components.Paging;
	import components.app.SaveData;
	import components.events.PageEvent;
	import components.events.SaveDataEvent;
	
	import factories.ModelFactory;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import interfaces.modules.IStorageModule;
	import interfaces.modules.sub.ISaveItemModule;
	import interfaces.modules.sub.IStorageInputModule;
	import interfaces.modules.sub.IStorageItemCategoriesModule;
	import interfaces.modules.sub.IStoragesModule;
	
	import models.StorageModel;
	
	import mx.collections.IList;
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	
	import skins.Default.modules.StorageModuleSkin;
	
	import spark.components.ComboBox;
	import spark.components.DataGrid;
	import spark.events.GridSelectionEvent;
	import spark.events.GridSortEvent;
	
	import vos.EmployeesVo;
	import vos.StorageItemVo;
	import vos.StorageVo;
	
	public class StorageModule extends SystemModuleBase implements IStorageModule, ILoadResourceRequester
	{
		
		[SkinPart(required="true")]
		public var newItemButton:DesktopControllButton;
		
		[SkinPart(required="true")]
		public var updateItemButton:DesktopControllButton;
		
		[SkinPart(required="true")]
		public var itemsCategoriesButton:DesktopControllButton;
		
		[SkinPart(required="true")]
		public var storagesModuleButton:DesktopControllButton;
		
		[SkinPart(required="true")]
		public var itemsDataHolder:DataGrid;
		
		[SkinPart(required="true")]
		public var storagesList:ComboBox;
		
		[SkinPart(required="true")]
		public var storageContentsDataHolder:DataGrid;
		
		[SkinPart(required="true")]
		public var itemsPaging:Paging;
		
		[SkinPart(required="true")]
		public var storageContentsPaging:Paging;
		
		private var __saveStorageItemModule:ISaveItemModule;
		private var __updateStorageItemModule:ISaveItemModule;
		private var __storageItemCategoriesModule:IStorageItemCategoriesModule;
		private var __storagesModule:IStoragesModule;
		
		private var __storage_model:StorageModel;
		
		private var __itemsColumns:IList;
		private var __storageItemsColumns:IList;
		
		
		
		private var __selected_item:StorageItemVo;
		
		public function StorageModule()
		{
			super();
		}
		
		override public function init():void
		{
			super.init();
			
			__storage_model = ModelFactory.storageModel();
			
			__storage_model.addEventListener( ModelDataChangeEvent.MODEL_LOADING_DATA, _modelLoadingDataEventHandler );
			__storage_model.addEventListener( ModelDataChangeEvent.MODEL_LOADING_DATA_COMPLETE, _modelLoadingDataCompleteEventHandler );
			//setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "storageModule", this.session.skinsLocaleName ) );
			setStyle( "skinClass", StorageModuleSkin );
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == newItemButton )
			{
				newItemButton.addEventListener( MouseEvent.CLICK, _saveStorageItemButtonClickHandler );
			}
			else if( instance == updateItemButton )
			{
				updateItemButton.addEventListener( MouseEvent.CLICK, _saveStorageItemButtonClickHandler );
			}
			else if( instance == itemsCategoriesButton )
			{
				itemsCategoriesButton.addEventListener( MouseEvent.CLICK, _itemsCategoriesButtonClickHandler );
			}
			else if( instance == itemsDataHolder )
			{
				itemsDataHolder.addEventListener( GridSortEvent.SORT_CHANGING, _storageItemsDataHolderSortingChange );
				itemsDataHolder.addEventListener( GridSelectionEvent.SELECTION_CHANGE, _storageItemsDataHolderSelectionChange );
				itemsDataHolder.addEventListener( FlexEvent.VALUE_COMMIT, _storageItemsDataHolderSelectionChange );
		
				__itemsColumns = _createColumnVos( itemsDataHolder.columns );
			
			}
			else if( instance == storagesList )
			{
				storagesList.labelField = "storage_name";
			}
			else if( instance == storagesModuleButton )
			{
				storagesModuleButton.addEventListener( MouseEvent.CLICK, _storagesModuleButtonClickHAndler );
			}
			else if( instance == storageContentsDataHolder )
			{
				__storageItemsColumns = _createColumnVos( storageContentsDataHolder.columns );	
			}
			else if( instance == itemsPaging )
			{
				itemsPaging.addEventListener( PageEvent.PAGE_CHANGE, _itemsPagingChangeEventHandler );
			}
		}
		
		protected function _storageItemsDataHolderSortingChange( event:GridSortEvent ):void
		{
			event.preventDefault();
		}
		
		protected function _storageItemsDataHolderSelectionChange( event:Event ):void
		{
			__selected_item = itemsDataHolder.selectedItem as StorageItemVo;
			
			if( __updateStorageItemModule )
				__updateStorageItemModule.data = __selected_item;
		}
		
		protected function _saveStorageItemButtonClickHandler( event:MouseEvent ):void
		{
			var title:String;
			var icon:Class;
			
			if( event.currentTarget == newItemButton )
			{
				if( __saveStorageItemModule )
				{
					if( __saveStorageItemModule.resourceHolder )
						__saveStorageItemModule.resourceHolder.toFront();
					
					return;
				}
				else
				{
					title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "newItem" );
					icon = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "addIcon", this.session.skinsLocaleName );
					newItemButton.enabled = false;
				}
			}
			else if( event.currentTarget == updateItemButton )
			{
				if( __updateStorageItemModule )
				{
					if( __updateStorageItemModule.resourceHolder )
						__updateStorageItemModule.resourceHolder.toFront();
					
					return;
				}
				else
				{
					title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "updateItem" );
					icon = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "updateIcon", this.session.skinsLocaleName );
					updateItemButton.enabled = false;
				}
			}
			
			var lvo:LoadResourceRequestVo = new LoadResourceRequestVo(
				event.currentTarget.id,
				this.session.config.RESOURCE_CONFIG.moduleBasePath + "sub/" + "SaveItemModule.swf",
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
		
		protected function _itemsCategoriesButtonClickHandler( event:MouseEvent ):void
		{
			if( __storageItemCategoriesModule )
			{
				__storageItemCategoriesModule.resourceHolder.toFront();
				return;	
			}
			
			var title:String = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "itemCategories" );
			var icon:Class = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "reportIcon", this.session.skinsLocaleName );
			
			itemsCategoriesButton.enabled = false;
			
			var lvo:LoadResourceRequestVo = new LoadResourceRequestVo(
				event.currentTarget.id,
				this.session.config.RESOURCE_CONFIG.moduleBasePath + "sub/" + "StorageItemCategoriesModule.swf",
				ResourceTypes.MODULE, 
				title, 
				icon
			);
			
			lvo.createResourceHolderAutomatically = true;
			lvo.requester = this;
			lvo.getNew = true;
			
			var rhc:ResourceHolderVo = new ResourceHolderVo();
			rhc.hideOnClose = true;
			rhc.title = title;	
			rhc.titleBarIcon = icon;
			rhc.resizable = true;
			rhc.minimizable = true;
			rhc.maximizable = true;
			
			lvo.resourceHolderConfig = rhc;
			
			var e:ResourceEvent = new ResourceEvent( ResourceEvent.RESOURCE_LOAD_REQUEST, true );
			e.resourceInfo = lvo;
			
			dispatchEvent( e );
		}
		
		protected function _storagesModuleButtonClickHAndler( event:MouseEvent ):void
		{
			if( __storagesModule )
			{
				__storagesModule.resourceHolder.toFront();
				return;	
			}
			
			var title:String = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "itemStorages" );
			var icon:Class = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "addressIcon", this.session.skinsLocaleName );
			
			storagesModuleButton.enabled = false;
			
			var lvo:LoadResourceRequestVo = new LoadResourceRequestVo(
				event.currentTarget.id,
				this.session.config.RESOURCE_CONFIG.moduleBasePath + "sub/" + "StoragesModule.swf",
				ResourceTypes.MODULE, 
				title, 
				icon
			);
			
			lvo.createResourceHolderAutomatically = true;
			lvo.requester = this;
			lvo.getNew = true;
			
			var rhc:ResourceHolderVo = new ResourceHolderVo();
				rhc.hideOnClose = true;
				rhc.title = title;	
				rhc.titleBarIcon = icon;
				rhc.resizable = true;
				rhc.minimizable = true;
				rhc.maximizable = true;
			
			lvo.resourceHolderConfig = rhc;
			
			var e:ResourceEvent = new ResourceEvent( ResourceEvent.RESOURCE_LOAD_REQUEST, true );
				e.resourceInfo = lvo;
			
			dispatchEvent( e );
		}
		
		public function updateResourceLoadStatus( resource:LoadResourceRequestVo ):void
		{
			if( resource.status.statusCode == ResourceLoadStatus.RESOURCE_LOAD_COMPLETED )
			{
				var mi:IModuleBase = resource.resource as IModuleBase;
				
				if( resource.resourceId == newItemButton.id )
				{	
					__saveStorageItemModule = ISaveItemModule( resource.resource );
					__saveStorageItemModule.resourceHolderConfig.parent = this.resourceHolder;
					
					__saveStorageItemModule.mode = CrudOperations.CREATE;
					
					newItemButton.enabled = true;
				}
				else if( resource.resourceId == updateItemButton.id )
				{
					__updateStorageItemModule = ISaveItemModule( resource.resource );
					__updateStorageItemModule.resourceHolderConfig.parent = this.resourceHolder;
					
					__updateStorageItemModule.mode = CrudOperations.UPDATE;
					
					updateItemButton.enabled = true;
					
					var si:Object = ( itemsDataHolder as DataGrid ).selectedItem;
					
					if( si ) 
						__updateStorageItemModule.data = si;
					
					__updateStorageItemModule.saveDataComponent.addEventListener( SaveDataEvent.PREVIEW_DATA_INDEX_CHANGE, _previewIndexChange );
					
					if( currentReadData )
					{
						__updateStorageItemModule.saveDataComponent.previewDataLength = currentReadData.numRows;
						
						if( itemsDataHolder )
							__updateStorageItemModule.saveDataComponent.previewDataIndex = ( itemsDataHolder as DataGrid ).selectedIndex;
					}
					
				}
				else if( resource.resourceId == storagesModuleButton.id )
				{
					__storagesModule = IStoragesModule( resource.resource );
					__storagesModule.resourceHolderConfig.parent = this.resourceHolder;
					
					storagesModuleButton.enabled = true;
				}
				else if( resource.resourceId == itemsCategoriesButton.id )
				{
					__storageItemCategoriesModule = IStorageItemCategoriesModule( resource.resource );
					__storageItemCategoriesModule.resourceHolderConfig.parent = this.resourceHolder;
					
					itemsCategoriesButton.enabled = true;
				}
			}
		}

		override public function modelLoadingData( event:ModelDataChangeEvent ):void
		{
			super.modelLoadingData( event );
			
			if( event.operationName == StorageModel.STORAGE_READ_STORAGES_SELECT_OPERATION )
			{
				setLoadingComboBox( storagesList );
			}
		}
		
		override public function modelLoadingDataComplete( event:ModelDataChangeEvent ):void
		{
			super.modelLoadingDataComplete( event );
			
			if( event.operationName == StorageModel.STORAGE_READ_ITEMS_OPERATION )
			{
				itemsDataHolder.enabled = true;
				
				var sdc:SaveData;
				
				if( __updateStorageItemModule )
					sdc = __updateStorageItemModule.saveDataComponent;
				
				_updateReadData( event.response, itemsDataHolder, itemsPaging, sdc );
				
				__selected_item = null;
			}
			else if( event.operationName == StorageModel.STORAGE_READ_STORAGES_SELECT_OPERATION )
			{
				_updateReadData( event.response, storagesList );
				
				if( data && data is StorageItemVo )
				{
					FormHelper.setComboBoxSelectedValue( storagesList, "storage_id", ( data as StorageVo ).storage_id );
				}
			}
		}
		
		protected function _previewIndexChange( event:SaveDataEvent ):void
		{
			if( itemsDataHolder )
				itemsDataHolder.selectedIndex = event.previewDataIndex;
		}
		
		protected function _modelLoadingDataEventHandler( event:ModelDataChangeEvent ):void
		{
			if( event.operationName == StorageModel.STORAGE_READ_STORAGES_SELECT_OPERATION )
			{
				setLoadingComboBox( storagesList );
			}
		}
			
		protected function _modelLoadingDataCompleteEventHandler( event:ModelDataChangeEvent ):void
		{
			if( event.operationName == StorageModel.STORAGE_UPDATE_ITEM_OPERATION )
			{				
				if( __updateStorageItemModule )
					itemsDataHolder.dataProvider.itemUpdated( __updateStorageItemModule.data as StorageItemVo );
			}
			else if( event.operationName == StorageModel.STORAGE_READ_STORAGES_SELECT_OPERATION && event.requester != this )
			{
				_updateReadData( event.response, storagesList );
				
				if( data && data is StorageItemVo )
				{
					FormHelper.setComboBoxSelectedValue( storagesList, "storage_id", ( data as StorageVo ).storage_id );
				}
			}
		}
		
		override protected function _creationComplete( event:FlexEvent ):void
		{		
			super._creationComplete( event );
			
			_setupOrder( itemsDataHolder, itemsPaging );
			_setupOrder( storageContentsDataHolder, storageContentsPaging );
			
			_readItems();
			__storage_model.readStoragesForSelect( this );
		}
		
		protected function _itemsPagingChangeEventHandler( event:PageEvent ):void
		{
			_readItems();
		}
		
		protected function _readItems():void
		{
			var r:ReadVo = new ReadVo();
				r.numRows = itemsPaging.rowsPerPage;
				r.pageNum = itemsPaging.pageNumber;
			
			if( itemsPaging.sortColumnName || itemsPaging.orderColumnsList.selectedItem )
				r.sortColumnName = itemsPaging.sortColumnName || itemsPaging.orderColumnsList.selectedItem.value;
			
			r.sortColumnDirection = itemsPaging.sortColumnDirection;
			
			__storage_model.readItems( r, this ); 	 
		}
			
	}
}