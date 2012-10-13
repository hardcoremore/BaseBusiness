package vos
{
	public class EmployeeWorkDayVo
	{
		public var employee_work_day_id:String
		public var employee_work_sheet_id:String
		public var employee_work_day_type:uint;
		public var employee_work_day_date:String;
		
		public var employee_work_day:int;
		public var employee_work_day_wage:Number;
		
		public var employee_work_day_first_shift:int;
		public var employee_work_day_second_shift:int
		public var employee_work_day_third_shift:int
		
		public var employee_work_day_first_shift_start:uint;
		public var employee_work_day_first_shift_end:uint;
		public var employee_work_day_second_shift_start:uint;
		public var employee_work_day_second_shift_end:uint;
		public var employee_work_day_third_shift_start:uint;
		public var employee_work_day_third_shift_end:uint;
		public var employee_work_day_first_shift_overtime:uint;
		public var employee_work_day_second_shift_overtime:uint;
		public var employee_work_day_third_shift_overtime:uint;
		
		public var day_type_color:uint;
		
		public var first_shift_image:Class;
		public var second_shift_image:Class;
		public var third_shift_image:Class;
		
		public function EmployeeWorkDayVo()
		{
		}
	}
}