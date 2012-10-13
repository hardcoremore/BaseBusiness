package components.app
{
	import com.desktop.system.core.BaseModel;
	
	import components.events.SaveDataEvent;
	
	import flash.events.MouseEvent;
	
	import models.EmployeesModel;
	
	import spark.components.Button;
	import spark.components.ComboBox;
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class EmployeesTaxesConfigComponent extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var countryList:ComboBox;
		
		[SkinPart(required="true")]
		public var contractsList:ComboBox;
		
		[SkinPart(required="true")]
		public var saveButton:Button;
		
		[SkinPart(required="true")]
		public var resetButton:Button;
		
		public function EmployeesTaxesConfigComponent()
		{
			super();
		}
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == countryList )
			{
				countryList.dataProvider = BaseModel.countryDataProvider;
			}
			else if( instance == contractsList )
			{
				contractsList.dataProvider = EmployeesModel.contractTypeDataProvider;
			}
			if( instance == saveButton )
			{
				saveButton.addEventListener( MouseEvent.CLICK, _saveButtonClickHandler );
			}
			else if( instance == resetButton )
			{
				resetButton.addEventListener( MouseEvent.CLICK, _resetButtonClickHandler );
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if( instance == saveButton )
				saveButton.removeEventListener( MouseEvent.CLICK, _saveButtonClickHandler );
			
			if( instance == resetButton )
				resetButton.removeEventListener( MouseEvent.CLICK, _resetButtonClickHandler );
			
			super.partRemoved( partName, instance );
		}

		protected function _saveButtonClickHandler( event:MouseEvent ):void
		{
			dispatchEvent( new SaveDataEvent( SaveDataEvent.SAVE_DATA ) );	
		}
		
		protected function _resetButtonClickHandler( event:MouseEvent ):void
		{
			dispatchEvent( new SaveDataEvent( SaveDataEvent.RESET_DATA ) );		
		}
	}
}