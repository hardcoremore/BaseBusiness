package components.events
{
	import flash.events.Event;
	
	public class SaveDataEvent extends Event
	{
		
		public static const SAVE_DATA:String = "SaveDataEvent.saveData";
		public static const RESET_DATA:String = "SaveDataEvent.resetData";
		public static const PREVIEW_DATA_INDEX_CHANGE:String  = "SaveDataEvent.previewDataIndexChange";
		
		private var _previewDataIndex:int;
		public function set previewDataIndex( val:int ):void
		{
			_previewDataIndex = val;
		}
		
		public function get previewDataIndex():int
		{
			return _previewDataIndex;
		}
		
		public function SaveDataEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super( type, bubbles, cancelable );
		}
	}
}