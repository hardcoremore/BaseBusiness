package components.app
{
	import com.desktop.system.Application.Library.ui.FormHelper;
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.events.FormItemChangeEvent;
	
	import flash.events.Event;
	
	import mx.events.FlexEvent;
	
	import spark.components.CheckBox;
	import spark.components.ComboBox;
	import spark.components.Form;
	import spark.components.HSlider;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import vos.EmployeeWorkDayVo;
	
	public class WorkDayForm extends SkinnableComponent
	{
		public var day:int;
		
		[SkinPart(required="true")]
		public var dayForm:Form;
		
		[SkinPart(required="true")]
		public var row_id:TextInput;
		
		[SkinPart(required="true")]
		public var employees_work_day:ComboBox;
		
		[SkinPart(required="true")]
		public var employees_work_day_type:ComboBox;
		
		
		[SkinPart(required="true")]
		public var employees_work_day_first_shift:CheckBox;
		
		[SkinPart(required="true")]
		public var employees_work_day_second_shift:CheckBox;
		
		[SkinPart(required="true")]
		public var employees_work_day_third_shift:CheckBox;
		
		
		[SkinPart(required="true")]
		public var employees_first_shift_start:HSlider;
		
		[SkinPart(required="true")]
		public var employees_first_shift_end:HSlider;
		
		[SkinPart(required="true")]
		public var employees_second_shift_start:HSlider;
		
		[SkinPart(required="true")]
		public var employees_second_shift_end:HSlider;
		
		[SkinPart(required="true")]
		public var employees_third_shift_start:HSlider;
		
		[SkinPart(required="true")]
		public var employees_third_shift_end:HSlider;
		

		[SkinPart(required="false")]
		public var employee_work_day_first_shift_overtime:HSlider;
		
		[SkinPart(required="false")]
		public var employee_work_day_second_shift_overtime:HSlider;
		
		[SkinPart(required="false")]
		public var employee_work_day_third_shift_overtime:HSlider;
		
		
		public static const MODE_WORKING_SCENARIO:uint = 1;
		public static const MODE_WORK_SHEET:uint = 2;
		
		public function WorkDayForm()
		{
			super();
			
			addEventListener( FlexEvent.CREATION_COMPLETE, _creationCompleteEventHandler, false, 0, true );
		}
		private var __mode:uint;
		public function set mode( value:uint ):void
		{
			if( value != __mode )
			{
				__mode = value;
				invalidateSkinState();
			}
		}
		
		public function get mode():uint
		{
			return __mode;
		}
		
		override protected function getCurrentSkinState():String
		{
			if( mode == MODE_WORK_SHEET )
			{
				return "workSheet";
			}
			else
			{
				return "normal";
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == employees_work_day )
			{
				employees_work_day.dataProvider = BaseModel.weekDaysDataProvider;
				employees_work_day.selectedIndex = day - 1;
				employees_work_day.enabled = false;	
			}
			else if( instance == employees_work_day_first_shift ||
					 instance == employees_work_day_second_shift ||
					 instance == employees_work_day_third_shift
					)
			{
				instance.addEventListener( Event.CHANGE, _employeesShiftSelectionChange );
				instance.addEventListener( FlexEvent.VALUE_COMMIT, _employeesShiftSelectionChange );
			}
		}
		
		protected function _formItemChangeEventHandler( event:Event ):void
		{
			var vo:EmployeeWorkDayVo = new EmployeeWorkDayVo();
			
				vo.employee_work_day_first_shift = employees_work_day_first_shift.selected ? 1 : 0;
				vo.employee_work_day_second_shift = employees_work_day_second_shift.selected ? 1 : 0;
				vo.employee_work_day_third_shift = employees_work_day_third_shift.selected ? 1 : 0;
				
				vo.employee_work_day_first_shift_start = employees_first_shift_start.value;
				vo.employee_work_day_first_shift_end = employees_first_shift_end.value;
				
				vo.employee_work_day_second_shift_start = employees_second_shift_start.value;
				vo.employee_work_day_second_shift_end = employees_second_shift_end.value;
					
				vo.employee_work_day_third_shift_start = employees_third_shift_start.value;
				vo.employee_work_day_third_shift_end = employees_third_shift_end.value;
				
				
				if( employees_work_day.selectedItem )
					vo.employee_work_day = employees_work_day.selectedItem.value;
				
				if( employee_work_day_first_shift_overtime )
					vo.employee_work_day_first_shift_overtime = employee_work_day_first_shift_overtime.value;
			
				if( employee_work_day_second_shift_overtime )
					vo.employee_work_day_second_shift_overtime = employee_work_day_second_shift_overtime.value;
			
				if( employee_work_day_third_shift_overtime )
					vo.employee_work_day_third_shift_overtime = employee_work_day_third_shift_overtime.value;
			
				if( employees_work_day_type.selectedItem ) 
					vo.employee_work_day_type = uint( employees_work_day_type.selectedItem.value );
				
			var e:FormItemChangeEvent = new FormItemChangeEvent( FormItemChangeEvent.FORM_ITEM_CHANGE );
				e.vo = vo;
			
			dispatchEvent( e );
		}
		
		protected function _employeesShiftSelectionChange( event:Event ):void
		{
			if( event.currentTarget == employees_work_day_first_shift )
			{
				employees_first_shift_start.enabled = 
				employees_first_shift_end.enabled =
				employees_work_day_first_shift.selected;
				
				if( employee_work_day_first_shift_overtime )
					employee_work_day_first_shift_overtime.enabled = employees_work_day_first_shift.selected;
			}
			else if ( event.currentTarget == employees_work_day_second_shift )
			{
				employees_second_shift_start.enabled = 
				employees_second_shift_end.enabled =
				employees_work_day_second_shift.selected;
				
				if( employee_work_day_second_shift_overtime )
					employee_work_day_second_shift_overtime.enabled = employees_work_day_second_shift.selected;
			}
			else if( event.currentTarget == employees_work_day_third_shift )
			{
				employees_third_shift_start.enabled = 
				employees_third_shift_end.enabled =
				employees_work_day_third_shift.selected;
				
				if( employee_work_day_third_shift_overtime )
					employee_work_day_third_shift_overtime.enabled = employees_work_day_third_shift.selected;
			}
		}
		
		protected function _creationCompleteEventHandler( event:FlexEvent ):void
		{
			event.currentTarget.removeEventListener( FlexEvent.CREATION_COMPLETE, _creationCompleteEventHandler ); 
			FormHelper.setFormItemChange( dayForm, _formItemChangeEventHandler, FormHelper.ADD_FORM_ITEM_CHANGE );
		}
	}
}