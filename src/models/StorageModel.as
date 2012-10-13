package models
{
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.core.service.ServiceLoader;
	import com.desktop.system.core.service.events.ServiceEvent;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.interfaces.IServiceReqester;
	import com.desktop.system.utility.CrudOperations;
	import com.desktop.system.utility.SystemUtility;
	import com.desktop.system.vos.ModelOperationResponseVo;
	import com.desktop.system.vos.ReadVo;
	import com.desktop.system.vos.ResourceConfigVo;
	import com.desktop.system.vos.UpdateTableFieldVo;
	import com.desktop.system.vos.WebServiceRequestVo;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLVariables;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.utils.object_proxy;
	
	import spark.components.gridClasses.GridColumn;
	
	import vos.StorageItemCategoryVo;
	import vos.StorageItemVo;
	import vos.StorageVo;
	
	public class StorageModel extends BaseModel
	{
		// employees
		public static const STORAGE_CREATE_ITEM_OPERATION:String = "createItem";
		public static const STORAGE_READ_ITEMS_OPERATION:String = "readItems";
		public static const STORAGE_UPDATE_ITEM_OPERATION:String = "updateItem";
		
		
		// categories
		public static const STORAGE_CREATE_ITEM_CATEGORY_OPERATION:String = "createItemCategory";
		public static const STORAGE_READ_ITEM_CATEGORIES_OPERATION:String = "readItemCategories";
		public static const STORAGE_UPDATE_ITEM_CATEGORY_OPERATION:String = "updateItemCategory";
		public static const STORAGE_UPDATE_ITEM_CATEGORY__FIELD_OPERATION:String = "updateItemCategoryField";
		public static const STORAGE_READ_CATEGORIES_SELECT_OPERATION:String = "readItemCategoriesForSelect";
		
		// storages
		public static const STORAGE_CREATE_STORAGE_OPERATION:String = "createStorage";
		public static const STORAGE_READ_STORAGES_OPERATION:String = "readStorages";
		public static const STORAGE_UPDATE_STORAGE_OPERATION:String = "updateStorage";
		public static const STORAGE_UPDATE_STORAGE__FIELD_OPERATION:String = "updateStorageField";
		public static const STORAGE_READ_STORAGES_SELECT_OPERATION:String = "readStoragesForSelect";
		
		
		public static const STORAGE_TYPE_CENTRAL:uint = 1;
		public static const STORAGE_TYPE_INNER_BUSINESS:uint = 2;
		public static const STORAGE_TYPE_STORAGE_BUSINESS:uint = 3;
		public static const STORAGE_TYPE_STORAGE_INNER_PERSONAL:uint = 4;
		public static const STORAGE_TYPE_STORAGE_PERSONAL:uint = 5;
		public static const STORAGE_TYPE_TEMPORARY:uint = 6;
		
		public static const STORAGE_ITEM_CATEGORY_TYPE_FINISHED_GOODS:uint = 1;
		public static const STORAGE_ITEM_CATEGORY_TYPE_RAW_MATERIALS:uint = 2;
		public static const STORAGE_ITEM_CATEGORY_TYPE_VIRTUAL:uint = 3;
		public static const STORAGE_ITEM_CATEGORY_TYPE_LABOR:uint = 4;
		
		public static const STORAGE_ITEM_TYPE_ASSEMBLY:uint = 1;
		public static const STORAGE_ITEM_TYPE_KIT:uint = 2;
		public static const STORAGE_ITEM_TYPE_MANUFACTURED:uint = 3;
		public static const STORAGE_ITEM_TYPE_PHANTOM:uint = 4;
		public static const STORAGE_ITEM_TYPE_PURCHASED:uint = 5;
		public static const STORAGE_ITEM_TYPE_LABOR:uint = 6;
		
		// UOM = unit of measure
		public static const STORAGE_ITEM_UOM_EACH:uint = 1;
		public static const STORAGE_ITEM_UOM_KGS:uint = 2;
		public static const STORAGE_ITEM_UOM_TONS:uint = 3;
		public static const STORAGE_ITEM_UOM_LENGTH:uint = 4;
		public static const STORAGE_ITEM_UOM_LITERS:uint = 5;
		public static const STORAGE_ITEM_UOM_METERS:uint = 6;
		
		public static const STORAGE_ITEM_TAX_PERCENT_0:uint = 0;
		public static const STORAGE_ITEM_TAX_PERCENT_5:uint = 5;
		public static const STORAGE_ITEM_TAX_PERCENT_8:uint = 8;
		public static const STORAGE_ITEM_TAX_PERCENT_10:uint = 10;
		public static const STORAGE_ITEM_TAX_PERCENT_18:uint = 18;
		public static const STORAGE_ITEM_TAX_PERCENT_22:uint = 22;
		
		public static const STORAGE_ITEMS_DATA_HOLDER_ID:String = "storageItemsDataHolder";
		public static const STORAGE_CONTENTS_DATA_HOLDER_ID:String = "storageContentsDataHolder";
		
		private var __storages:ModelOperationResponseVo;
		private var __storageItemCategories:ModelOperationResponseVo;
		
		private var __current_category_update_field:UpdateTableFieldVo;
		private var __current_storage_update_field:UpdateTableFieldVo;
		
		public function StorageModel( resourceConfigVo:ResourceConfigVo, target:IEventDispatcher=null )
		{
			super( resourceConfigVo, target);
			__storages = new ModelOperationResponseVo();	
		}
		
		private static var __storageTypeDataProvider:ArrayList;
		public static function get storageTypeDataProvider():IList
		{
			if( ! __storageTypeDataProvider )
			{
				__storageTypeDataProvider = new ArrayList();
				__storageTypeDataProvider.addItem( { value: STORAGE_TYPE_CENTRAL, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'storageCentral') } );
				__storageTypeDataProvider.addItem( { value: STORAGE_TYPE_INNER_BUSINESS, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'storageInnerBussiness') } );
				__storageTypeDataProvider.addItem( { value: STORAGE_TYPE_STORAGE_BUSINESS, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'storageBussiness') } );
				__storageTypeDataProvider.addItem( { value: STORAGE_TYPE_STORAGE_INNER_PERSONAL, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'storageInnerPersonal') } );
				__storageTypeDataProvider.addItem( { value: STORAGE_TYPE_STORAGE_PERSONAL, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'storagePersonal') } );
				__storageTypeDataProvider.addItem( { value: STORAGE_TYPE_TEMPORARY, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'storageTemporary') } );
			}
			
			return __storageTypeDataProvider;
		}
		
		private static var __storageItemUOMDataProvider:ArrayList;
		public static function get storageItemUOMDataProvider():IList
		{
			if( ! __storageItemUOMDataProvider )
			{
				__storageItemUOMDataProvider = new ArrayList();
				__storageItemUOMDataProvider.addItem( { value: STORAGE_ITEM_UOM_EACH, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'uomEach') } );
				__storageItemUOMDataProvider.addItem( { value: STORAGE_ITEM_UOM_KGS, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'uomKgs') } );
				__storageItemUOMDataProvider.addItem( { value: STORAGE_ITEM_UOM_TONS, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'uomTons') } );
				__storageItemUOMDataProvider.addItem( { value: STORAGE_ITEM_UOM_METERS, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'uomMeters') } );
				__storageItemUOMDataProvider.addItem( { value: STORAGE_ITEM_UOM_LENGTH, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'uomLength') } );
				__storageItemUOMDataProvider.addItem( { value: STORAGE_ITEM_UOM_LITERS, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'uomLiters') } );
			}
			
			return __storageItemUOMDataProvider;
		}
		
		private static var __storageItemTypeDataProvider:ArrayList;
		public static function get storageItemTypeDataProvider():IList
		{
			if( ! __storageItemTypeDataProvider )
			{
				__storageItemTypeDataProvider = new ArrayList();
				__storageItemTypeDataProvider.addItem( { value: STORAGE_ITEM_TYPE_ASSEMBLY, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'itemTypeAssembly') } );
				__storageItemTypeDataProvider.addItem( { value: STORAGE_ITEM_TYPE_KIT, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'itemTypeKit') } );
				__storageItemTypeDataProvider.addItem( { value: STORAGE_ITEM_TYPE_MANUFACTURED, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'itemTypeManufectured') } );
				__storageItemTypeDataProvider.addItem( { value: STORAGE_ITEM_TYPE_PHANTOM, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'itemTypePhantom') } );
				__storageItemTypeDataProvider.addItem( { value: STORAGE_ITEM_TYPE_PURCHASED, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'itemTypePurchased') } );
				__storageItemTypeDataProvider.addItem( { value: STORAGE_ITEM_TYPE_LABOR, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'itemTypeLabor') } );
			}
			
			return __storageItemTypeDataProvider;
		}
		
		private static var __itemCategoryTypeDataProvider:ArrayList;
		public static function get itemCategoryTypeDataProvider():IList
		{
			if( ! __itemCategoryTypeDataProvider )
			{
				__itemCategoryTypeDataProvider = new ArrayList();
				__itemCategoryTypeDataProvider.addItem( { value: STORAGE_ITEM_CATEGORY_TYPE_FINISHED_GOODS, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'finishedGoods') } );
				__itemCategoryTypeDataProvider.addItem( { value: STORAGE_ITEM_CATEGORY_TYPE_RAW_MATERIALS, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'rawMaterials') } );
				__itemCategoryTypeDataProvider.addItem( { value: STORAGE_ITEM_CATEGORY_TYPE_VIRTUAL, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'virtual') } );
				__itemCategoryTypeDataProvider.addItem( { value: STORAGE_ITEM_CATEGORY_TYPE_LABOR, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'itemTypeLabor') } );
			}
			
			return __itemCategoryTypeDataProvider;
		}
		
		public static function itemCategoryTypeLabelFunction(item:Object, column:GridColumn):String
		{
			var c:Object;
			for( var i:uint = 0; i < itemCategoryTypeDataProvider.length; i++ )
			{
				c = itemCategoryTypeDataProvider.getItemAt( i );
				
				if( c.value == item.storage_item_category_type )
				{
					return c.label;
				}
			}
			
			return item.storage_item_category_type;
		}
		
		// EMPLOYEES
		public function createItem( item:StorageItemVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
				
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "storage";
				web.action = STORAGE_CREATE_ITEM_OPERATION;
			
			web.data = _getUrlVariablesFromVo( item );
			
			_startOperation( web, service );
		}
		
		public function readItems( read:ReadVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
				
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "storage";
				web.action = STORAGE_READ_ITEMS_OPERATION;
				
				web.voClasses = new Object();
			    web.voClasses.StorageItemVo = "vos.StorageItemVo";
				
			web.data = _getUrlVariablesFromVo( read );
			
			_startOperation( web, service );	
			
		}
				
		public function updateItem( item:StorageItemVo, requester:IServiceReqester  ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
				
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "storage";
				web.action = STORAGE_UPDATE_ITEM_OPERATION;
			
			web.data = _getUrlVariablesFromVo( item );
			
			_startOperation( web, service );
		}
	
		
		
		// CATEGORIES
		public function createItemCategory( itemCategory:StorageItemCategoryVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
			service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
			web.module = "storage";
			web.action = STORAGE_CREATE_ITEM_CATEGORY_OPERATION;
			
			web.voClasses = new Object();
			web.voClasses.StorageItemCategoryVo = "vos.StorageItemCategoryVo";
			
			web.data = _getUrlVariablesFromVo( itemCategory );
			
			_startOperation( web, service );
		}
		
		public function readItemCategories( read:ReadVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
			service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
			web.module = "storage";
			web.action = STORAGE_READ_ITEM_CATEGORIES_OPERATION;
			
			web.voClasses = new Object();
			web.voClasses.StorageItemCategoryVo = "vos.StorageItemCategoryVo";
			
			web.data = _getUrlVariablesFromVo( read );
			
			_startOperation( web, service );	
			
		}
		
		public function readItemCategoriesForSelect( requester:IServiceReqester ):void
		{
			if( __storageItemCategories )
			{
				var e:ModelDataChangeEvent = new ModelDataChangeEvent( ModelDataChangeEvent.MODEL_LOADING_DATA_COMPLETE );
					e.operationName =  STORAGE_READ_CATEGORIES_SELECT_OPERATION;
					e.response = __storageItemCategories;
					e.requester = requester;
				
				dispatchEvent( e );
				
				if( requester )
					requester.modelLoadingDataComplete( e );
			}
			
			var service:ServiceLoader = new ServiceLoader();
			service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
			web.module = "storage";
			web.action = STORAGE_READ_CATEGORIES_SELECT_OPERATION;
			
			web.voClasses = new Object();
			web.voClasses.StorageItemCategoryVo = "vos.StorageItemCategoryVo";
			
			_startOperation( web, service );
		}
		
		public function updateItemCategory( employeeEconomic:StorageItemCategoryVo, requester:IServiceReqester  ):void
		{
			var service:ServiceLoader = new ServiceLoader();
			service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
			web.module = "storage";
			web.action = STORAGE_UPDATE_ITEM_CATEGORY_OPERATION;
			
			web.data = _getUrlVariablesFromVo( employeeEconomic );
			
			_startOperation( web, service );
		}
		
		public function updateItemCategoryField( update:UpdateTableFieldVo, requester:IServiceReqester ):void
		{
			__current_category_update_field = update;
			
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
			web.module = "storage";
			web.action = STORAGE_UPDATE_ITEM_CATEGORY__FIELD_OPERATION;
			
			web.data = _getUrlVariablesFromVo( update );
			
			_startOperation( web, service );
		}
		
		// STORAGES
		public function createStorage( storage:StorageVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "storage";
				web.action = STORAGE_CREATE_STORAGE_OPERATION;
				
				web.voClasses = new Object();
				web.voClasses.StorageVo = "vos.StorageVo";
			
				web.data = _getUrlVariablesFromVo( storage );
			
			_startOperation( web, service );
		}
		
		public function readStorages( read:ReadVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "storage";
				web.action = STORAGE_READ_STORAGES_OPERATION;
			
				web.voClasses = new Object();
				web.voClasses.StorageVo = "vos.StorageVo";
				
				web.data = _getUrlVariablesFromVo( read );
			
			_startOperation( web, service );	
			
		}
		
		public function readStoragesForSelect( requester:IServiceReqester ):void
		{
			if( __storages )
			{
				var e:ModelDataChangeEvent = new ModelDataChangeEvent( ModelDataChangeEvent.MODEL_LOADING_DATA_COMPLETE );
					e.operationName =  STORAGE_READ_STORAGES_SELECT_OPERATION;
					e.response = __storages;
					e.requester = requester;
				
				dispatchEvent( e );
				
				if( requester )
					requester.modelLoadingDataComplete( e );
			}
			
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "storage";
				web.action = STORAGE_READ_STORAGES_SELECT_OPERATION;
				
				web.voClasses = new Object();
				web.voClasses.StorageVo = "vos.StorageVo";
			
			_startOperation( web, service );
		}
		
		public function updateStorageCategory( storage:StorageVo, requester:IServiceReqester  ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "storage";
				web.action = STORAGE_UPDATE_STORAGE_OPERATION;
			
				web.data = _getUrlVariablesFromVo( storage );
			
			_startOperation( web, service );
		}
		
		public function updateStorageField( update:UpdateTableFieldVo, requester:IServiceReqester ):void
		{
			__current_storage_update_field = update;
			
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "storage";
				web.action = STORAGE_UPDATE_STORAGE__FIELD_OPERATION;
				
				web.data = _getUrlVariablesFromVo( update );
			
			_startOperation( web, service );
		}
		
		public static function storageTypeLabelFunction(item:Object, column:GridColumn):String
		{
			var c:Object;
			for( var i:uint = 0; i < storageTypeDataProvider.length; i++ )
			{
				c = storageTypeDataProvider.getItemAt( i );
				
				if( c.value == item.storage_type )
				{
					return c.label;
				}
			}
			
			return item.storage_item_category_type;
		}
		
		override protected function _finishOperation( serviceEvent:ServiceEvent, dispatch:Boolean = true ):ModelOperationResponseVo
		{
			var op:ModelOperationResponseVo = super._finishOperation( serviceEvent, false );
			var service:ServiceLoader = serviceEvent.target as ServiceLoader;
			
			if( op.status == STATUS_OK )
			{
				
				if( service.name == STORAGE_CREATE_ITEM_CATEGORY_OPERATION )
				{
					__storageItemCategories = null;
					readItemCategoriesForSelect( null );
				}
				else if( service.name == STORAGE_UPDATE_ITEM_CATEGORY__FIELD_OPERATION )
				{
					if( __current_category_update_field.value_name == "storage_item_category_name" )
					{
						__storageItemCategories = null;
						readItemCategoriesForSelect( null );
					}
				}
				else if( service.name == STORAGE_CREATE_STORAGE_OPERATION )
				{
					__storages = null;
					readStoragesForSelect( null );
				}
				else if( service.name == STORAGE_UPDATE_STORAGE__FIELD_OPERATION )
				{
					if( __current_storage_update_field.value_name == "storage_name" )
					{
						__storages = null;
						readStoragesForSelect( null );
					}
				}
			}
			
			_dispatchOperationResponse( serviceEvent, op );
			
			return op;
		}
		
	}
}