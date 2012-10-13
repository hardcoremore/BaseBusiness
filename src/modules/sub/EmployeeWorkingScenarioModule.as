package modules.sub
{
	import com.desktop.system.core.SystemModuleBase;
	import com.desktop.system.Application.Library.ui.FormHelper;
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.ui.Components.Button.DesktopControllButton;
	
	import components.app.WorkDayForm;
	
	import factories.ModelFactory;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import interfaces.modules.sub.IEmployeeWorkingScenarioModule;
	
	import models.EmployeesModel;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.collections.XMLListCollection;
	import mx.events.FlexEvent;
	
	import spark.components.DataGrid;
	import spark.components.Group;
	import spark.components.List;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.GridSelectionEvent;
	import spark.events.IndexChangeEvent;
	
	import vos.EmployeesWorkingScenarioDayVo;
	import vos.SaveWorkingScenarioVo;
	
	public class EmployeeWorkingScenarioModule extends SystemModuleBase implements IEmployeeWorkingScenarioModule
	{
		[SkinPart(required="true")]
		public var newScenarioButton:DesktopControllButton;
		
		[SkinPart(required="true")]
		public var saveScenarioButton:DesktopControllButton;
		
		[SkinPart(required="true")]
		public var refreshButton:DesktopControllButton;
		
		[SkinPart(required="true")]
		public var resetScenarioDayButton:DesktopControllButton;
		
		[SkinPart(required="true")]
		public var employee_working_scenario_name:TextInput;
		
		[SkinPart(required="true")]
		public var mondayForm:WorkDayForm;
		
		[SkinPart(required="true")]
		public var tuesdayForm:WorkDayForm;
		
		[SkinPart(required="true")]
		public var wednesdayForm:WorkDayForm;
		
		[SkinPart(required="true")]
		public var thursdayForm:WorkDayForm;
		
		[SkinPart(required="true")]
		public var fridayForm:WorkDayForm;
		
		[SkinPart(required="true")]
		public var saturdayForm:WorkDayForm;
		
		[SkinPart(required="true")]
		public var sundayForm:WorkDayForm;
		
		[SkinPart(required="true")]
		public var workScenarioDataHolder:SkinnableComponent;
		
		[SkinPart(required="true")]
		public var workDaysList:List;
		
		[SkinPart(required="true")]
		public var dayFormsHolder:Group;
		
		private var __employees_model:EmployeesModel;
		
		public function EmployeeWorkingScenarioModule()
		{
			super();			
		}
		
		
		override public function init():void
		{
			super.init();
			
			__employees_model = ModelFactory.employeesModel();
			setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "employeeWorkingScenarioModule", this.session.skinsLocaleName ) );
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == newScenarioButton )
			{
				newScenarioButton.addEventListener( MouseEvent.CLICK, _saveScenarioClickHandler );
			}
			else if( instance == saveScenarioButton )
			{
				saveScenarioButton.addEventListener( MouseEvent.CLICK, _saveScenarioClickHandler );
			}
			else if( instance == refreshButton )
			{
				refreshButton.addEventListener( MouseEvent.CLICK, _refreshButtonMouseClick );
			}
			else if( instance == resetScenarioDayButton )
			{
				resetScenarioDayButton.addEventListener( MouseEvent.CLICK, _resetWorkingScenarioClickHandler );
			}
			else if( instance == workScenarioDataHolder )
			{
				( workScenarioDataHolder as DataGrid ).addEventListener( GridSelectionEvent.SELECTION_CHANGE, _workScenarioDataHolderSelectionChange );
			}
			else if( instance == workDaysList )
			{
				workDaysList.dataProvider = BaseModel.weekDaysDataProvider;
				workDaysList.addEventListener( IndexChangeEvent.CHANGE, _workDayListIndexChangeEventHandler );
			}
			
				
			if( instance is WorkDayForm )
			{
				( instance as WorkDayForm ).mode = WorkDayForm.MODE_WORKING_SCENARIO;
				( instance as WorkDayForm ).employees_work_day_type.dataProvider = EmployeesModel.employeeWorkDayTypeDataProvider;
				
			}
			
			if( workDaysList && dayFormsHolder )
			{
				workDaysList.selectedIndex = 0;
				dayFormsHolder.getElementAt( 0).visible = true;
			}
			
		}
		
		protected function _workDayListIndexChangeEventHandler( event:IndexChangeEvent ):void
		{
			if( event.oldIndex > -1 )
				dayFormsHolder.getElementAt( event.oldIndex ).visible = false;
			
			if( event.newIndex > -1 )
				dayFormsHolder.getElementAt( event.newIndex ).visible = true;
			
		}
		
		protected function _refreshButtonMouseClick( event:MouseEvent ):void
		{
			__employees_model.readWorkingScenarios( this );
		}
		
		protected function _saveScenarioClickHandler( event:MouseEvent ):void
		{

			var data:SaveWorkingScenarioVo = new SaveWorkingScenarioVo();
				data.employee_working_scenario_name = employee_working_scenario_name.text;
				
			var days:Array = new Array();
			
				days.push( _getDayVoFromDayFormComponent( mondayForm ) );
				days.push( _getDayVoFromDayFormComponent( tuesdayForm ) );
				days.push( _getDayVoFromDayFormComponent( wednesdayForm ) );
				days.push( _getDayVoFromDayFormComponent( thursdayForm ) );
				days.push( _getDayVoFromDayFormComponent( fridayForm ) );
				days.push( _getDayVoFromDayFormComponent( saturdayForm ) );
				days.push( _getDayVoFromDayFormComponent( sundayForm ) );
			
				data.working_days = days;
			
			if( event.currentTarget == newScenarioButton )
			{
				__employees_model.createWorkingScenario( data, this );
			}
			else if( event.currentTarget == saveScenarioButton ) 
			{
				if( ! ( workScenarioDataHolder as DataGrid ).selectedItem )
					return;
				
				data.employee_working_scenario_id = ( workScenarioDataHolder as DataGrid ).selectedItem.employee_working_scenario_id;
				__employees_model.updateWorkingScenario( data, this );
			}
			
		}
		
		protected function _workScenarioDataHolderSelectionChange( event:GridSelectionEvent ):void
		{
			if( event.currentTarget.selectedIndex != -1 )
			{
				var si:Object = ( workScenarioDataHolder as DataGrid ).selectedItem;
				 
				employee_working_scenario_name.text = si.employee_working_scenario_name; 
				__employees_model.readWorkingScenarioDetails( si.employee_working_scenario_id, this );
				
				if( saveScenarioButton )
					saveScenarioButton.enabled = true;
			}
		}
		
		protected function _getDayVoFromDayFormComponent( cmp:WorkDayForm ):EmployeesWorkingScenarioDayVo
		{
			var vo:EmployeesWorkingScenarioDayVo = new EmployeesWorkingScenarioDayVo();
			
			if( cmp )
			{
				vo.employees_working_scenario_day_id = cmp.row_id.text;
				vo.employees_working_scenario_day = cmp.employees_work_day.selectedItem.value;
				
				vo.employees_working_scenario_day_first_shift = cmp.employees_work_day_first_shift.selected ? 1 : 0;
				vo.employees_working_scenario_day_second_shift = cmp.employees_work_day_second_shift.selected ? 1 : 0;
				vo.employees_working_scenario_day_third_shift = cmp.employees_work_day_third_shift.selected ? 1 : 0;
				
				vo.employees_working_scenario_day_type = cmp.employees_work_day_type.selectedItem.value;
				
				// make them into seconds for database insert
				vo.employees_working_scenario_first_shift_start = cmp.employees_first_shift_start.value;
				vo.employees_working_scenario_first_shift_end = cmp.employees_first_shift_end.value;
				
				vo.employees_working_scenario_second_shift_start = cmp.employees_second_shift_start.value;
				vo.employees_working_scenario_second_shift_end = cmp.employees_second_shift_end.value;
				
				vo.employees_working_scenario_third_shift_start = cmp.employees_third_shift_start.value;
				vo.employees_working_scenario_third_shift_end = cmp.employees_third_shift_end.value;
			}
				
			return vo;
		}
		
		protected function _setDayFormFromDayVo( dayForm:WorkDayForm, dvo:EmployeesWorkingScenarioDayVo ):void
		{
			dayForm.row_id.text = dvo.employees_working_scenario_day_id;
			FormHelper.setComboBoxSelectedValue( dayForm.employees_work_day_type, "value", dvo.employees_working_scenario_day_type );
			
			dayForm.employees_work_day_first_shift.selected = int( dvo.employees_working_scenario_day_first_shift ) > 0;		
			dayForm.employees_work_day_second_shift.selected = int( dvo.employees_working_scenario_day_second_shift ) > 0;		
			dayForm.employees_work_day_third_shift.selected = int( dvo.employees_working_scenario_day_third_shift ) > 0;		
			
			dayForm.employees_first_shift_start.value = dvo.employees_working_scenario_first_shift_start;
			dayForm.employees_first_shift_end.value = dvo.employees_working_scenario_first_shift_end;
			
			dayForm.employees_second_shift_start.value = dvo.employees_working_scenario_second_shift_start;
			dayForm.employees_second_shift_end.value = dvo.employees_working_scenario_second_shift_end;
			
			dayForm.employees_third_shift_start.value = dvo.employees_working_scenario_third_shift_start;
			dayForm.employees_third_shift_end.value = dvo.employees_working_scenario_third_shift_end;
		}
	
		override public function modelLoadingData(event:ModelDataChangeEvent):void
		{
			if( event.operationName == EmployeesModel.EMPLOYEE_READ_WS_DETAILS_OPERATION ||
				event.operationName == EmployeesModel.EMPLOYEE_READ_WS_OPERATION 
				)
			{
				loadingContainer.loading = true;
			}
		}
		
		override public function modelLoadingDataComplete(event:ModelDataChangeEvent):void
		{
			if( event.operationName == EmployeesModel.EMPLOYEE_READ_WS_DETAILS_OPERATION || 
				event.operationName == EmployeesModel.EMPLOYEE_READ_WS_OPERATION ||
				event.operationName == EmployeesModel.EMPLOYEE_CREATE_WS_OPERATION
				)
			{
				loadingContainer.loading = false;
			}
			
			if( event.operationName == EmployeesModel.EMPLOYEE_READ_WS_OPERATION )
			{
				_updateReadData( event.response, workScenarioDataHolder );
				resetWorkingScenarioForm();
			}
			else if( event.operationName == EmployeesModel.EMPLOYEE_CREATE_WS_OPERATION )
			{
				addRowToDataProvider( workScenarioDataHolder as DataGrid, event.response.result );				
				resetWorkingScenarioForm();
			}
			else if( event.operationName == EmployeesModel.EMPLOYEE_UPDATE_WS_OPERATION )
			{
				__employees_model.readWorkingScenarios( this );
			}
			else if( event.operationName == EmployeesModel.EMPLOYEE_READ_WS_DETAILS_OPERATION )
			{
				var wd:IList = event.response.result as IList;
				
				_setDayFormFromDayVo( mondayForm,  wd.getItemAt(0) as EmployeesWorkingScenarioDayVo );	
				_setDayFormFromDayVo( tuesdayForm, wd.getItemAt(1) as EmployeesWorkingScenarioDayVo );
				_setDayFormFromDayVo( wednesdayForm, wd.getItemAt(2)  as EmployeesWorkingScenarioDayVo );
				_setDayFormFromDayVo( thursdayForm, wd.getItemAt(3)  as EmployeesWorkingScenarioDayVo );
				_setDayFormFromDayVo( fridayForm, wd.getItemAt(4) as EmployeesWorkingScenarioDayVo );
				_setDayFormFromDayVo( saturdayForm, wd.getItemAt(5)  as EmployeesWorkingScenarioDayVo );
				_setDayFormFromDayVo( sundayForm, wd.getItemAt(6)  as EmployeesWorkingScenarioDayVo );
				
			}	
		}
		
		protected function _resetWorkingScenarioClickHandler( event:MouseEvent ):void
		{
			resetWorkingScenarioForm();
		}
		
		public function resetWorkingScenarioForm():void
		{
			if( created )
			{
				FormHelper.resetForm( mondayForm.dayForm, [ mondayForm.employees_work_day ] );
				FormHelper.resetForm( tuesdayForm.dayForm, [ tuesdayForm.employees_work_day ] );
				FormHelper.resetForm( wednesdayForm.dayForm, [ wednesdayForm.employees_work_day ] );
				FormHelper.resetForm( thursdayForm.dayForm, [ thursdayForm.employees_work_day ] );
				FormHelper.resetForm( fridayForm.dayForm, [ fridayForm.employees_work_day ] );
				FormHelper.resetForm( saturdayForm.dayForm, [ saturdayForm.employees_work_day ] );
				FormHelper.resetForm( sundayForm.dayForm, [ sundayForm.employees_work_day ] );
				
				employee_working_scenario_name.text = "";
				
				( workScenarioDataHolder as DataGrid ).selectedIndex = -1;
				
				if( saveScenarioButton )
					saveScenarioButton.enabled = false;
			}
		}
		
		override protected function _creationComplete(event:FlexEvent):void
		{
			super._creationComplete( event );
			
			__employees_model.readWorkingScenarios( this );
		}
	}
}