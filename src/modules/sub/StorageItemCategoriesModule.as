package modules.sub
{
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.core.SystemModuleBase;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.utility.SystemUtility;
	import com.desktop.system.vos.NotificationVo;
	import com.desktop.system.vos.ReadVo;
	import com.desktop.system.vos.UpdateTableFieldVo;
	import com.desktop.ui.Components.Button.DesktopControllButton;
	
	import factories.ModelFactory;
	
	import flash.events.MouseEvent;
	
	import interfaces.modules.sub.IEmployeeEconomicsModule;
	import interfaces.modules.sub.IStorageItemCategoriesModule;
	import interfaces.modules.sub.IStoragesModule;
	
	import models.EmployeesModel;
	import models.StorageModel;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.events.FlexEvent;
	
	import skins.Default.modules.sub.StorageItemCategoriesModuleSkin;
	
	import spark.components.DataGrid;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.GridEvent;
	import spark.events.GridItemEditorEvent;
	
	import vos.EmployeeEconomicsVo;
	import vos.StorageItemCategoryVo;
	
	public class StorageItemCategoriesModule extends SystemModuleBase implements IStorageItemCategoriesModule
	{
		
		[SkinPart(required="false")]
		public var newCategoryButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var refreshButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var deleteCategoryButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var categoriesDataHolder:DataGrid;
		
		private var __storage_model:StorageModel;
		private var __current_editing_row:StorageItemCategoryVo;
		
		public function StorageItemCategoriesModule()
		{
			super();
		}
		
		override public function init():void
		{
			super.init();
			
			__storage_model = ModelFactory.storageModel();
			//setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "employeeEconomicsModule", this.session.skinsLocaleName ) );
			setStyle( "skinClass", StorageItemCategoriesModuleSkin );
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == newCategoryButton )
			{
				newCategoryButton.addEventListener( MouseEvent.CLICK, _createItemCategoryButtonClickHandler );
			}
			else if( instance == refreshButton )
			{
				refreshButton.addEventListener( MouseEvent.CLICK, _refreshButtonClickHandler );
			}
			else if( instance == deleteCategoryButton )
			{
				deleteCategoryButton.addEventListener( MouseEvent.CLICK, _deleteItemCategoryButtonClickHandler );
			}
			
			else if( instance == categoriesDataHolder )
			{
				categoriesDataHolder.addEventListener( GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, _categoriesDataHolderSaveEventHandler );
				categoriesDataHolder.addEventListener( GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_START, _categoriesDataHolderStartEditEventHandler );
				categoriesDataHolder.dataProvider = new ArrayList();
			}
			
		}
		
		
		protected function _createItemCategoryButtonClickHandler( event:MouseEvent ):void
		{
			var c:StorageItemCategoryVo = new StorageItemCategoryVo();
				c.storage_item_category_name = "NEW";
				c.storage_item_category_type = StorageModel.STORAGE_ITEM_CATEGORY_TYPE_FINISHED_GOODS;
				c.storage_item_category_code = "";
				c.storage_item_category_id = '';
				
			__storage_model.createItemCategory( c, this );
		}
		
		protected function _refreshButtonClickHandler( event:MouseEvent ):void
		{
			_readCategories();
		}
		
		protected function _deleteItemCategoryButtonClickHandler( event:MouseEvent ):void
		{
			
		}
		
		
		protected function _categoriesDataHolderStartEditEventHandler( event:GridItemEditorEvent ):void
		{
			var e:StorageItemCategoryVo = ( ( categoriesDataHolder as DataGrid ).dataProvider as ArrayList ).getItemAt( event.rowIndex ) as StorageItemCategoryVo;
			__current_editing_row = SystemUtility.clone( e ) as StorageItemCategoryVo;
		}
		
		protected function _categoriesDataHolderSaveEventHandler( event:GridItemEditorEvent ):void
		{
			event.preventDefault();
			
			var e:StorageItemCategoryVo = ( ( categoriesDataHolder as DataGrid ).dataProvider as ArrayList ).getItemAt( event.rowIndex ) as StorageItemCategoryVo;
			
			var update:UpdateTableFieldVo = new UpdateTableFieldVo();
				update.id_value = e.storage_item_category_id.toString();
				update.value_name = event.column.dataField;
				update.value = e[ event.column.dataField ];
				
			__storage_model.updateItemCategoryField( update, this );
		}
		
		override public function modelLoadingDataComplete(event:ModelDataChangeEvent):void
		{
			super.modelLoadingDataComplete( event );
			
			if( event.operationName == StorageModel.STORAGE_CREATE_ITEM_CATEGORY_OPERATION )
			{
				if( ! categoriesDataHolder.dataProvider )
					categoriesDataHolder.dataProvider = new ArrayList();
				
				categoriesDataHolder.dataProvider.addItemAt( event.response.result, 0 );
			}
			else if( event.operationName == StorageModel.STORAGE_READ_ITEM_CATEGORIES_OPERATION )
			{
				categoriesDataHolder.dataProvider = event.response.result as IList;
			}	
		}
		
		override public function modelLoadingDataError(event:ModelDataChangeEvent):void
		{
			super.modelLoadingDataError(event);
			
			if( event.operationName == EmployeesModel.EMPLOYEE_UPDATE_ECONOMIC_FIELD_OPERATION )
			{
				( ( categoriesDataHolder as DataGrid ).dataProvider as ArrayList ).setItemAt( __current_editing_row, ( categoriesDataHolder as DataGrid ).selectedIndex );
				var nvo:NotificationVo = new NotificationVo();
					nvo.icon = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, 'deleteErrorIcon', session.skinsLocaleName );
					nvo.title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "error" );
					nvo.text = resourceManager.getString( this.session.config.LOCALE_CONFIG.messagesResourceName, "serverError" );
					nvo.okButton = true;
					notify( nvo );	
			}
		}
		
		override protected function _creationComplete(event:FlexEvent):void
		{
			super._creationComplete(event);
			_readCategories();
		}
		
		protected function _readCategories():void
		{
			var r:ReadVo = new ReadVo();
				r.sortColumnName = "storage_item_category_id";
				r.sortColumnDirection = BaseModel.SORT_DIRECTION_DESCENDING;
			
			__storage_model.readItemCategories( r, this );
		}
		
	}
}