package components.app
{
	import com.desktop.system.Application.Library.ui.FormHelper;
	import com.desktop.system.core.BaseModel;
	
	import mx.events.FlexEvent;
	import mx.graphics.SolidColor;
	
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.ToggleButton;
	import spark.primitives.BitmapImage;
	
	import vos.EmployeeWorkDayVo;
	
	public class EmployeeWorkDayElement extends ToggleButton
	{
		
		[SkinPart(required="true")]
		public var elementDayTypeBackgroundColor:SolidColor;
		
		[SkinPart(required="true")]
		public var dateLabel:Label;
		
		[SkinPart(required="true")]
		public var dayNameLabel:Label;
		
		
		// first shift
		[SkinPart(required="false")]
		public var firstShiftGroup:Group;
		
		[SkinPart(required="true")]
		public var firstShifImage:BitmapImage;
		
		
		[SkinPart(required="false")]
		public var firstShiftStartsLabel:Label;
		
		[SkinPart(required="false")]
		public var firstShiftEndsLabel:Label;
		
		[SkinPart(required="false")]
		public var firstShiftOvertimeLabel:Label;
		
		
		// second shift
		[SkinPart(required="false")]
		public var secondShiftGroup:Group;
		
		[SkinPart(required="true")]
		public var secondShifImage:BitmapImage;
		
		
		[SkinPart(required="false")]
		public var secondShiftStartsLabel:Label;
		
		[SkinPart(required="false")]
		public var secondShiftEndsLabel:Label;
		
		[SkinPart(required="false")]
		public var secondShiftOvertimeLabel:Label;
		
		
		// third shift
		[SkinPart(required="false")]
		public var thirdShiftGroup:Group;
		
		[SkinPart(required="true")]
		public var thirdShifImage:BitmapImage;
		
		
		[SkinPart(required="false")]
		public var thirdShiftStartsLabel:Label;
		
		[SkinPart(required="false")]
		public var thirdShiftEndsLabel:Label;
		
		[SkinPart(required="false")]
		public var thirdShiftOvertimeLabel:Label;
		
		
		
		
		private var __workDayData:EmployeeWorkDayVo;

		public function EmployeeWorkDayElement()
		{
			super();
			addEventListener( FlexEvent.CREATION_COMPLETE, _creationCompleteEventHandler );
		}
		
		public function set workDayData( data:EmployeeWorkDayVo ):void
		{
			__workDayData = data;
			_fillTheElement();
		}
		
		public function get workDayData():EmployeeWorkDayVo
		{
			return __workDayData;
		}
	
		protected function _fillTheElement():void
		{
		
			var d:Date = new Date();
			var time:Number = 0;
			
			if( initialized )
			{
				time = Date.parse( workDayData.employee_work_day_date );
				
				d.time = time;
				
				if( time > 0 )
					dateLabel.text = d.date.toString() + "-" + BaseModel.monthNames[ d.month ].toString().substr( 0, 3 );
				
				dayNameLabel.text = BaseModel.getWeekDayLabelFromNumber( int( workDayData.employee_work_day ) );
				elementDayTypeBackgroundColor.color = workDayData.day_type_color;
				
				firstShifImage.source = workDayData.first_shift_image;
				secondShifImage.source = workDayData.second_shift_image;
				thirdShifImage.source = workDayData.third_shift_image;
				
				
			}
		}
		
		public function _creationCompleteEventHandler( event:FlexEvent ):void
		{
			_fillTheElement();
		}
	}
}