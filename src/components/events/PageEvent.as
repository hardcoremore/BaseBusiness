package components.events
{
	import flash.events.Event;
	
	import mx.utils.UIDUtil;
	
	public class PageEvent extends Event
	{
		
		public static const PAGE_CHANGE:String = "pageChange";
		
		
		protected var _pageNumber:uint;
		public function set pageNumber( pn:uint ):void
		{
			_pageNumber = pn;
		}
		
		public function get pageNumber():uint
		{
			return _pageNumber;
		}
		
		protected var _rowsPerPage:uint;
		public function set rowsPerPage( rpp:uint ):void
		{
			_rowsPerPage = rpp;
		}
		
		public function get rowsPerPage():uint
		{
			return _rowsPerPage;
		}
		
		protected var _sortColumnName:String;
		public function set sortColumnName( scn:String ):void
		{
			_sortColumnName = scn;
		}
		
		public function get sortColumnName():String
		{
			return _sortColumnName;
		}
		
		protected var _sortDirection:String;
		public function set sortDirection( sdi:String ):void
		{
			_sortDirection = sdi;
		}
		
		public function get sortDirection():String
		{
			return _sortDirection;
		}
		
		public function PageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var e:PageEvent = new PageEvent( type, bubbles, cancelable );
				e.pageNumber = pageNumber;
				e.rowsPerPage = rowsPerPage;
			
			return e;
		}
		
	}
}