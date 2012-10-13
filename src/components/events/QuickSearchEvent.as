package components.events
{
	import flash.events.Event;
	
	public class QuickSearchEvent extends Event
	{
		
		public static const QUICK_SEARCH:String = "quickSearch";
		public static const CLEAR_SEARCH:String = "clearSearch";
		
		public function QuickSearchEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		protected var _searchQuery:String;
		
		public function set searchQuery( s:String ):void
		{
			_searchQuery = s;
		}
		
		public function get searchQuery():String
		{
			return _searchQuery;
		}
		
		override public function clone():Event
		{
			var e:QuickSearchEvent = new QuickSearchEvent( type, bubbles, cancelable );
				e.searchQuery = searchQuery;
				
			return e;
		}
	}
}