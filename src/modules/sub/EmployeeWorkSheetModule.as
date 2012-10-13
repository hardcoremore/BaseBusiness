package modules.sub
{
	import com.desktop.system.Application.Library.ui.FormHelper;
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.core.SystemModuleBase;
	import com.desktop.system.events.FormItemChangeEvent;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.events.NotificationResponseEvent;
	import com.desktop.system.utility.CommonErrorType;
	import com.desktop.system.utility.SystemUtility;
	import com.desktop.system.vos.NotificationVo;
	import com.desktop.system.vos.ReadVo;
	
	import components.app.EmployeeWorkDayElement;
	import components.app.WorkDayForm;
	
	import factories.ModelFactory;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.flash_proxy;
	
	import interfaces.modules.sub.IEmployeeWorkSheetModule;
	
	import models.EmployeesModel;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.controls.DateField;
	import mx.core.IFactory;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	
	import skins.Default.components.app.EmployeeWorkDayElementSkin;
	
	import spark.components.Button;
	import spark.components.ComboBox;
	import spark.components.DataGrid;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.events.GridSelectionEvent;
	import spark.events.IndexChangeEvent;
	
	import vos.EmployeeWorkDayVo;
	import vos.EmployeeWorkSheetVo;
	import vos.EmployeeWorkingScenarioVo;
	import vos.EmployeesVo;
	import vos.EmployeesWorkingScenarioDayVo;
	
	public class EmployeeWorkSheetModule extends SystemModuleBase implements IEmployeeWorkSheetModule
	{
		[SkinPart(required="true")]
		public var employeeNameLabel:Label;
		
		[SkinPart(required="true")]
		public var workDayForm:WorkDayForm;
	
		[SkinPart(required="true")]
		public var employeeWorkDayWage:TextInput;
		
		[SkinPart(required="true")]
		public var workDaysHolder:Group;
		
		[SkinPart(required="true")]
		public var workSheetsDataHolder:DataGrid;
		
		[SkinPart(required="true")]
		public var availableWorkingScenariosList:ComboBox;
		
		
		[SkinPart(required="true")]
		public var employee_working_sheet_date_start:DateField;
		
		[SkinPart(required="true")]
		public var employee_working_sheet_date_end:DateField;
		
		
		[SkinPart(required="true")]
		public var generateWorkingScenarioTemplateButton:Button;
		
		
		[SkinPart(required="true")]
		public var applyDayWageButton:Button;
		
		[SkinPart(required="true")]
		public var newWorkSheetButton:Button;
		
		[SkinPart(required="true")]
		public var saveWorkSheetButton:Button;
		
		[SkinPart(required="true")]
		public var resetWorkSheetButton:Button;
		
		[SkinPart(required="true")]
		public var refreshButton:Button;
		
		[SkinPart(required="true")]
		public var deleteWorkSheetButton:Button;
		
		
		
		private var __employee_model:EmployeesModel;
		private var __selected_working_scenario:EmployeeWorkingScenarioVo;
		
		private var __current_work_day_element:EmployeeWorkDayElement;
		
		private var __work_day_elements:Vector.<EmployeeWorkDayElement>;
		
		private var __current_scenario_details:IList;
		
		private var __working_scenario_changed:Boolean;
		
		public function EmployeeWorkSheetModule()
		{
			super();
			__work_day_elements = new Vector.<EmployeeWorkDayElement>();
		}
		
		override public function init():void
		{
			super.init();
			
			setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "employeeWorkSheetModule", this.session.skinsLocaleName ) );
			
			__employee_model = ModelFactory.employeesModel();
			__employee_model.addEventListener( ModelDataChangeEvent.MODEL_LOADING_DATA_COMPLETE, _modelLoadingDataCompleteEventHandler );
			
		}
		
		override public function set data(d:Object):void
		{
			if( data != d )
			{
				super.data = d;
				
				if( data && data is EmployeesVo && notifier )
				{
					var e:EmployeesVo = data as EmployeesVo;
					FormHelper.setComboBoxSelectedValue( availableWorkingScenariosList, "employee_working_scenario_id", e.employee_working_scenario_id  );
					employeeNameLabel.text = e.employee_name + " " + e.employee_last_name;
					
					__selected_working_scenario = availableWorkingScenariosList.selectedItem as EmployeeWorkingScenarioVo;
					
					notifier.close();
					_readWorkSheets();
				}
			}
		}
		
		protected function _fillWorkDayForm( wd:EmployeeWorkDayVo ):void
		{
			if( created && wd )
			{
				
				workDayForm.employees_work_day_first_shift.selected = Boolean( wd.employee_work_day_first_shift );
				workDayForm.employees_work_day_second_shift.selected = Boolean( wd.employee_work_day_second_shift );
				workDayForm.employees_work_day_third_shift.selected = Boolean( wd.employee_work_day_third_shift );
				
				FormHelper.setComboBoxSelectedValue( workDayForm.employees_work_day, "value", wd.employee_work_day );
				FormHelper.setComboBoxSelectedValue( workDayForm.employees_work_day_type, "value", wd.employee_work_day_type );
				
				employeeWorkDayWage.text = wd.employee_work_day_wage.toString();
				
				workDayForm.employees_first_shift_start.value = wd.employee_work_day_first_shift_start;
				workDayForm.employees_first_shift_end.value = wd.employee_work_day_first_shift_end;
				
				workDayForm.employees_second_shift_start.value = wd.employee_work_day_second_shift_start;
				workDayForm.employees_second_shift_end.value = wd.employee_work_day_second_shift_end;
				
				workDayForm.employees_third_shift_start.value = wd.employee_work_day_third_shift_start;
				workDayForm.employees_third_shift_end.value = wd.employee_work_day_third_shift_end;
				
				workDayForm.employee_work_day_first_shift_overtime.value = wd.employee_work_day_first_shift_overtime;
				workDayForm.employee_work_day_second_shift_overtime.value = wd.employee_work_day_second_shift_overtime;
				workDayForm.employee_work_day_third_shift_overtime.value = wd.employee_work_day_third_shift_overtime;
				
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == workDayForm )
			{
				workDayForm.addEventListener( FormItemChangeEvent.FORM_ITEM_CHANGE, _workDayFormItemChangeEventHandler );
				workDayForm.employees_work_day_type.dataProvider = EmployeesModel.employeeWorkDayTypeDataProvider;
			}
			else if( instance == availableWorkingScenariosList )
			{
				availableWorkingScenariosList.labelField = "employee_working_scenario_name";
				availableWorkingScenariosList.addEventListener( IndexChangeEvent.CHANGE, _workingScenarioChange );
				availableWorkingScenariosList.addEventListener( FlexEvent.VALUE_COMMIT, _workingScenarioChange );
			}
			else if( instance == generateWorkingScenarioTemplateButton )
			{
				generateWorkingScenarioTemplateButton.addEventListener( MouseEvent.CLICK, _generateTemplateButtonClickHandler );
			}
			else if( instance == applyDayWageButton )
			{
				applyDayWageButton.addEventListener( MouseEvent.CLICK, _applyDayWageButtonClickHandler );
			}
			else if( instance == newWorkSheetButton )
			{
				newWorkSheetButton.addEventListener( MouseEvent.CLICK, _saveWorkSheetClickHandler );
				newWorkSheetButton.enabled = false;
			}
			else if( instance == saveWorkSheetButton )
			{
				saveWorkSheetButton.enabled = false;
				saveWorkSheetButton.addEventListener( MouseEvent.CLICK, _saveWorkSheetClickHandler );
			}
			else if( instance == workSheetsDataHolder )
			{
				workSheetsDataHolder.addEventListener( GridSelectionEvent.SELECTION_CHANGE, _workSheetGridSelectionHandler );
			}
			else if( instance == resetWorkSheetButton )
			{
				resetWorkSheetButton.addEventListener( MouseEvent.CLICK, _resetWorkSheetButtonHandler );
			}
			else if( instance == refreshButton )
			{
				refreshButton.addEventListener( MouseEvent.CLICK, _refreshButtonClickEventHandler );
			}
		}

		public function createWorkDayElement( wdvo:EmployeeWorkDayVo ):EmployeeWorkDayElement
		{
			var e:EmployeeWorkDayElement = new EmployeeWorkDayElement();
				e.setStyle( "skinClass", EmployeeWorkDayElementSkin );
				e.workDayData = wdvo;
				e.useHandCursor = true;
				e.buttonMode = true;
				e.addEventListener( MouseEvent.CLICK, _workDayElementClickHandler, false, 0, false );
				workDaysHolder.addElement( e );
				
			return e;
				
		}
		
		protected function _generateWorkDayElements():void
		{
			__work_day_elements = new Vector.<EmployeeWorkDayElement>();
			
			var wd:EmployeeWorkDayVo;
			var scenario_wd:EmployeesWorkingScenarioDayVo;
			
			var current_date:Date = new Date();	 
				current_date.time = employee_working_sheet_date_start.selectedDate.time;
				
			var numDays:uint = 0;
			
			var day:uint;
			
			workDaysHolder.removeAllElements();
			
			while( true )
			{
				day = current_date.day;
				if( day == 0 )
					day = 7;
				
				scenario_wd = __employee_model.getWorkScenarioDayVoFromWorkScenario( __current_scenario_details, day );
				
				numDays++;
				
				if( numDays > 93 ) break;
				
				if( scenario_wd )
				{
					
					wd = new EmployeeWorkDayVo;
					
					wd.employee_work_day_date = current_date.toString();
					wd.employee_work_day_type = scenario_wd.employees_working_scenario_day_type;
					wd.day_type_color = __employee_model.getDayTypeColor( wd.employee_work_day_type );
					
					wd.employee_work_day = day;
					wd.employee_work_day_wage = 0;
					
					wd.employee_work_day_first_shift = scenario_wd.employees_working_scenario_day_first_shift;
					wd.employee_work_day_second_shift = scenario_wd.employees_working_scenario_day_second_shift;
					wd.employee_work_day_third_shift = scenario_wd.employees_working_scenario_day_third_shift;
					
					wd.employee_work_day_first_shift_overtime = 0;
					wd.employee_work_day_second_shift_overtime = 0;
					wd.employee_work_day_third_shift_overtime = 0;
					
					
					wd.employee_work_day_first_shift_start = scenario_wd.employees_working_scenario_first_shift_start;
					wd.employee_work_day_second_shift_start = scenario_wd.employees_working_scenario_second_shift_start;
					wd.employee_work_day_third_shift_start = scenario_wd.employees_working_scenario_third_shift_start;
					
					wd.employee_work_day_first_shift_end = scenario_wd.employees_working_scenario_first_shift_end;
					wd.employee_work_day_second_shift_end = scenario_wd.employees_working_scenario_second_shift_end;
					wd.employee_work_day_third_shift_end = scenario_wd.employees_working_scenario_third_shift_end;
					
					if( wd.employee_work_day_type != EmployeesModel.EMPLOYEE_WORK_DAY_TYPE_NOT_WORKING && 
						wd.employee_work_day_type != EmployeesModel.EMPLOYEE_WORK_DAY_TYPE_SICK &&
						wd.employee_work_day_type != EmployeesModel.EMPLOYEE_WORK_DAY_TYPE_VACATION )
					{
						
						
					}
					else
					{
						wd.employee_work_day_wage = 0;
					}
					
					__fillWorkDayImages( wd );
					
					__work_day_elements.push( createWorkDayElement( wd ) );
					
				}
				
				current_date.time += 24 * 60 * 60 * 1000;
				current_date.hours = 0;
				
				if( current_date.time > employee_working_sheet_date_end.selectedDate.time )
				{
					break;
				}
				
			}
		}
		
		protected function __fillWorkDayImages( wd:EmployeeWorkDayVo ):void
		{
			
			Boolean( wd.employee_work_day_first_shift ) ?
				wd.first_shift_image = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "successIcon", this.session.skinsLocaleName )
				:
				wd.first_shift_image = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "deleteErrorIcon", this.session.skinsLocaleName );
			
			Boolean( wd.employee_work_day_second_shift ) ?
				wd.second_shift_image = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "successIcon", this.session.skinsLocaleName )
				:
				wd.second_shift_image = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "deleteErrorIcon", this.session.skinsLocaleName );
			
			Boolean( wd.employee_work_day_third_shift ) ?
				wd.third_shift_image = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "successIcon", this.session.skinsLocaleName )
				:
				wd.third_shift_image = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "deleteErrorIcon", this.session.skinsLocaleName );
			
		}
		
		
		/***************
		 * 
		 * 	EVENTS
		 * 
		 ***************/ 
		
		protected function _workSheetGridSelectionHandler( event:GridSelectionEvent ):void
		{
			if( workSheetsDataHolder.selectedIndex == -1 )
				return;
			
			employee_working_sheet_date_start.enabled  = false;
			employee_working_sheet_date_end.enabled  = false;
			newWorkSheetButton.enabled = false;
			saveWorkSheetButton.enabled = false;
			generateWorkingScenarioTemplateButton.enabled = false;
			
			_resetAll();
			saveWorkSheetButton.enabled = true;
			
			var ws:EmployeeWorkSheetVo = workSheetsDataHolder.selectedItem as EmployeeWorkSheetVo;
			
			__employee_model.readWorkSheetDays( ws.employee_work_sheet_id, this );
		}
		
		protected function _resetAll():void
		{
			employee_working_sheet_date_end.enabled = true;
			employee_working_sheet_date_start.enabled = true;
			newWorkSheetButton.enabled = true;
			saveWorkSheetButton.enabled = true;
			generateWorkingScenarioTemplateButton.enabled = true;
			
			__work_day_elements = new Vector.<EmployeeWorkDayElement>();
			FormHelper.resetForm( workDayForm.dayForm );
			workDaysHolder.removeAllElements();
		}
		
		protected function _saveWorkSheetClickHandler( event:MouseEvent ):void
		{
			var days:Array = new Array();
			var i:uint = 0;
			
			var ws:EmployeeWorkSheetVo;
			var work_day:EmployeeWorkDayVo;
			var selectedWorkSheet:EmployeeWorkSheetVo = ( workSheetsDataHolder as DataGrid ).selectedItem as EmployeeWorkSheetVo;
			
			ws = new EmployeeWorkSheetVo();
			
			ws.employee_id = ( data as EmployeesVo ).employee_id;
			
			ws.employee_work_sheet_business_trip_days_total = 0;
			ws.employee_work_sheet_sick_days_total = 0;
			ws.employee_work_sheet_work_days_total = 0;
			ws.employee_work_sheet_vacation_days_total = 0;
			ws.employee_work_sheet_not_working_days_total = 0;
			
			ws.employee_work_sheet_first_shift_overtime_total = 0;
			ws.employee_work_sheet_second_shift_overtime_total = 0;
			ws.employee_work_sheet_third_shift_overtime_total = 0;
			ws.employee_work_sheet_work_overtime_total = 0;
			
			ws.employee_work_sheet_num_days_total = __work_day_elements.length;
			
			var date:Date;
			
			
			for( i = 0; i < __work_day_elements.length; i ++ )
			{	 
				work_day = SystemUtility.clone( __work_day_elements[ i ].workDayData ) as EmployeeWorkDayVo;
				work_day.first_shift_image = null;
				work_day.second_shift_image = null;
				work_day.third_shift_image  = null;
				
				date = new Date();
				date.time = Date.parse( work_day.employee_work_day_date );
				
				work_day.employee_work_day_date = BaseModel.formatDate( "YYYY-MM-DD", date );
				
				if( work_day.employee_work_day_type == EmployeesModel.EMPLOYEE_WORK_DAY_TYPE_BUSSINESS_TRIP )
				{
					ws.employee_work_sheet_business_trip_days_total += 1;
					ws.employee_work_sheet_business_trip_time_total += getWorkDayTimeTotal( work_day );
				}
				else if( work_day.employee_work_day_type == EmployeesModel.EMPLOYEE_WORK_DAY_TYPE_NORMAL )
				{
					ws.employee_work_sheet_work_days_total += 1;
					ws.employee_work_sheet_work_time_total += getWorkDayTimeTotal( work_day );
				}
				else if( work_day.employee_work_day_type == EmployeesModel.EMPLOYEE_WORK_DAY_TYPE_SICK )
				{
					ws.employee_work_sheet_sick_days_total += 1;
					ws.employee_work_sheet_sick_time_total += getWorkDayTimeTotal( work_day );
				}
				else if( work_day.employee_work_day_type == EmployeesModel.EMPLOYEE_WORK_DAY_TYPE_NOT_WORKING )
				{
					ws.employee_work_sheet_not_working_days_total += 1;
				}
				else if( work_day.employee_work_day_type == EmployeesModel.EMPLOYEE_WORK_DAY_TYPE_VACATION )
				{
					ws.employee_work_sheet_vacation_days_total += 1;
				}
				
				
				ws.employee_work_sheet_first_shift_time_total += getWorkDayTimeTotal( work_day, true, false, false );
				ws.employee_work_sheet_second_shift_time_total += getWorkDayTimeTotal( work_day, false, true, false );
				ws.employee_work_sheet_third_shift_time_total += getWorkDayTimeTotal( work_day, false, false, true );
				
				if( work_day.employee_work_day_first_shift_overtime )
					ws.employee_work_sheet_first_shift_overtime_total += work_day.employee_work_day_first_shift_overtime;
				
				if( work_day.employee_work_day_second_shift_overtime )
					ws.employee_work_sheet_second_shift_overtime_total += work_day.employee_work_day_second_shift_overtime;
				
				if( work_day.employee_work_day_third_shift_overtime )
					ws.employee_work_sheet_third_shift_overtime_total += work_day.employee_work_day_third_shift_overtime;
				
				
				ws.employee_work_sheet_work_overtime_total += ws.employee_work_sheet_first_shift_overtime_total +
															  ws.employee_work_sheet_second_shift_overtime_total +
															  ws.employee_work_sheet_third_shift_overtime_total;
				
				days.push( work_day );
			}
			
			if( event.currentTarget == newWorkSheetButton )
			{	
				ws.employee_work_sheet_date_start = BaseModel.formatDate( "YYYY-MM-DD", employee_working_sheet_date_start.selectedDate );
				ws.employee_work_sheet_date_end = BaseModel.formatDate( "YYYY-MM-DD", employee_working_sheet_date_end.selectedDate );
				
				__employee_model.createWorkSheet( ws, days, this );
				
			}
			else if( event.currentTarget == saveWorkSheetButton )
			{	
				
				ws.employee_work_sheet_date_start = selectedWorkSheet.employee_work_sheet_date_start;
				ws.employee_work_sheet_date_end = selectedWorkSheet.employee_work_sheet_date_end;
				
				ws.employee_work_sheet_id = selectedWorkSheet.employee_work_sheet_id;
				__employee_model.updateWorkSheet( ws, days, this );
			}
			
		}
		
		protected function _resetWorkSheetButtonHandler( event:MouseEvent ):void
		{
			workSheetsDataHolder.selectedIndex = -1;
			_resetAll();
		}
		
		protected function _refreshButtonClickEventHandler( event:MouseEvent ):void
		{
			_resetAll();
			_readWorkSheets();
		}
		
		public function getWorkDayTimeTotal( workDay:EmployeeWorkDayVo, firstShift:Boolean = true, secondShift:Boolean = true, thirdShift:Boolean = true ):int
		{
			var t:int = 0;
			var time_minutes_24:uint = 24 * 60;
			
			if( Boolean( workDay.employee_work_day_first_shift ) && firstShift )
			{
				if( workDay.employee_work_day_first_shift_start < workDay.employee_work_day_first_shift_end )
				{
					t += workDay.employee_work_day_first_shift_end - workDay.employee_work_day_first_shift_start; 
				}
				else
				{
					t += time_minutes_24 - workDay.employee_work_day_first_shift_start + workDay.employee_work_day_first_shift_end; 
				}
			}
				
			if( Boolean( workDay.employee_work_day_second_shift ) && secondShift )
			{
				if( workDay.employee_work_day_second_shift_start < workDay.employee_work_day_second_shift_end )
				{
					t += workDay.employee_work_day_second_shift_end - workDay.employee_work_day_second_shift_start; 
				}
				else
				{
					t += time_minutes_24 - workDay.employee_work_day_second_shift_start + workDay.employee_work_day_second_shift_end;
				}
			}
			
			if( Boolean( workDay.employee_work_day_third_shift ) && thirdShift )
			{
				if( workDay.employee_work_day_third_shift_start < workDay.employee_work_day_third_shift_end )
				{
					t += workDay.employee_work_day_third_shift_end - workDay.employee_work_day_third_shift_start; 
				}
				else
				{
					t += time_minutes_24 - workDay.employee_work_day_third_shift_start + workDay.employee_work_day_third_shift_end;
				}
			}
			
			return t;	
		}
		
		protected function _workDayElementClickHandler( event:MouseEvent ):void
		{
			if( __current_work_day_element )
			{
				__current_work_day_element.mouseEnabled = __current_work_day_element.mouseChildren = true;
				__current_work_day_element.selected = false;
			}
			
			__current_work_day_element = event.currentTarget as EmployeeWorkDayElement;
			__current_work_day_element.mouseEnabled = __current_work_day_element.mouseChildren = false;
			__current_work_day_element.selected = true;
			
			_fillWorkDayForm( __current_work_day_element.workDayData );
			
		}
		
		override public function modelLoadingData(event:ModelDataChangeEvent):void
		{
			super.modelLoadingData( event );
			
			if( event.operationName == EmployeesModel.EMPLOYEE_READ_WS_OPERATION )
			{
				setLoadingComboBox( availableWorkingScenariosList );
			}
		}
		
		protected function _modelLoadingDataCompleteEventHandler( event:ModelDataChangeEvent ):void
		{
			if( event.operationName == EmployeesModel.EMPLOYEE_CREATE_WS_OPERATION )
			{
				addRowToDataProvider( availableWorkingScenariosList, event.response.result );
			}
			else if( event.operationName == EmployeesModel.EMPLOYEE_UPDATE_WS_OPERATION )
			{
				__employee_model.readWorkingScenarios( this );
			}
			else if( event.operationName == EmployeesModel.EMPLOYEE_READ_WS_OPERATION )
			{
				
			}
		}
		
		override public function modelLoadingDataComplete(event:ModelDataChangeEvent):void
		{
			super.modelLoadingDataComplete( event );
			
			if( event.operationName == EmployeesModel.EMPLOYEE_READ_WS_OPERATION )
			{
				__current_scenario_details = event.response.result as IList;
				
				if( availableWorkingScenariosList )
					_updateReadData( event.response, availableWorkingScenariosList );
				
				if( data as EmployeesVo )
					FormHelper.setComboBoxSelectedValue( availableWorkingScenariosList, "employee_working_scenario_id", ( data as EmployeesVo ).employee_working_scenario_id );
			}
			else if( event.operationName == EmployeesModel.EMPLOYEE_READ_WS_DETAILS_OPERATION )
			{
				__working_scenario_changed = false;
				__current_scenario_details = event.response.result as IList;
				_generateWorkDayElements();
			}
			else if( event.operationName == EmployeesModel.EMPLOYEE_CREATE_WORK_SHEET_OPERATION )
			{
				if( ! workSheetsDataHolder.dataProvider )
					workSheetsDataHolder.dataProvider = new ArrayList();
				
				workSheetsDataHolder.dataProvider.addItemAt( event.response.result as EmployeeWorkSheetVo, 0 );
			}
			else if( event.operationName == EmployeesModel.EMPLOYEE_READ_WORK_SHEET_OPERATION )
			{
				_updateReadData( event.response, workSheetsDataHolder );
			}
			else if( event.operationName == EmployeesModel.EMPLOYEE_READ_WORK_SHEET_DAYS_OPERATION )
			{
				var days:IList = event.response.result as IList;
				
				var workDayVo:EmployeeWorkDayVo;
				var workDayElement:EmployeeWorkDayElement;
				
				if( days )
				{
					for( var i:uint = 0; i < days.length; i++ )
					{
						workDayVo = days.getItemAt(i ) as EmployeeWorkDayVo;
						
						__fillWorkDayImages( workDayVo );
						workDayVo.employee_work_day_date =  workDayVo.employee_work_day_date.split( '-' ).join( '/' );
						
						workDayVo.day_type_color = __employee_model.getDayTypeColor( workDayVo.employee_work_day_type );
						workDayElement = createWorkDayElement( workDayVo );	
						__work_day_elements.push( workDayElement );
					}
				}
				else
				{
					notifyCommonError( CommonErrorType.PROGRAM, event.operationName );
				}
				
			}
			else if( event.operationName == EmployeesModel.EMPLOYEE_UPDATE_WORK_SHEET_OPERATION )
			{
				
			}
		}
		
		override protected function _notificationResponseEvent(event:NotificationResponseEvent):void
		{
			trace( "WORKSHEET MODULE" );
			//event.preventDefault();
		}
		
		protected function _workDayFormItemChangeEventHandler( event:FormItemChangeEvent ):void
		{
			if( __current_work_day_element )
			{
				var item_data:EmployeeWorkDayVo  = event.vo as EmployeeWorkDayVo;
				
				if( item_data )
				{
					item_data.day_type_color = __employee_model.getDayTypeColor( item_data.employee_work_day_type );
					item_data.employee_work_day_wage = Number( employeeWorkDayWage.text );
					
					if( ! Boolean( item_data.employee_work_day_first_shift ) ||
						! Boolean( item_data.employee_work_day_second_shift ) ||
						! Boolean( item_data.employee_work_day_third_shift )
					  )
					{
						item_data.employee_work_day_type == EmployeesModel.EMPLOYEE_WORK_DAY_TYPE_NOT_WORKING;
					}
					
					__fillWorkDayImages( item_data );
					
					var cd:EmployeeWorkDayVo = __current_work_day_element.workDayData;
					
						item_data.day_type_color = __employee_model.getDayTypeColor( item_data.employee_work_day_type );
						item_data.employee_work_day_date = cd.employee_work_day_date;
						item_data.employee_work_day_wage = cd.employee_work_day_wage;
						item_data.employee_work_sheet_id = cd.employee_work_sheet_id;
						item_data.employee_work_day_id = cd.employee_work_day_id;
						
					__current_work_day_element.workDayData = item_data;	
						
				}
				
			}
		}
		
		protected function _applyDayWageButtonClickHandler( event:MouseEvent ):void
		{
			if( __work_day_elements && __work_day_elements.length > 0 )
			{
				for( var i:uint = 0; i < __work_day_elements.length; i++ )
				{
					if( __work_day_elements[ i ].workDayData.employee_work_day_type == EmployeesModel.EMPLOYEE_WORK_DAY_TYPE_NORMAL )
					{
						__work_day_elements[ i ].workDayData.employee_work_day_wage = Number( employeeWorkDayWage.text );
					}
				}
			}
		}
		
		protected function _generateTemplateButtonClickHandler( event:MouseEvent ):void
		{	
			if( ! __selected_working_scenario )
			{
				availableWorkingScenariosList.errorString = resourceManager.getString( this.session.config.LOCALE_CONFIG.messagesResourceName, "workingScenarioNotSelected" );
				return;
			}
			else if( ! employee_working_sheet_date_end.selectedDate || ! employee_working_sheet_date_start.selectedDate )
			{
				employee_working_sheet_date_end.errorString = resourceManager.getString( this.session.config.LOCALE_CONFIG.messagesResourceName, "dateRangeNotSelected" );;
				return;
			}
			
			if( ! availableWorkingScenariosList.errorString )
			{
				availableWorkingScenariosList.errorString = "";
				employee_working_sheet_date_end.errorString = "";
				
				if( __current_scenario_details && __working_scenario_changed == false )
				{
					_generateWorkDayElements();
				}
				else
				{
					__employee_model.readWorkingScenarioDetails( __selected_working_scenario.employee_working_scenario_id.toString(), this );
				}
			}	
		}
		
		protected function _workingScenarioChange( event:Event ):void
		{
			__working_scenario_changed = true;
			__selected_working_scenario = availableWorkingScenariosList.selectedItem as EmployeeWorkingScenarioVo;
		}
	
		override protected function _creationComplete(event:FlexEvent):void
		{
			super._creationComplete( event );
			
			__employee_model.readWorkingScenarios( this );
			_readWorkSheets();
			
			if( ! ( data as EmployeesVo ) )
			{
				var nvo:NotificationVo = new NotificationVo();
					nvo.icon = resourceManager.getClass( 'systemIconClasses', 'infoIcon', session.skinsLocaleName );
					nvo.title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "info" );
					nvo.text = resourceManager.getString( this.session.config.LOCALE_CONFIG.messagesResourceName, "employeeNotSelected" );
					
				notify( nvo );
				return;
			}
			
		}
		
		protected function _readWorkSheets():void
		{
			var r:ReadVo = new ReadVo();
			r.sortColumnName = "employee_work_sheet_id"
			r.sortColumnDirection = BaseModel.SORT_DIRECTION_DESCENDING;
			
			if( data )
				__employee_model.readWorkSheets( r, ( data as EmployeesVo ).employee_id, this ); 
		}
		
	}
}