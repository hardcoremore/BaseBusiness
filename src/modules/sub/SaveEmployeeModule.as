package modules.sub
{
	import com.desktop.system.core.SystemModuleBase;
	import com.desktop.system.Application.Library.ui.FormHelper;
	import com.desktop.system.Application.Library.ui.SkinBase;
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.utility.CrudOperations;
	import com.desktop.ui.Components.Group.LoadingContainer;
	
	import components.app.SaveData;
	import components.events.SaveDataEvent;
	
	import factories.ModelFactory;
	
	import flash.events.MouseEvent;
	
	import interfaces.modules.sub.ISaveEmployeeModule;
	
	import models.EmployeesModel;
	
	import mx.collections.IList;
	import mx.controls.DateField;
	import mx.events.FlexEvent;
	
	import spark.components.Button;
	import spark.components.CheckBox;
	import spark.components.ComboBox;
	import spark.components.Form;
	import spark.components.Label;
	import spark.components.RadioButtonGroup;
	import spark.components.TextArea;
	import spark.components.TextInput;
	
	import vos.EmployeesVo;

	public class SaveEmployeeModule extends SystemModuleBase implements ISaveEmployeeModule
	{
		[SkinPart(required="true")]
		public var employeeForm1:Form;
		
		[SkinPart(required="true")]
		public var employeeForm2:Form;
		
		[SkinPart(required="false")]
		public var employee_id:TextInput;
		
		[SkinPart(required="false")]
		public var employee_code:TextInput;
		
		[SkinPart(required="false")]
		public var employee_name:TextInput;
		
		[SkinPart(required="false")]
		public var employee_last_name:TextInput;
		
		[SkinPart(required="false")]
		public var employee_gender:RadioButtonGroup;
		
		[SkinPart(required="false")]
		public var employee_address:TextInput;
		
		[SkinPart(required="false")]
		public var employee_birth_date:DateField;
		
		[SkinPart(required="false")]
		public var employee_social_security_number:TextInput;
		
		[SkinPart(required="false")]
		public var employee_personal_number:TextInput;
		
		[SkinPart(required="false")]
		public var employee_passport_number:TextInput;
		
		[SkinPart(required="false")]
		public var employee_hired:RadioButtonGroup;
		
		[SkinPart(required="false")]
		public var employee_hire_date:DateField;
		
		[SkinPart(required="false")]
		public var employee_fire_date:DateField;
		
		[SkinPart(required="false")]
		public var employee_title:TextInput;
		
		[SkinPart(required="false")]
		public var employee_personal_email:TextInput;
		
		[SkinPart(required="false")]
		public var employee_personal_phone:TextInput;
		
		[SkinPart(required="false")]
		public var employee_business_email:TextInput;
		
		[SkinPart(required="false")]
		public var employee_business_phone:TextInput;
		
		[SkinPart(required="false")]
		public var employee_business_phone_extension:TextInput;
		
		[SkinPart(required="false")]
		public var customer_company_tax_number:TextInput;
		
		[SkinPart(required="false")]
		public var customer_country:ComboBox;
		
		
		[SkinPart(required="false")]
		public var employee_contract_type:ComboBox;
		
		
		[SkinPart(required="false")]
		public var employee_working_scenario_id:ComboBox;
		
		[SkinPart(required="false")]
		public var employee_economics_id:ComboBox;
		
		[SkinPart(required="false")]
		public var employee_note:TextArea;
		
		
		private var __employeesModel:EmployeesModel;
		
		public function SaveEmployeeModule()
		{
			super();
			__employeesModel = ModelFactory.employeesModel();
		}
		
		override public function init():void
		{
			super.init();
			setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "saveEmployeeModule", this.session.skinsLocaleName ) );
			
			__employeesModel.addEventListener( ModelDataChangeEvent.MODEL_LOADING_DATA, _modelLoadingDataEventHandler );
			__employeesModel.addEventListener( ModelDataChangeEvent.MODEL_LOADING_DATA_COMPLETE, _modelLoadingDataCompleteEventHandler );
		}
		
		public function get saveDataComponent():SaveData
		{
			return saveDataCmp;
		}
		
		
		protected function _fillForm( employee:EmployeesVo ):void
		{
			if( ! created || ! employee )
				return;
			
			FormHelper.setComboBoxSelectedValue( employee_working_scenario_id, "employee_working_scenario_id", employee.employee_working_scenario_id );
		    
			employee_id.text = employee.employee_id;
			employee_address.text = employee.employee_address;    
			employee_birth_date.text = employee.employee_birth_date;  
			employee_business_email.text = employee.employee_business_email;  
			employee_business_phone.text = employee.employee_business_phone;  
			employee_business_phone_extension.text =  employee.employee_business_phone_extension;  
			employee_code.text = employee.employee_code;  
			employee_fire_date.text = employee.employee_fire_date;  
			employee_gender.selectedValue = employee.employee_gender;  
			employee_hire_date.text = employee.employee_hire_date;  
			employee_hired.selectedValue =  employee.employee_hired;  
			employee_last_name.text = employee.employee_last_name;  
			employee_name.text = employee.employee_name;  
			employee_passport_number.text = employee.employee_passport_number;  
			employee_personal_email.text = employee.employee_personal_email;  
			employee_personal_number.text = employee.employee_personal_number;  
			employee_personal_phone.text = employee.employee_personal_phone;
			employee_social_security_number.text = employee.employee_social_security_number;  
			employee_title.text = employee.employee_title;  
			
			FormHelper.setComboBoxSelectedValue( employee_contract_type, "value", employee.employee_contract_type );
			FormHelper.setComboBoxSelectedValue( employee_working_scenario_id, "employee_working_scenario_id", employee.employee_working_scenario_id );
			FormHelper.setComboBoxSelectedValue( employee_economics_id, "employee_economics_id", employee.employee_economics_id );
			
			
			employee_hired.selectedValue = employee.employee_hired;
			employee_gender.selectedValue = employee.employee_gender;
			
		}
		
		override public function set data( d:Object ):void
		{
			super.data = d;
			_fillForm( d as EmployeesVo );
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if( instance == saveDataCmp )
			{
				saveDataCmp.addEventListener( SaveDataEvent.SAVE_DATA, _saveEmployeeEventHandler );
				saveDataCmp.addEventListener( SaveDataEvent.RESET_DATA, _resetCustomerFormEventHandler );
			}
			else if( instance == employee_working_scenario_id )
			{
				employee_working_scenario_id.labelField = "employee_working_scenario_name";
			}
			else if( instance == employee_contract_type )
			{
				employee_contract_type.labelField = "label";
				employee_contract_type.dataProvider = EmployeesModel.contractTypeDataProvider;
			}
			else if( instance == employee_economics_id )
			{
				employee_economics_id.labelField = "employee_economics_name";
			}
		}
		
		public function _saveEmployeeEventHandler( event:SaveDataEvent ):void
		{
			var e:EmployeesVo;
			
				if( mode == CrudOperations.CREATE )
				{
					e = new EmployeesVo();
				}
				else if( mode == CrudOperations.UPDATE )
				{
					e = data as EmployeesVo;
				}
				
				if( employee_working_scenario_id.selectedItem )
					e.employee_working_scenario_id = employee_working_scenario_id.selectedItem.employee_working_scenario_id;
				
				e.employee_address  = employee_address.text;
				e.employee_birth_date = employee_birth_date.text;
				e.employee_business_email = employee_business_email.text;
				e.employee_business_phone = employee_business_phone.text;
				e.employee_business_phone_extension = employee_business_phone_extension.text;
				e.employee_code = employee_code.text;
				e.employee_fire_date = employee_fire_date.text;
				e.employee_gender = uint( employee_gender.selectedValue );
				e.employee_hire_date = employee_hire_date.text;
				
				e.employee_hired = uint( employee_hired.selectedValue );
				
				e.employee_last_name = employee_last_name.text;
				e.employee_name = employee_name.text;
				
				e.employee_passport_number = employee_passport_number.text;
				e.employee_personal_email = employee_personal_email.text;
				e.employee_personal_number = employee_personal_number.text;
				e.employee_personal_phone = employee_personal_phone.text;	
				 
				
				e.employee_social_security_number = employee_social_security_number.text;
				e.employee_title = employee_title.text;	
				
				if( employee_contract_type.selectedItem )
					e.employee_contract_type = uint( employee_contract_type.selectedItem.value );
				
				if( employee_economics_id.selectedItem )
					e.employee_economics_id = employee_economics_id.selectedItem.employee_economics_id;
				
			if( mode == CrudOperations.CREATE )
			{
				__employeesModel.create( e, this );
			}
			else
			{
				__employeesModel.update( e, this );
			}
		}
		
		protected function _resetCustomerFormEventHandler( event:SaveDataEvent ):void
		{
			FormHelper.resetForm( employeeForm1 );
			FormHelper.resetForm( employeeForm2 );
		}
		
		override public function modelLoadingData(event:ModelDataChangeEvent):void
		{
			if( event.operationName == EmployeesModel.EMPLOYEE_READ_WS_OPERATION )
			{
				if( employee_working_scenario_id )
					setLoadingComboBox( employee_working_scenario_id );
			}
			else if( event.operationName == EmployeesModel.EMPLOYEE_READ_ECONOMICS_OPERATION )
			{
				if( employee_economics_id )
					setLoadingComboBox( employee_economics_id );
			}
			else if( event.operationName == EmployeesModel.EMPLOYEE_CREATE_OPERATION || 
				event.operationName == EmployeesModel.EMPLOYEE_UPDATE_OPERATION
			)
			{
				super.modelLoadingData(event);
			}
		}
		
		protected function _modelLoadingDataEventHandler( event:ModelDataChangeEvent ):void
		{
			if( event.operationName == EmployeesModel.EMPLOYEE_READ_WS_OPERATION )
			{
				if( employee_working_scenario_id )
					setLoadingComboBox( employee_working_scenario_id );
			}
			else if( event.operationName == EmployeesModel.EMPLOYEE_READ_ECONOMICS_SELECT_OPERATION )
			{
				if( employee_economics_id )
					setLoadingComboBox( employee_economics_id );
			}
		}
		
		protected function _modelLoadingDataCompleteEventHandler( event:ModelDataChangeEvent ):void
		{
			if( event.operationName == EmployeesModel.EMPLOYEE_CREATE_WS_OPERATION||
				event.operationName == EmployeesModel.EMPLOYEE_UPDATE_WS_OPERATION )
			{
				__employeesModel.readWorkingScenarios( this );
			}
			else if( event.operationName == EmployeesModel.EMPLOYEE_READ_ECONOMICS_SELECT_OPERATION && event.requester != this )
			{
				_updateReadData( event.response, employee_economics_id );
				
				if( data && data is EmployeesVo )
				{
					FormHelper.setComboBoxSelectedValue( employee_economics_id, "employee_economics_id", ( data as EmployeesVo ).employee_economics_id );
				}
			}
		}
		
		override public function modelLoadingDataComplete(event:ModelDataChangeEvent):void
		{
			if( loadingContainer )
				loadingContainer.loading = false;
			
			if( event.operationName == EmployeesModel.EMPLOYEE_READ_WS_OPERATION )
			{
				_updateReadData( event.response, employee_working_scenario_id );
				
				if( data && data is EmployeesVo )
				{
					FormHelper.setComboBoxSelectedValue( employee_working_scenario_id, "employee_working_scenario_id", ( data as EmployeesVo ).employee_working_scenario_id );
				}
			}
			else if( event.operationName == EmployeesModel.EMPLOYEE_READ_ECONOMICS_SELECT_OPERATION )
			{
				_updateReadData( event.response, employee_economics_id );
				
				if( data && data is EmployeesVo )
				{
					FormHelper.setComboBoxSelectedValue( employee_economics_id, "employee_economics_id", ( data as EmployeesVo ).employee_economics_id );
				}
			}
		}
		
		override protected function _creationComplete(event:FlexEvent):void
		{
			super._creationComplete(event);
			
			__employeesModel.readWorkingScenarios( this );
			__employeesModel.readEconomicsForSelect( this );
			
			if( mode == CrudOperations.UPDATE )
			{
				_fillForm( data as EmployeesVo );
			}
		}
	}
}