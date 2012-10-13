package modules.sub
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
	
	import components.app.SaveData;
	import components.events.SaveDataEvent;
	
	import factories.ModelFactory;
	
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	import interfaces.modules.sub.ISaveItemModule;
	
	import models.StorageModel;
	
	import mx.controls.DateChooser;
	import mx.controls.DateField;
	import mx.events.FlexEvent;
	
	import skins.Default.modules.sub.SaveItemSkin;
	
	import spark.components.Button;
	import spark.components.CheckBox;
	import spark.components.ComboBox;
	import spark.components.Form;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.RadioButtonGroup;
	import spark.components.TextArea;
	import spark.components.TextInput;
	
	import vos.StorageItemVo;
	
	public class SaveItemModule extends SystemModuleBase implements ISaveItemModule
	{	
		[SkinPart(required="true")]
		public var itemForm:Form;
		
		[SkinPart(required="false")]
		public var customer_id:TextInput;
		
		[SkinPart(required="false")]
		public var storage_item_code:TextInput;
		
		[SkinPart(required="false")]
		public var storage_item_name:TextInput;
		
		[SkinPart(required="false")]
		public var storage_item_descrition:TextArea;
		
		[SkinPart(required="false")]
		public var storage_item_category:ComboBox;
		
		[SkinPart(required="false")]
		public var storage_item_order_quantity:TextInput;
		
		[SkinPart(required="false")]
		public var storage_item_volume:TextInput;
		
		[SkinPart(required="false")]
		public var storage_item_weight:TextInput;
		
		[SkinPart(required="false")]
		public var storage_item_type:ComboBox;
		
		[SkinPart(required="false")]
		public var storage_item_unit_of_measure:ComboBox;
		
		[SkinPart(required="false")]
		public var storage_item_bar_code:TextInput;
		
		[SkinPart(required="false")]
		public var storage_item_tax_percent:ComboBox;
		
		[SkinPart(required="false")]
		public var storage_item_date_created:DateField;
		
		
		[SkinPart(required="false")]
		public var customer_country:ComboBox;
		
		
		private var __storageModel:StorageModel;
		
		public function SaveItemModule()
		{
			super();
			
		}
		
		public function get saveDataComponent():SaveData
		{
			return saveDataCmp;
		}
		
		override public function init():void
		{
			super.init();
			
			__storageModel = ModelFactory.storageModel();
			//setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "saveCustomerModule", this.session.skinsLocaleName ) );
			setStyle( "skinClass", SaveItemSkin );
			
			__storageModel.addEventListener( ModelDataChangeEvent.MODEL_LOADING_DATA, _modelLoadingDataEventHandler );
			__storageModel.addEventListener( ModelDataChangeEvent.MODEL_LOADING_DATA_COMPLETE, _modelLoadingDataCompleteEventHandler );
		}
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if( instance == saveDataCmp )
			{
				saveDataCmp.addEventListener( SaveDataEvent.SAVE_DATA, _saveCustomerEventHandler );
				saveDataCmp.addEventListener( SaveDataEvent.RESET_DATA, _resetCustomerFormEventHandler );
			}
			else if( instance == storage_item_category )
			{
				storage_item_category.labelField = "storage_item_category_name";
			}
			else if( instance == storage_item_unit_of_measure )
			{
				storage_item_unit_of_measure.dataProvider = StorageModel.storageItemUOMDataProvider;
			}
			else if( instance == storage_item_type )
			{
				storage_item_type.dataProvider = StorageModel.storageItemTypeDataProvider;
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if( instance == saveDataCmp )
			{
				saveDataCmp.removeEventListener( SaveDataEvent.SAVE_DATA, _saveCustomerEventHandler );
				saveDataCmp.removeEventListener( SaveDataEvent.RESET_DATA, _resetCustomerFormEventHandler );
			}
			
			super.partRemoved( partName, instance );
		}
		
		protected function _saveCustomerEventHandler( event:SaveDataEvent ):void
		{
			var i:StorageItemVo;
			
			if( mode == CrudOperations.CREATE )
			{
				i = new StorageItemVo();
			}
			else if( mode == CrudOperations.UPDATE )
			{
				i = data as StorageItemVo;
			}
			
	
			i.storage_item_bar_code = storage_item_bar_code.text;
			i.storage_item_category = storage_item_category.selectedItem.storage_item_category_id;
			i.storage_item_code = storage_item_code.text;
			i.storage_item_date_created = storage_item_date_created.text;
			i.storage_item_description = storage_item_descrition.text;
			i.storage_item_name = storage_item_name.text;
			i.storage_item_order_quantity = Number( storage_item_order_quantity.text );
			i.storage_item_tax_percent = storage_item_tax_percent.selectedItem;
			i.storage_item_type = storage_item_type.selectedItem.value;
			i.storage_item_unit_of_measure = storage_item_unit_of_measure.selectedItem.value
			i.storage_item_volume = Number( storage_item_volume.text );
			i.storage_item_weight = Number( storage_item_weight.text );
			
			if( mode == CrudOperations.CREATE )
			{
				__storageModel.createItem( i, this );
			}
			else
			{
				__storageModel.updateItem( i, this );
			}
		}
		
		override public function set data( d:Object ):void
		{
			super.data = d;
			_fillForm( d as StorageItemVo );
		}

		protected function _fillForm( d:StorageItemVo ):void
		{
			if( ! created || ! d )
				return;
			 
			
			storage_item_bar_code.text = d.storage_item_bar_code;
			FormHelper.setComboBoxSelectedValue( storage_item_category, "storage_item_category_id", d.storage_item_category );
			storage_item_code.text = d.storage_item_code;
			storage_item_date_created.text = d.storage_item_date_created;
			storage_item_descrition.text = d.storage_item_description;
			storage_item_name.text = d.storage_item_name;
			storage_item_order_quantity.text = d.storage_item_order_quantity.toString();
			storage_item_tax_percent.selectedItem = d.storage_item_tax_percent;
			FormHelper.setComboBoxSelectedValue( storage_item_type, "value", d.storage_item_type );
			FormHelper.setComboBoxSelectedValue( storage_item_unit_of_measure, "value", d.storage_item_unit_of_measure );
			storage_item_volume.text = d.storage_item_volume.toString();
			storage_item_weight.text = d.storage_item_weight.toString();
		}
		
		protected function _clearForm():void
		{
			/***
			customerForm.
			customer_address.text;
			customer_bank_account.text;
			customer_bank_account2.text;
			customer_bank_account3.text;
			customer_city.text;
			customer_code.text;
			customer_company_number.text;
			customer_company_tax_number.text;
			customer_company_vat_number.text;
			customer_contact_person.text;
			customer_country.selectedItem as uint;
			customer_credit_limit.text as uint;
			customer_currency.selectedItem;
			customer_email_address.text;
			
			customer_mobile.text;
			customer_mobile2.text;
			customer_name.text;
			customer_note.text;
			**/
		}
		
		protected function _resetCustomerFormEventHandler( event:SaveDataEvent ):void
		{
			//FormHelper.resetForm( customerForm1 );
			//FormHelper.resetForm( customerForm2 );
		}
		
		
		protected function _modelLoadingDataEventHandler( event:ModelDataChangeEvent ):void
		{
			if( event.operationName == StorageModel.STORAGE_READ_CATEGORIES_SELECT_OPERATION )
			{
				setLoadingComboBox( storage_item_category );
			}
		}
		
		
		protected function _modelLoadingDataCompleteEventHandler( event:ModelDataChangeEvent ):void
		{
			if( event.operationName == StorageModel.STORAGE_READ_CATEGORIES_SELECT_OPERATION && event.requester != this )
			{
				_updateReadData( event.response, storage_item_category );
				
				if( data && data is StorageItemVo )
				{
					FormHelper.setComboBoxSelectedValue( storage_item_category, "storage_item_category_id", ( data as StorageItemVo ).storage_item_category );
				}
			}
		}
		
		override public function modelLoadingData(event:ModelDataChangeEvent):void
		{
			if( event.operationName == StorageModel.STORAGE_CREATE_ITEM_OPERATION ||
				event.operationName == StorageModel.STORAGE_UPDATE_ITEM_OPERATION )
			{
				super.modelLoadingData( event );
			}
		}
		
		override public function modelLoadingDataComplete(event:ModelDataChangeEvent):void
		{
			if( event.operationName == StorageModel.STORAGE_CREATE_ITEM_OPERATION ||
				event.operationName == StorageModel.STORAGE_UPDATE_ITEM_OPERATION )
			{
				super.modelLoadingDataComplete( event );
			}
			else if( event.operationName == StorageModel.STORAGE_READ_CATEGORIES_SELECT_OPERATION )
			{
				_updateReadData( event.response, storage_item_category );
				
				if( data && data is StorageItemVo )
				{
					FormHelper.setComboBoxSelectedValue( storage_item_category, "storage_item_category_id", ( data as StorageItemVo ).storage_item_category );
				}
			}
		}
		
		override protected function _creationComplete(event:FlexEvent):void
		{
			super._creationComplete(event);
			__storageModel.readItemCategoriesForSelect(this);
				
			if( mode == CrudOperations.UPDATE )
			{
				if( data )
					_fillForm( data as StorageItemVo );
			}
		}
	}
}