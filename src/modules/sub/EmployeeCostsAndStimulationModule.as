package modules.sub
{
	import com.desktop.system.Application.Library.ui.FormHelper;
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.core.SystemModuleBase;
	import com.desktop.system.core.service.parsers.WebServiceParserDataType;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.events.NotificationResponseEvent;
	import com.desktop.system.vos.NotificationVo;
	import com.desktop.system.vos.ReadVo;
	import com.desktop.system.vos.SearchParameterVo;
	import com.desktop.ui.Components.Window.DesktopAlert;
	
	import factories.ModelFactory;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import interfaces.modules.sub.IEmployeeCostsAndStimulationsModule;
	
	import models.EmployeesModel;
	
	import mx.events.FlexEvent;
	
	import skins.Default.modules.sub.EmployeeCostsAndStimulationModuleSkin;
	
	import spark.components.Button;
	import spark.components.ComboBox;
	import spark.components.DataGrid;
	import spark.components.Label;
	import spark.components.TextInput;
	
	import vos.EmployeeCostAndStimulationsVo;
	import vos.EmployeeEconomicsVo;
	import vos.EmployeesVo;
	
	public class EmployeeCostsAndStimulationModule extends SystemModuleBase implements IEmployeeCostsAndStimulationsModule
	{
		private var __employees_model:EmployeesModel;
		
		[SkinPart(required="false")]
		public var emploeeNameLabel:Label;
		
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_year:ComboBox;
		
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_month:ComboBox;
		
		[SkinPart(required="false")]
		public var searchCostAndStimulationButton:Button;
		
		
		
		// phone
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_phone_limit:TextInput;
		
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_phone_cost:TextInput;
		
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_phone_total:TextInput;
		
		// internet
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_internet_limit:TextInput;
		
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_internet_cost:TextInput;
		
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_internet_total:TextInput;
		
		// car amortization
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_car_amortization_limit:TextInput;
		
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_car_amortization_cost:TextInput;
		
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_car_amortization_total:TextInput;
		
		
		// gas limit
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_gas_limit:TextInput;
		
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_gas_cost:TextInput;
		
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_gas_total:TextInput;
		
		// bonuess and penaltyies
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_bonus_type:ComboBox;
		
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_bonus_number:TextInput;
		
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_bonus_percent:TextInput;
		
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_penalty_type:ComboBox;
		
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_penalty_number:TextInput;
		
		[SkinPart(required="false")]
		public var employee_costs_and_stimulations_penalty_percent:TextInput;
		
		
		
		[SkinPart(required="false")]
		public var saveButton:Button;
		
		[SkinPart(required="false")]
		public var resetButton:Button;
		
		
		
		private var __employee:EmployeesVo;
		private var __emploeyee_economic:EmployeeEconomicsVo;
		private var __employee_cost_and_stimulation:EmployeeCostAndStimulationsVo;
		
		public function EmployeeCostsAndStimulationModule()
		{
			super();
			__employees_model = ModelFactory.employeesModel();
		}
		
		override public function init():void
		{
			super.init();
			setStyle( "skinClass", EmployeeCostsAndStimulationModuleSkin );
			//setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "employeeCostsAndStimulationModule", this.session.skinsLocaleName ) );
		}
		
		override public function set data( d:Object  ):void
		{
			__employee = d as EmployeesVo;

			if( __employee )
			{
				emploeeNameLabel.text = __employee.employee_name;
				
				if( created )
					__readEconomic();
				
				if( notifier )
					notifier.close();
			}
		}
			
		override protected function partAdded( partName:String, instance:Object ):void
		{
			super.partAdded( partName, instance );
			
			if( instance == employee_costs_and_stimulations_year )
			{
				employee_costs_and_stimulations_year.dataProvider = BaseModel.yearsDataProvider;
			}
			else if( instance == employee_costs_and_stimulations_month )
			{
				employee_costs_and_stimulations_month.dataProvider = BaseModel.monthsDataProvider;	
			}
			else if( instance == employee_costs_and_stimulations_bonus_type || instance == employee_costs_and_stimulations_penalty_type )
			{
				instance.dataProvider = EmployeesModel.employeeStimulationTypeDataProvider;
			}
			else if( instance == searchCostAndStimulationButton )
			{
				searchCostAndStimulationButton.addEventListener( MouseEvent.CLICK, _searchCostAndStimulationClickEventHandler );
			}
			else if( instance == saveButton )
			{
				saveButton.addEventListener( MouseEvent.CLICK, _saveButtonMouseClickEventHandler );
			}
			else if( instance == resetButton )
			{
				resetButton.addEventListener( MouseEvent.CLICK, _resetBttonClickHandler );	
			}
			else( instance is TextInput )
			{
				instance.addEventListener( Event.CHANGE, _textInputChangeEventHandler );
			}
		}
		
		protected function _resetBttonClickHandler( event:MouseEvent ):void
		{
			
		}
		
		protected function _saveButtonMouseClickEventHandler( event:MouseEvent ):void
		{
			var c:EmployeeCostAndStimulationsVo;
			var create:Boolean = false;
			
			if( __employee_cost_and_stimulation )
			{
				c = __employee_cost_and_stimulation;	
			}
			else
			{
				c = new EmployeeCostAndStimulationsVo();	
				create  = true;
			}
			
			c.employee_id = __employee.employee_id;
			
			c.employee_costs_and_stimulations_year = employee_costs_and_stimulations_year.selectedItem.value;
			c.employee_costs_and_stimulations_month = employee_costs_and_stimulations_month.selectedItem.value;
			
			c.employee_costs_and_stimulations_internet_limit = Number( employee_costs_and_stimulations_internet_limit.text );
			c.employee_costs_and_stimulations_internet_cost = Number( employee_costs_and_stimulations_internet_cost.text );
			c.employee_costs_and_stimulations_internet_total = Number( employee_costs_and_stimulations_internet_total.text ) || 0;
			
			c.employee_costs_and_stimulations_phone_limit = Number( employee_costs_and_stimulations_phone_limit.text );
			c.employee_costs_and_stimulations_phone_cost = Number( employee_costs_and_stimulations_phone_cost.text );
			c.employee_costs_and_stimulations_phone_total = Number( employee_costs_and_stimulations_phone_total.text ) || 0;
			
			c.employee_costs_and_stimulations_car_amortization_limit = Number( employee_costs_and_stimulations_car_amortization_limit.text );
			c.employee_costs_and_stimulations_car_amortization_cost = Number( employee_costs_and_stimulations_car_amortization_cost.text );
			c.employee_costs_and_stimulations_car_amortization_total = Number( employee_costs_and_stimulations_car_amortization_total.text ) || 0;
			
			c.employee_costs_and_stimulations_gas_limit = Number( employee_costs_and_stimulations_gas_limit.text );
			c.employee_costs_and_stimulations_gas_cost = Number( employee_costs_and_stimulations_gas_cost.text );
			c.employee_costs_and_stimulations_gas_total = Number( employee_costs_and_stimulations_gas_total.text ) || 0;
			
			c.employee_costs_and_stimulations_bonus_type = employee_costs_and_stimulations_bonus_type.selectedItem.value;
			c.employee_costs_and_stimulations_penalty_type = employee_costs_and_stimulations_penalty_type.selectedItem.value;
			
			c.employee_costs_and_stimulations_bonus_number =  Number( employee_costs_and_stimulations_bonus_number.text ) || 0;
			c.employee_costs_and_stimulations_bonus_percent = Number( employee_costs_and_stimulations_bonus_percent.text ) || 0;
			
			c.employee_costs_and_stimulations_penalty_number =  Number( employee_costs_and_stimulations_penalty_number.text ) || 0;
			c.employee_costs_and_stimulations_penalty_percent = Number( employee_costs_and_stimulations_penalty_percent.text ) || 0;
			
			c.employee_costs_and_stimulations_cost_total = c.employee_costs_and_stimulations_internet_cost +
														   c.employee_costs_and_stimulations_car_amortization_cost +
														   c.employee_costs_and_stimulations_gas_cost + 
														   c.employee_costs_and_stimulations_phone_cost;
			
			c.employee_costs_and_stimulations_limit_total = c.employee_costs_and_stimulations_car_amortization_limit +
															c.employee_costs_and_stimulations_gas_limit + 
															c.employee_costs_and_stimulations_internet_limit + 
															c.employee_costs_and_stimulations_phone_limit;
			
			c.employee_costs_and_stimulations_total_total = c.employee_costs_and_stimulations_limit_total - c.employee_costs_and_stimulations_cost_total;
			
			
			__employees_model.saveCostAndStimulation( c, this );
			
		}
		
		protected function _fillForm( ec:EmployeeCostAndStimulationsVo ):void
		{
			if( ec )
			{
				employee_costs_and_stimulations_internet_cost.text = ec.employee_costs_and_stimulations_internet_cost.toString();
				employee_costs_and_stimulations_internet_limit.text = ec.employee_costs_and_stimulations_internet_limit.toString();
				employee_costs_and_stimulations_internet_total.text = ec.employee_costs_and_stimulations_internet_total.toString();
				
				employee_costs_and_stimulations_phone_cost.text = ec.employee_costs_and_stimulations_phone_cost.toString();
				employee_costs_and_stimulations_phone_limit.text = ec.employee_costs_and_stimulations_phone_limit.toString();
				employee_costs_and_stimulations_phone_total.text = ec.employee_costs_and_stimulations_phone_total.toString();
				
				employee_costs_and_stimulations_gas_cost.text = ec.employee_costs_and_stimulations_gas_cost.toString();
				employee_costs_and_stimulations_gas_limit.text = ec.employee_costs_and_stimulations_gas_limit.toString();
				employee_costs_and_stimulations_gas_total.text = ec.employee_costs_and_stimulations_gas_total.toString();
				
				employee_costs_and_stimulations_car_amortization_cost.text = ec.employee_costs_and_stimulations_car_amortization_cost.toString();
				employee_costs_and_stimulations_car_amortization_limit.text = ec.employee_costs_and_stimulations_car_amortization_limit.toString();
				employee_costs_and_stimulations_car_amortization_total.text = ec.employee_costs_and_stimulations_car_amortization_total.toString();
				
				FormHelper.setComboBoxSelectedValue( employee_costs_and_stimulations_bonus_type, 'value', ec.employee_costs_and_stimulations_bonus_type );
				FormHelper.setComboBoxSelectedValue( employee_costs_and_stimulations_penalty_type, 'value', ec.employee_costs_and_stimulations_penalty_type );
				
				employee_costs_and_stimulations_bonus_number.text = ec.employee_costs_and_stimulations_bonus_number.toString();
				employee_costs_and_stimulations_bonus_percent.text = ec.employee_costs_and_stimulations_bonus_percent.toString();
				
				employee_costs_and_stimulations_penalty_number.text = ec.employee_costs_and_stimulations_penalty_number.toString();
				employee_costs_and_stimulations_penalty_percent.text = ec.employee_costs_and_stimulations_penalty_percent.toString();
			}
		}
		
		override public function modelLoadingDataComplete(event:ModelDataChangeEvent):void
		{
			super.modelLoadingDataComplete( event );
			
			if( event.operationName == EmployeesModel.EMPLOYEE_READ_COST_AND_STIMULATION_OPERATION )
			{
				__employee_cost_and_stimulation = event.response.result as EmployeeCostAndStimulationsVo;
				_fillForm( __employee_cost_and_stimulation );
			}
			else if( event.operationName == EmployeesModel.EMPLOYEE_READ_ECONOMICS_OPERATION )
			{
				__emploeyee_economic = event.response.result as EmployeeEconomicsVo;
				
				if( __emploeyee_economic )
				{
					employee_costs_and_stimulations_phone_limit.text = String( __emploeyee_economic.employee_business_phone_limit );
					employee_costs_and_stimulations_internet_limit.text = String( __emploeyee_economic.employee_business_phone_limit );
					employee_costs_and_stimulations_car_amortization_limit.text = String( __emploeyee_economic.employee_business_phone_limit );
					employee_costs_and_stimulations_gas_limit.text = String( __emploeyee_economic.employee_business_phone_limit );
				}
				else
				{
					// @todo set notification about error
				}
				
			}
		}
		
		override public function modelLoadingData(event:ModelDataChangeEvent):void
		{
			super.modelLoadingData( event );
		}
		
		protected function _searchCostAndStimulationClickEventHandler( event:MouseEvent ):void
		{
			if( employee_costs_and_stimulations_month.selectedItem && employee_costs_and_stimulations_year.selectedItem )
			{
				var r:ReadVo = new ReadVo();
					r.is_search = true;
					r.data_type = WebServiceParserDataType.CUSTOM_OBJECT;
					r.search_paramters = [ 	new SearchParameterVo( "employee_id", __employee.employee_id ),
									   		new SearchParameterVo( "employee_costs_and_stimulations_year", employee_costs_and_stimulations_year.selectedItem.value ),
									   		new SearchParameterVo( "employee_costs_and_stimulations_month", employee_costs_and_stimulations_month.selectedItem.value ),
									 	];
				
				__employees_model.readCostAndStimulation( r, this );
			}
		}
		
		protected function _textInputChangeEventHandler( event:Event ):void
		{
			var t:TextInput = event.target as TextInput;
			
			if( ! t ) return;
			
			if( t.id.indexOf( "limit" ) != -1 || t.id.indexOf( "cost" ) != -1 )
			{
				if( t.id.indexOf( "internet" ) != -1 )
				{
					employee_costs_and_stimulations_internet_total.text = String( Number( employee_costs_and_stimulations_internet_limit.text ) - Number( employee_costs_and_stimulations_internet_cost.text ) );  
				}
				else if( t.id.indexOf( "phone" ) != -1 )
				{
					employee_costs_and_stimulations_phone_total.text = String( Number( employee_costs_and_stimulations_phone_limit.text ) - Number( employee_costs_and_stimulations_phone_cost.text ) );
				}
				else if( t.id.indexOf( "car_amortization" ) != -1 )
				{
					employee_costs_and_stimulations_car_amortization_total.text = String( Number( employee_costs_and_stimulations_car_amortization_limit.text ) - Number( employee_costs_and_stimulations_car_amortization_cost.text ) );
				}
				else if( t.id.indexOf( "gas" ) != -1 )
				{
					employee_costs_and_stimulations_gas_total.text = String( Number( employee_costs_and_stimulations_gas_limit.text ) - Number( employee_costs_and_stimulations_gas_cost.text ) );
				}
			}
		}
		
		override protected function _notificationResponseEvent(event:NotificationResponseEvent):void
		{
			if( event.response.buttonPressed == DesktopAlert.OK && event.notificationVo.id == EmployeesModel.EMPLOYEE_READ_ECONOMICS_OPERATION )
			{
				__readEconomic();
			}
		}
		
		override protected function _creationComplete(event:FlexEvent):void
		{
			super._creationComplete( event );
			
			if( ! __employee )
			{
				var nvo:NotificationVo = new NotificationVo();
					nvo.icon = resourceManager.getClass( 'systemIconClasses', 'infoIcon', session.skinsLocaleName );
					nvo.title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "info" );
					nvo.text = resourceManager.getString( this.session.config.LOCALE_CONFIG.messagesResourceName, "employeeNotSelected" );
				
				notify( nvo );
				return;
			}
			
			__readEconomic();
		}
		
		private function __readEconomic():void
		{
			if( __employee )
			{
				var r:ReadVo = new ReadVo();
					r.is_search = true;
					r.data_type = WebServiceParserDataType.CUSTOM_OBJECT;
					r.search_paramters = [ new SearchParameterVo( "employee_economics_id", __employee.employee_economics_id  ) ];
				
				__employees_model.readEconomics( r, this );	
			}
		}
	}
}