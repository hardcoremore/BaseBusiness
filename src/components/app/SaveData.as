package components.app
{
	import components.events.SaveDataEvent;
	
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class SaveData extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var contentGroup:Group;
		
		[SkinPart(required="true")]
		public var saveButton:Button;
		
		[SkinPart(required="true")]
		public var resetButton:Button;
		
		[SkinPart(required="true")]
		public var leftButton:Button;
		
		[SkinPart(required="true")]
		public var rightButton:Button;
		
		
		public function SaveData()
		{
			super();
		}
		
		
		private var __previewDataLength:int = 0;
		public function set previewDataLength( val:int ):void
		{
			__previewDataLength = val;
			previewDataIndex = 0;
		}
		
		public function get previewDataLength():int
		{
			return __previewDataLength;
		}
		
		
		private var __previewDataIndex:int = 0;
		public function get previewDataIndex():int
		{
			return __previewDataIndex;
		}
		
		public function set previewDataIndex( val:int ):void
		{
			if( val >= previewDataLength )
			{
				__previewDataIndex = previewDataLength - 1;
			}
			else
			{
				__previewDataIndex = val;
			}
			
			_invalidateControls();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == saveButton )
				saveButton.addEventListener( MouseEvent.CLICK, _saveButtonClickHandler );
			
			if( instance == resetButton )
				resetButton.addEventListener( MouseEvent.CLICK, _resetButtonClickHandler );
			
			if( instance == leftButton )
			{
				leftButton.addEventListener( MouseEvent.CLICK, _leftButtonClickHandler );
			}
			
			if( instance == rightButton )
			{
				rightButton.addEventListener( MouseEvent.CLICK, _rightButtonClickHandler );
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if( instance == saveButton )
				saveButton.removeEventListener( MouseEvent.CLICK, _saveButtonClickHandler );
			
			if( instance == resetButton )
				resetButton.removeEventListener( MouseEvent.CLICK, _resetButtonClickHandler );
			
			if( instance == leftButton )
				leftButton.removeEventListener( MouseEvent.CLICK, _leftButtonClickHandler );
			
			if( instance == rightButton )
				rightButton.removeEventListener( MouseEvent.CLICK, _rightButtonClickHandler );
			
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
		
		protected function _leftButtonClickHandler( event:MouseEvent ):void
		{
			previewDataIndex -= 1;
			_invalidateControls();
			
			var e:SaveDataEvent = new SaveDataEvent( SaveDataEvent.PREVIEW_DATA_INDEX_CHANGE );
				e.previewDataIndex = previewDataIndex;
			
			dispatchEvent( e );	
		}
		
		protected function _rightButtonClickHandler( event:MouseEvent ):void
		{
			previewDataIndex += 1;
			_invalidateControls();
			
			var e:SaveDataEvent = new SaveDataEvent( SaveDataEvent.PREVIEW_DATA_INDEX_CHANGE );
				e.previewDataIndex = previewDataIndex;
				
			dispatchEvent( e );	
		}
		
		protected function _invalidateControls():void
		{
			if( rightButton )
				rightButton.enabled = ! ( previewDataIndex == previewDataLength - 1 );
			if( leftButton )
				leftButton.enabled = ! ( previewDataIndex == 0 );
		}
	}
}