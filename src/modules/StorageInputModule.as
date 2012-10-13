package modules
{
	import com.desktop.system.Application.Library.ui.FormHelper;
	import com.desktop.system.Application.Library.ui.SkinBase;
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.core.SystemModuleBase;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.interfaces.IResourceHolder;
	import com.desktop.system.utility.CrudOperations;
	import com.desktop.system.vos.NotificationVo;
	import com.desktop.ui.Components.Group.LoadingContainer;
	import com.desktop.ui.vos.ResourceHolderVo;
	
	import components.Paging;
	import components.app.SaveData;
	import components.events.SaveDataEvent;
	
	import factories.ModelFactory;
	
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	import interfaces.modules.sub.ISaveItemModule;
	import interfaces.modules.sub.IStorageInputModule;
	
	import models.StorageModel;
	
	import mx.controls.DateChooser;
	import mx.controls.DateField;
	import mx.events.FlexEvent;
	
	import skins.Default.modules.StorageInputModuleSkin;
	import skins.Default.modules.sub.SaveItemSkin;
	
	import spark.components.Button;
	import spark.components.CheckBox;
	import spark.components.ComboBox;
	import spark.components.DataGrid;
	import spark.components.Form;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.RadioButtonGroup;
	import spark.components.TextArea;
	import spark.components.TextInput;
	
	import vos.StorageItemVo;
	import vos.StorageVo;
	
	public class StorageInputModule extends SystemModuleBase implements IStorageInputModule
	{	
		[SkinPart(required="false")]
		public var storageInputDataHolder:DataGrid;
		
		[SkinPart(required="false")]
		public var storageInputPaging:Paging;
		
		[SkinPart(required="false")]
		public var storagesList:ComboBox;
		
		
		private var __storage_model:StorageModel;
		
		public function StorageInputModule()
		{
			super();
		}
		
		public function get saveDataComponent():SaveData
		{
			return saveDataCmp;
		}
		
		override public function get resourceHolderConfig():ResourceHolderVo
		{ 
			var rh:ResourceHolderVo = new ResourceHolderVo();
				rh.title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "storageInput" );
				rh.width = 1200;
				rh.height = 800;
				rh.maximizable = true;
				rh.resizable = true;
				rh.minimizable = true;
				rh.maximized = true;
				rh.titleBarIcon = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "itemsModuleIcon", this.session.skinsLocaleName );
			
			return rh;
		}
		
		override public function init():void
		{
			super.init();
			
			__storage_model = ModelFactory.storageModel();
			//setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "saveCustomerModule", this.session.skinsLocaleName ) );
			setStyle( "skinClass", StorageInputModuleSkin );
			
			__storage_model.addEventListener( ModelDataChangeEvent.MODEL_LOADING_DATA, _modelLoadingDataEventHandler );
			__storage_model.addEventListener( ModelDataChangeEvent.MODEL_LOADING_DATA_COMPLETE, _modelLoadingDataCompleteEventHandler );
		}
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if( instance == storagesList )
			{
				storagesList.labelField = "storage_name";
			}
		}
		
		protected function _modelLoadingDataEventHandler( event:ModelDataChangeEvent ):void
		{
		}
		
		
		protected function _modelLoadingDataCompleteEventHandler( event:ModelDataChangeEvent ):void
		{
			
		}
		
		override public function modelLoadingData(event:ModelDataChangeEvent):void
		{
			
			if( event.operationName == StorageModel.STORAGE_READ_STORAGES_SELECT_OPERATION )
			{
				setLoadingComboBox( storagesList );
			}
			
		}
		
		override public function modelLoadingDataComplete(event:ModelDataChangeEvent):void
		{
			if( event.operationName == StorageModel.STORAGE_READ_STORAGES_SELECT_OPERATION )
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
			
			_setupOrder( storageInputDataHolder, storageInputPaging );
			
			__storage_model.readStoragesForSelect( this );
		}
		
		protected function _readStorageInput():void
		{
			
		}
		
	}
}