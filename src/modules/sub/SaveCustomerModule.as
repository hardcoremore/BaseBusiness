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
	
	import interfaces.modules.sub.ISaveCustomerModule;
	
	import models.CustomersModel;
	
	import mx.controls.DateField;
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.components.CheckBox;
	import spark.components.ComboBox;
	import spark.components.Form;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.RadioButtonGroup;
	import spark.components.TextArea;
	import spark.components.TextInput;
	
	import vos.CustomersVo;
	
	public class SaveCustomerModule extends SystemModuleBase implements ISaveCustomerModule
	{	
		[SkinPart(required="true")]
		public var customerForm1:Form;
		
		[SkinPart(required="true")]
		public var customerForm2:Form;
		
		[SkinPart(required="false")]
		public var customer_id:TextInput;
		
		[SkinPart(required="false")]
		public var customer_code:TextInput;
		
		[SkinPart(required="false")]
		public var customer_sales_type_buyer:CheckBox;
		
		[SkinPart(required="false")]
		public var customer_sales_type_supplier:CheckBox;
		
		[SkinPart(required="false")]
		public var customer_tax_enabled:RadioButtonGroup;
		
		[SkinPart(required="false")]
		public var customer_vat_value:TextInput;
		
		[SkinPart(required="false")]
		public var customer_name:TextInput;
		
		[SkinPart(required="false")]
		public var customer_telephone:TextInput;
		
		[SkinPart(required="false")]
		public var customer_telephone2:TextInput;
		
		[SkinPart(required="false")]
		public var customer_mobile:TextInput;
		
		[SkinPart(required="false")]
		public var customer_mobile2:TextInput;
		
		[SkinPart(required="false")]
		public var customer_contact_person:TextInput;
		
		[SkinPart(required="false")]
		public var customer_country:ComboBox;
		
		[SkinPart(required="false")]
		public var customer_zip_code:TextInput;
		
		[SkinPart(required="false")]
		public var customer_city:TextInput;
		
		[SkinPart(required="false")]
		public var customer_address:TextInput;
		
		[SkinPart(required="false")]
		public var customer_email_address:TextInput;
		
		[SkinPart(required="false")]
		public var customer_company_number:TextInput;
		
		[SkinPart(required="false")]
		public var customer_company_vat_number:TextInput;
		
		[SkinPart(required="false")]
		public var customer_company_tax_number:TextInput;
		
		[SkinPart(required="false")]
		public var customer_since:DateField;
		
		[SkinPart(required="false")]
		public var customer_note:TextArea;
		
		[SkinPart(required="false")]
		public var customer_bank_account:TextInput;
		
		[SkinPart(required="false")]
		public var customer_bank_account2:TextInput;
		
		[SkinPart(required="false")]
		public var customer_bank_account3:TextInput;
		
		[SkinPart(required="false")]
		public var customer_currency:ComboBox;
		
		[SkinPart(required="false")]
		public var customer_credit_limit:TextInput;
		
		private var __customerModel:CustomersModel;
		
		public function SaveCustomerModule()
		{
			super();
			__customerModel = ModelFactory.customersModel();
		}
		
		public function get saveDataComponent():SaveData
		{
			return saveDataCmp;
		}
		
		override public function init():void
		{
			super.init();
			setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "saveCustomerModule", this.session.skinsLocaleName ) );
		}
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if( instance == saveDataCmp )
			{
				saveDataCmp.addEventListener( SaveDataEvent.SAVE_DATA, _saveCustomerEventHandler );
				saveDataCmp.addEventListener( SaveDataEvent.RESET_DATA, _resetCustomerFormEventHandler );
			}
			else if( instance == customer_currency )
			{
				customer_currency.dataProvider = BaseModel.currencyDataProvider;
			}
			else if( instance == customer_country )
			{
				customer_country.dataProvider = BaseModel.countryDataProvider;
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
			var c:CustomersVo;
			
			if( mode == CrudOperations.CREATE )
			{
				c = new CustomersVo();
			}
			else if( mode == CrudOperations.UPDATE )
			{
				c = data as CustomersVo;
			}
			
			c.customer_id = customer_id.text;
			c.customer_address = customer_address.text;
			c.customer_bank_account = customer_bank_account.text;
			c.customer_bank_account2 = customer_bank_account2.text;
			c.customer_bank_account3 = customer_bank_account3.text;
			c.customer_city = customer_city.text;
			c.customer_code = customer_code.text;
			c.customer_company_number = customer_company_number.text;
			c.customer_company_tax_number = customer_company_tax_number.text;
			c.customer_company_vat_number = customer_company_vat_number.text;
			c.customer_contact_person = customer_contact_person.text;
			
			c.customer_country = uint( customer_country.selectedItem.value );
			c.customer_credit_limit = uint( customer_credit_limit.text );
			c.customer_currency = customer_currency.selectedItem.value;
			
			c.customer_email_address = customer_email_address.text;
			
			c.customer_mobile = customer_mobile.text;
			c.customer_mobile2 = customer_mobile2.text;
			c.customer_name = customer_name.text;
			c.customer_note = customer_note.text;
			
			if( customer_sales_type_buyer.selected && customer_sales_type_supplier.selected )
			{
				c.customer_sales_type = CustomersModel.CUSTOMER_TYPE_BOTH;
			}
			else if( customer_sales_type_buyer.selected )
			{
				c.customer_sales_type = CustomersModel.CUSTOMER_TYPE_BUYER;
			}
			else if( customer_sales_type_supplier.selected)
			{
				c.customer_sales_type = CustomersModel.CUSTOMER_TYPE_SUPPLIER;
			}
			
			c.customer_since = customer_since.text;
			c.customer_vat_value = uint( customer_vat_value.text );
			c.customer_tax_enabled = customer_tax_enabled.selectedValue;
			c.customer_telephone = customer_telephone.text;
			c.customer_telephone2 = customer_telephone2.text;
			c.customer_zip_code = uint( customer_zip_code.text );
			
			if( mode == CrudOperations.CREATE )
			{
				__customerModel.create( c, this );
			}
			else
			{
				__customerModel.update( c, this );
			}
		}
		
		override public function set data( d:Object ):void
		{
			super.data = d;
			_fillForm( d as CustomersVo );
		}

		protected function _fillForm( d:CustomersVo ):void
		{
			if( ! created )
				return;
			
			customer_id.text = d.customer_id;
			customer_address.text = d.customer_address;
			customer_bank_account.text = d.customer_bank_account;
			customer_bank_account2.text = d.customer_bank_account2
			customer_bank_account3.text = d.customer_bank_account3;
			customer_city.text = d.customer_city;
			customer_code.text = d.customer_code;
			customer_company_number.text = d.customer_company_number;   
			customer_company_tax_number.text = d.customer_company_tax_number;   
			customer_company_vat_number.text = d.customer_company_vat_number;   
			customer_contact_person.text = d.customer_contact_person;   
			
			FormHelper.setComboBoxSelectedValue( customer_country, "value", d.customer_country );  
			FormHelper.setComboBoxSelectedValue( customer_currency, "value", d.customer_currency ); 
			
			customer_credit_limit.text = d.customer_credit_limit.toString();   
			  
			customer_email_address.text = d.customer_email_address;   
			
			customer_mobile.text = d.customer_mobile;   
			customer_mobile2.text = d.customer_mobile2;   
			customer_name.text = d.customer_name;   
			customer_note.text = d.customer_note;   
			
			if( d.customer_sales_type == CustomersModel.CUSTOMER_TYPE_BOTH )
			{
				customer_sales_type_buyer.selected = true;
				customer_sales_type_supplier.selected  = true; 
			}
			else if( d.customer_sales_type == CustomersModel.CUSTOMER_TYPE_BUYER )
			{
				customer_sales_type_buyer.selected = true;
				customer_sales_type_supplier.selected  = false;
			}
			else if( d.customer_sales_type == CustomersModel.CUSTOMER_TYPE_SUPPLIER )
			{
				customer_sales_type_buyer.selected = false;
				customer_sales_type_supplier.selected  = true;
			}
			
			customer_since.text = d.customer_since;   
			customer_tax_enabled.selectedValue = d.customer_tax_enabled;
			customer_vat_value.text = d.customer_vat_value.toString();
			customer_telephone.text = d.customer_telephone;   
			customer_telephone2.text = d.customer_telephone2;   
			customer_zip_code.text= d.customer_zip_code.toString();   
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
			FormHelper.resetForm( customerForm1 );
			FormHelper.resetForm( customerForm2 );
		}
		
		override public function modelLoadingData(event:ModelDataChangeEvent):void
		{
			if( event.operationName == CustomersModel.CUSTOMERS_CREATE_OPERATION ||
				event.operationName == CustomersModel.CUSTOMERS_UPDATE_OPERATION )
			{
				super.modelLoadingData( event );
			}
		}
		
		override public function modelLoadingDataComplete(event:ModelDataChangeEvent):void
		{
			if( event.operationName == CustomersModel.CUSTOMERS_CREATE_OPERATION ||
				event.operationName == CustomersModel.CUSTOMERS_UPDATE_OPERATION )
			{
				
				super.modelLoadingDataComplete( event );
				
			}
		}
		
		override protected function _creationComplete(event:FlexEvent):void
		{
			super._creationComplete(event);
			
			if( mode == CrudOperations.UPDATE )
			{
				if( data )
					_fillForm( data as CustomersVo );
			}
		}
	}
}