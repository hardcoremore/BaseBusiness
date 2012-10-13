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
	import interfaces.modules.sub.IStoragesModule;
	
	import models.EmployeesModel;
	import models.StorageModel;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.events.FlexEvent;
	
	import skins.Default.modules.sub.StoragesModuleSkin;
	
	import spark.components.DataGrid;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.GridEvent;
	import spark.events.GridItemEditorEvent;
	
	import vos.EmployeeEconomicsVo;
	import vos.StorageVo;
	
	public class StoragesModule extends SystemModuleBase implements IStoragesModule
	{
		
		[SkinPart(required="false")]
		public var newStorageButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var refreshButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var deleteStorageButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var storagesDataHolder:DataGrid;
		
		private var __storage_model:StorageModel;
		private var __current_editing_row:StorageVo;
		
		public function StoragesModule()
		{
			super();
		}
		
		override public function init():void
		{
			super.init();
			
			__storage_model = ModelFactory.storageModel();
			//setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "employeeEconomicsModule", this.session.skinsLocaleName ) );
			setStyle( "skinClass", StoragesModuleSkin );
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == newStorageButton )
			{
				newStorageButton.addEventListener( MouseEvent.CLICK, _createStorageButtonClickHandler );
			}
			else if( instance == refreshButton )
			{
				refreshButton.addEventListener( MouseEvent.CLICK, _refreshStoragesButtonClickHandler );
			}
			else if( instance == deleteStorageButton )
			{
				deleteStorageButton.addEventListener( MouseEvent.CLICK, _deleteStorageButtonClickHandler );
			}
			
			else if( instance == storagesDataHolder )
			{
				( storagesDataHolder as DataGrid ).addEventListener( GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, _economicsDataHolderSaveEventHandler );
				( storagesDataHolder as DataGrid ).addEventListener( GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_START, _economicDataHolderStartEditEventHandler );
				( storagesDataHolder as DataGrid ).dataProvider = new ArrayList();
			}
			
		}
		
		
		protected function _createStorageButtonClickHandler( event:MouseEvent ):void
		{
			var e:StorageVo = new StorageVo();
				e.storage_name = "NEW";
				e.storage_code = "";
				e.storage_address = "";
				e.storage_type = StorageModel.STORAGE_TYPE_STORAGE_BUSINESS;
				
			__storage_model.createStorage( e, this );	
		}
		
		protected function _refreshStoragesButtonClickHandler( event:MouseEvent ):void
		{
			_readStorages();
		}
		
		protected function _deleteStorageButtonClickHandler( event:MouseEvent ):void
		{
			
		}
		
		
		protected function _economicDataHolderStartEditEventHandler( event:GridItemEditorEvent ):void
		{
			var e:StorageVo = storagesDataHolder.dataProvider.getItemAt( event.rowIndex ) as StorageVo;
			__current_editing_row = SystemUtility.clone( e ) as StorageVo;
		}
		
		protected function _economicsDataHolderSaveEventHandler( event:GridItemEditorEvent ):void
		{
			event.preventDefault();
			
			var e:StorageVo = storagesDataHolder.dataProvider.getItemAt( event.rowIndex ) as StorageVo;
			
			var update:UpdateTableFieldVo = new UpdateTableFieldVo();
				update.id_value = e.storage_id.toString();
				update.value_name = event.column.dataField;
				update.value = e[ event.column.dataField ];
				
			__storage_model.updateStorageField( update, this );
		}
		
		override public function modelLoadingDataComplete(event:ModelDataChangeEvent):void
		{
			super.modelLoadingDataComplete( event );
			
			if( event.operationName == StorageModel.STORAGE_CREATE_STORAGE_OPERATION )
			{
				if( ! storagesDataHolder.dataProvider ) storagesDataHolder.dataProvider = new ArrayList();
				
				storagesDataHolder.dataProvider.addItemAt( event.response.result, 0 );
			}
			else if( event.operationName == StorageModel.STORAGE_READ_STORAGES_OPERATION )
			{
				storagesDataHolder.dataProvider = event.response.result as IList;
			}
		}
		
		override public function modelLoadingDataError(event:ModelDataChangeEvent):void
		{
			super.modelLoadingDataError(event);
			
			if( event.operationName == EmployeesModel.EMPLOYEE_UPDATE_ECONOMIC_FIELD_OPERATION )
			{
				( ( storagesDataHolder as DataGrid ).dataProvider as ArrayList ).setItemAt( __current_editing_row, ( storagesDataHolder as DataGrid ).selectedIndex );
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
			_readStorages();
		}
		
		protected function _readStorages():void
		{
			var r:ReadVo = new ReadVo();
				r.sortColumnName = "storage_id";
				r.sortColumnDirection = BaseModel.SORT_DIRECTION_DESCENDING;
			
			__storage_model.readStorages( r, this );
		}
		
	}
}