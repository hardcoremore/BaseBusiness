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
	
	import vos.EmployeeCostAndStimulationsVo;
	import vos.EmployeeEconomicsVo;
	import vos.EmployeeWorkDayVo;
	import vos.EmployeeWorkSheetVo;
	import vos.EmployeeWorkingScenarioVo;
	import vos.EmployeesVo;
	import vos.EmployeesWorkingScenarioDayVo;
	import vos.SaveWorkingScenarioVo;
	
	public class EmployeesModel extends BaseModel
	{
		
		// employees
		public static const EMPLOYEE_READ_OPERATION:String = "read";
		public static const EMPLOYEE_CREATE_OPERATION:String = "create";
		public static const EMPLOYEE_UPDATE_OPERATION:String = "update";
		
		// economics
		public static const EMPLOYEE_READ_ECONOMICS_OPERATION:String = "readEconomics";
		public static const EMPLOYEE_READ_ECONOMICS_SELECT_OPERATION:String = "readEconomicsForSelect";
		public static const EMPLOYEE_CREATE_ECONOMIC_OPERATION:String = "createEconomic";
		public static const EMPLOYEE_UPDATE_ECONOMIC_OPERATION:String = "updateEconomic";
		public static const EMPLOYEE_UPDATE_ECONOMIC_FIELD_OPERATION:String = "updateEconomicField";
		
		// cost and stimulation
		public static const EMPLOYEE_READ_COST_AND_STIMULATION_OPERATION:String = "readCostAndStimulation";				
		public static const EMPLOYEE_SAVE_COST_AND_STIMULATION_OPERATION:String = "saveCostAndStimulation";
		
		
		
		// working scenario
		public static const EMPLOYEE_CREATE_WS_OPERATION:String = "createWorkingScenario";
		public static const EMPLOYEE_READ_WS_OPERATION:String = "readWorkingScenarios";
		public static const EMPLOYEE_UPDATE_WS_OPERATION:String  = "updateWorkingScenario";
		public static const EMPLOYEE_READ_WS_DETAILS_OPERATION:String = "readWorkingScenarioDetails";
		
		public static const EMPLOYEES_WS_UPDATED:String  = "employeesWorkingScenariosUpdated";
		
		// work sheet
		public static const EMPLOYEE_CREATE_WORK_SHEET_OPERATION:String = "createWorkSheet";
		public static const EMPLOYEE_READ_WORK_SHEET_OPERATION:String = "readWorkSheets";
		public static const EMPLOYEE_UPDATE_WORK_SHEET_OPERATION:String  = "updateWorkSheet";
		public static const EMPLOYEE_READ_WORK_SHEET_DAYS_OPERATION:String = "readWorkSheetDays";
		
		public static const EMPLOYEE_CONTRACT_TYPE_NONE:uint = 0;
		public static const EMPLOYEE_CONTRACT_TYPE_ALL_TIME:uint = 1;
		public static const EMPLOYEE_CONTRACT_TYPE_TEMP:uint = 2;
		public static const EMPLOYEE_CONTRACT_TYPE_FREE_LANCE:uint = 3;
		public static const EMPLOYEE_CONTRACT_TYPE_VOLUNTEER:uint = 4;
		
		public static const EMPLOYEE_CONTRACT_EVENT_TYPE_HIRED:uint = 1;
		public static const EMPLOYEE_CONTRACT_EVENT_TYPE_CHANGED:uint = 2;
		public static const EMPLOYEE_CONTRACT_EVENT_TYPE_FIRED:uint = 3;
		
		public static const EMPLOYEE_WORK_DAY_TYPE_NORMAL:uint = 1;
		public static const EMPLOYEE_WORK_DAY_TYPE_BUSSINESS_TRIP:uint = 2;
		public static const EMPLOYEE_WORK_DAY_TYPE_SICK:uint = 3;
		public static const EMPLOYEE_WORK_DAY_TYPE_NOT_WORKING:uint = 4;
		public static const EMPLOYEE_WORK_DAY_TYPE_VACATION :uint = 5;
		
		public static const EMPLOYEE_STIMULATION_TYPE_NONE:uint = 0;
		public static const EMPLOYEE_STIMULATION_TYPE_NUMBER:uint = 1;
		public static const EMPLOYEE_STIMULATION_TYPE_PERCENT:uint = 2;
		
		public static const EMPLOYEES_DATA_HOLDER_ID:String = "employeesDataHolder";
		
		private var __readService:ServiceLoader;
		private var __updateService:ServiceLoader;
		private var __createService:ServiceLoader;
		
		private var __createWSService:ServiceLoader;
		private var __readWSService:ServiceLoader;
		private var __updateWSService:ServiceLoader;
		
		
		private var __workingScenarios:ModelOperationResponseVo;
		private var __employeeEconomics:ModelOperationResponseVo;
		
		private var __current_economic_update_field:UpdateTableFieldVo;
		
		public function EmployeesModel( resourceConfigVo:ResourceConfigVo, target:IEventDispatcher=null)
		{
			super( resourceConfigVo, target);
			
			EmployeesVo;
			EmployeesWorkingScenarioDayVo;
			EmployeeWorkingScenarioVo;
			
			__workingScenarios = new ModelOperationResponseVo();
			
		}
		
		private static var __workDayTypeDataProvider:ArrayList;
		public static function get employeeWorkDayTypeDataProvider():IList
		{
			if( ! __workDayTypeDataProvider )
			{
				__workDayTypeDataProvider = new ArrayList();
				__workDayTypeDataProvider.addItem( { value: EMPLOYEE_WORK_DAY_TYPE_NORMAL, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'normalWorkDay') } );
				__workDayTypeDataProvider.addItem( { value: EMPLOYEE_WORK_DAY_TYPE_BUSSINESS_TRIP, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'businessTrip') } );
				__workDayTypeDataProvider.addItem( { value: EMPLOYEE_WORK_DAY_TYPE_SICK, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'sick') } );
				__workDayTypeDataProvider.addItem( { value: EMPLOYEE_WORK_DAY_TYPE_NOT_WORKING, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'doesntWork') } );
				__workDayTypeDataProvider.addItem( { value: EMPLOYEE_WORK_DAY_TYPE_VACATION, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'vacation') } );
			}
			
			return __workDayTypeDataProvider;
		}
		
		private static var __contractTypeDataProvider:ArrayList;
		public static function get contractTypeDataProvider():ArrayList
		{
			if( ! __contractTypeDataProvider )
			{
				__contractTypeDataProvider = new ArrayList();
				__contractTypeDataProvider.addItem( { value: EMPLOYEE_CONTRACT_TYPE_NONE, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'notAvailable') } );
				__contractTypeDataProvider.addItem( { value: EMPLOYEE_CONTRACT_TYPE_ALL_TIME, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'contractTypeNormal') } );
				__contractTypeDataProvider.addItem( { value: EMPLOYEE_CONTRACT_TYPE_TEMP, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'contractTypeTemp') } );
				__contractTypeDataProvider.addItem( { value: EMPLOYEE_CONTRACT_TYPE_FREE_LANCE, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'contractTypeFreeLance') } );
				__contractTypeDataProvider.addItem( { value: EMPLOYEE_CONTRACT_TYPE_VOLUNTEER, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'contractTypeVolunteer') } );
			}
			
			return __contractTypeDataProvider;
		}
		
		private static var __employeeStimulationTypeDataProvider:ArrayList;
		public static function get employeeStimulationTypeDataProvider():ArrayList
		{
			if( ! __employeeStimulationTypeDataProvider )
			{
				__employeeStimulationTypeDataProvider = new ArrayList();
				__employeeStimulationTypeDataProvider.addItem( { value: EMPLOYEE_STIMULATION_TYPE_NONE, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'notAvailable') } );
				__employeeStimulationTypeDataProvider.addItem( { value: EMPLOYEE_STIMULATION_TYPE_NUMBER, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'fixed') } );
				__employeeStimulationTypeDataProvider.addItem( { value: EMPLOYEE_STIMULATION_TYPE_PERCENT, label: resourceManager.getString( session.config.LOCALE_CONFIG.dictonaryResourceName, 'percent' ) } );
			}
			
			return __employeeStimulationTypeDataProvider;
		}
		
		// EMPLOYEES
		public function create( employee:EmployeesVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
				
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_CREATE_OPERATION;
			
			web.data = _getUrlVariablesFromVo( employee );
			
			_startOperation( web, service );
		}
		
		public function read( read:ReadVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
				
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_READ_OPERATION;
				
				web.voClasses = new Object();
			    web.voClasses.EmployeesVo = "vos.EmployeesVo";
				
			web.data = _getUrlVariablesFromVo( read );
			
			_startOperation( web, service );	
			
		}
				
		public function update( employee:EmployeesVo, requester:IServiceReqester  ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
				
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_UPDATE_OPERATION;
			
			web.data = _getUrlVariablesFromVo( employee );
			
			_startOperation( web, service );
		}
	
		// ECONOMICS
		public function createEconomic( employeeEconomic:EmployeeEconomicsVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
			service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_CREATE_ECONOMIC_OPERATION;
				
				web.voClasses = new Object();
				web.voClasses.EmployeeEconomicsVo = "vos.EmployeeEconomicsVo";
			
			web.data = _getUrlVariablesFromVo( employeeEconomic );
			
			_startOperation( web, service );
		}
		
		public function readEconomics( read:ReadVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_READ_ECONOMICS_OPERATION;
				
				web.voClasses = new Object();
				web.voClasses.EmployeeEconomicsVo = "vos.EmployeeEconomicsVo";
			
			web.data = _getUrlVariablesFromVo( read );
			
			_startOperation( web, service );	
			
		}
		
		public function readEconomicsForSelect( requester:IServiceReqester ):void
		{
			if( __employeeEconomics )
			{
				var e:ModelDataChangeEvent = new ModelDataChangeEvent( ModelDataChangeEvent.MODEL_LOADING_DATA_COMPLETE );
					e.operationName =  EMPLOYEE_READ_ECONOMICS_SELECT_OPERATION;
					e.response = __employeeEconomics;
					e.requester = requester;
				
				dispatchEvent( e );
				
				if( requester )
					requester.modelLoadingDataComplete( e );
			}
			
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_READ_ECONOMICS_SELECT_OPERATION;
			
			web.voClasses = new Object();
			web.voClasses.EmployeeEconomicsVo = "vos.EmployeeEconomicsVo";
			
			_startOperation( web, service );
		}
			
		public function updateEconomic( employeeEconomic:EmployeeEconomicsVo, requester:IServiceReqester  ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_UPDATE_ECONOMIC_OPERATION;
			
			web.data = _getUrlVariablesFromVo( employeeEconomic );
			
			_startOperation( web, service );
		}
		
		public function updateEconomicField( update:UpdateTableFieldVo, requester:IServiceReqester ):void
		{
			__current_economic_update_field = update;
			
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_UPDATE_ECONOMIC_FIELD_OPERATION;
			
			web.data = _getUrlVariablesFromVo( update );
			
			_startOperation( web, service );
		}
		
		// WORKING SCENARIO
		public function createWorkingScenario( ws:SaveWorkingScenarioVo, requester:IServiceReqester ):void
		{	
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
				
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_CREATE_WS_OPERATION;
			
			var data:URLVariables = buildUrlVarialbesFromAssociateArray( ws.working_days, "_working_days_" );	
				data.employee_working_scenario_name = ws.employee_working_scenario_name;
				
				web.data = data;
				
			_startOperation( web, service );
		}
		
		public function readWorkingScenarios( requester:IServiceReqester ):void
		{
			var e:ModelDataChangeEvent;
			
			if( __workingScenarios.status == STATUS_OK && ! __workingScenarios.dataUpdated )
			{
				e = new ModelDataChangeEvent( ModelDataChangeEvent.MODEL_LOADING_DATA_COMPLETE );
				e.operationName =  EMPLOYEE_READ_WS_OPERATION;
				e.response = __workingScenarios;
				e.requester = requester;
				
				dispatchEvent( e );
				
				if( requester )
					requester.modelLoadingDataComplete( e );
			}
			
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
				
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_READ_WS_OPERATION;
				
				web.voClasses = new Object();
				web.voClasses.EmployeeWorkingScenarioVo = "vos.EmployeeWorkingScenarioVo"; 
					
			_startOperation( web, service );
		}
		
		public function updateWorkingScenario( ws:SaveWorkingScenarioVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
				
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_UPDATE_WS_OPERATION;
			
			var data:URLVariables = buildUrlVarialbesFromAssociateArray( ws.working_days, "_working_days_" );	
				data.employee_working_scenario_name = ws.employee_working_scenario_name;
				data.employee_working_scenario_id = ws.employee_working_scenario_id;
					
			web.data = data;
			
			_startOperation( web, service );
		}
		
		public function readWorkingScenarioDetails( id:String, requester:IServiceReqester ):void
		{
			
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
				
				
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_READ_WS_DETAILS_OPERATION;
				
				web.voClasses = new Object();
				web.voClasses.EmployeesWorkingScenarioDayVo = "vos.EmployeesWorkingScenarioDayVo";
				
				var s:Vector.<String> = new Vector.<String>();
					s.push( id );
					
				web.segments = s;
			
			_startOperation( web, service );
		}
		
		public function getWorkScenarioDayVoFromWorkScenario( workScenarioDayList:IList, day:uint ):EmployeesWorkingScenarioDayVo
		{
			var wd:EmployeesWorkingScenarioDayVo;
			
			for( var i:uint = 0; i < workScenarioDayList.length; i++ )
			{
				wd = workScenarioDayList.getItemAt( i ) as EmployeesWorkingScenarioDayVo;
				
				if( wd.employees_working_scenario_day == day )
				{
					return wd;
				}
			}
			
			return null;
		}
		
		
		// COST AND STIMULATION
		public function saveCostAndStimulation( costAndStimulation:EmployeeCostAndStimulationsVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_SAVE_COST_AND_STIMULATION_OPERATION;
			
				web.voClasses = new Object();
				web.voClasses.EmployeeCostAndStimulationsVo = "vos.EmployeeCostAndStimulationsVo";
			
				web.data = _getUrlVariablesFromVo( costAndStimulation );
			
			_startOperation( web, service );
		}
		
		public function readCostAndStimulation( read:ReadVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_READ_COST_AND_STIMULATION_OPERATION;
			
				web.voClasses = new Object();
				web.voClasses.EmployeeCostAndStimulationsVo = "vos.EmployeeCostAndStimulationsVo";
			
				web.data = _getUrlVariablesFromVo( read );
			
			_startOperation( web, service );	
		}
		
		
		// WORK SHEET
		public function getDayTypeColor( dayType:uint ):uint
		{
			switch( dayType )
			{
				case EMPLOYEE_WORK_DAY_TYPE_NORMAL:
					return 0xFFFFFF;
				break;
				
				case EMPLOYEE_WORK_DAY_TYPE_BUSSINESS_TRIP:
					return 0x0079e0;
				break;
				
				case EMPLOYEE_WORK_DAY_TYPE_SICK:
					return 0xd8e500;
				break;
				
				case EMPLOYEE_WORK_DAY_TYPE_NOT_WORKING:
					return 0xFF0000;
				break;
				
				case EMPLOYEE_WORK_DAY_TYPE_VACATION:
					return 0x00e0a9;
				break;
			}
			
			return 0xFFFFFF;	
		}
		
		public function createWorkSheet( workSheet:EmployeeWorkSheetVo, days:Array, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_CREATE_WORK_SHEET_OPERATION;
				
				web.voClasses = new Object();
				web.voClasses.EmployeeWorkSheetVo = 'vos.EmployeeWorkSheetVo';
					
			var data:URLVariables = buildUrlVarialbesFromAssociateArray( days, "_work_sheet_days_" );	
		
			SystemUtility.copyData( workSheet, data );
			
			web.data = data;
			
			_startOperation( web, service );
		}
		
		public function readWorkSheets( read:ReadVo, employeeId:String, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_READ_WORK_SHEET_OPERATION;
				
				web.voClasses = new Object();
				web.voClasses.EmployeeWorkSheetVo = "vos.EmployeeWorkSheetVo";
				
				web.data = _getUrlVariablesFromVo( read );
				web.data.employee_id = employeeId;	
				
			_startOperation( web, service );	
		}
		
		public function readWorkSheetDays( workSheetId:String, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_READ_WORK_SHEET_DAYS_OPERATION;
			
				web.voClasses = new Object();
				web.voClasses.EmployeeWorkDayVo = "vos.EmployeeWorkDayVo";
			
				web.data = new URLVariables();
				web.data.employee_work_sheet_id = workSheetId;	
				
			_startOperation( web, service );
		}
		
		public function updateWorkSheet( workSheet:EmployeeWorkSheetVo, days:Array, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "employees";
				web.action = EMPLOYEE_UPDATE_WORK_SHEET_OPERATION;
			
			var data:URLVariables = buildUrlVarialbesFromAssociateArray( days, "_work_sheet_days_" );	
				
			SystemUtility.copyData( workSheet, data );
			
			web.data = data;
			
			_startOperation( web, service );
		}
		
		
		override protected function _finishOperation( serviceEvent:ServiceEvent, dispatch:Boolean = true ):ModelOperationResponseVo
		{
			var op:ModelOperationResponseVo = super._finishOperation( serviceEvent, false );
			var service:ServiceLoader = serviceEvent.target as ServiceLoader;
			
			if( op.status == STATUS_OK )
			{
				if( service.name == EMPLOYEE_CREATE_WS_OPERATION || 
					service.name == EMPLOYEE_UPDATE_WS_OPERATION )
				{
					__workingScenarios.dataUpdated = true;
				}
				else if( service.name == EMPLOYEE_READ_WS_OPERATION )
				{
					__workingScenarios = op;
					__workingScenarios.dataUpdated = false;
				}
				else if( service.name == EMPLOYEE_CREATE_ECONOMIC_OPERATION )
				{
					__employeeEconomics = null;
					readEconomicsForSelect( null );
				}
				else if( service.name == EMPLOYEE_UPDATE_ECONOMIC_FIELD_OPERATION )
				{
					if( __current_economic_update_field.value_name == "employee_economics_name" )
					{
						__employeeEconomics = null;
						readEconomicsForSelect( null );
					}
				}
			}
			
			_dispatchOperationResponse( serviceEvent, op );
			
			return op;
		}
	}
}