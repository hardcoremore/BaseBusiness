package components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.desktop.system.core.BaseModel;
	
	import spark.components.Button;
	import spark.components.ComboBox;
	import spark.components.NumericStepper;
	import spark.components.ToggleButton;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class Paging extends SkinnableComponent
	{
		
/***************************************
 *
 *  SKINS 
 * 
 ****************************************/
		
		[SkinPart(required="true")]
		public var rowsPerPageCmp:ComboBox;
		
		[SkinPart(required="true")]
		public var pageNumberCmp:NumericStepper;
		
		[SkinPart(required="true")]
		public var firstPageButtonCmp:Button;
		
		[SkinPart(required="true")]
		public var lastPageButtonCmp:Button;
		
		[SkinPart(required="true")]
		public var refreshButtonCmp:Button;

		[SkinPart(required="true")]
		public var orderColumnsList:ComboBox;
		
		[SkinPart(required="true")]
		public var orderDirectionButton:ToggleButton;
		
		
		
/*--------------			END OF SKIN PARTS			---------------*/			

		
		public function Paging()
		{
			super();
		}
		
		import components.events.PageEvent;
		
		import spark.events.IndexChangeEvent;
		
		import utility.Icons;
		
		[Bindable]
		public var TOTAL_PAGE_COUNT:uint;
		
		private var __pageNumber:uint = 1;
		private var __rowsPerPage:uint = 10;
		private var __sortColumnName:String;
		private var __sortDirection:String;
		
		public function get rowsPerPage():uint
		{
			return __rowsPerPage;
		}
		
		public function get pageNumber():uint
		{
			return __pageNumber;	
		}
		
		public function get sortColumnName():String
		{
			return __sortColumnName;
		}
		
		public function get sortColumnDirection():String
		{
			return __sortDirection;
		}
		
		public function set sortColumnDirection( value:String ):void
		{
			__sortDirection = value;
			if( orderDirectionButton )
			{
				if( __sortDirection == BaseModel.SORT_DIRECTION_DESCENDING )
				{
					orderDirectionButton.selected = true;
				}
				else
				{
					orderDirectionButton.selected = false;
				}
				
				orderDirectionButton.selected ? orderDirectionButton.label = "DESC" : orderDirectionButton.label = "ASC";
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			if( instance == refreshButtonCmp )
			{
				refreshButtonCmp.addEventListener( MouseEvent.CLICK, _refreshButtonClickEventHandler );
			}
			
			if( instance == firstPageButtonCmp )
			{
				firstPageButtonCmp.addEventListener( MouseEvent.CLICK, _firstPageClickHandler );
			}
			
			if( instance == pageNumberCmp )
			{
				pageNumberCmp.addEventListener( Event.CHANGE, _pageNumberChangeHandler );
			}
			
			if( instance == rowsPerPageCmp )
			{
				__rowsPerPage = rowsPerPageCmp.selectedItem as uint;	
				rowsPerPageCmp.addEventListener( IndexChangeEvent.CHANGE, _rowsPerPageChange );
			}
			
			if( instance == lastPageButtonCmp )
			{
				lastPageButtonCmp.addEventListener( MouseEvent.CLICK, _lasPageClickHanndler );
			}
			
			if( instance == orderColumnsList )
			{
				orderColumnsList.addEventListener( IndexChangeEvent.CHANGE, _orderColumnChangeEventHandler );
			}
			
			if( instance == orderDirectionButton )
			{
				orderDirectionButton.addEventListener( MouseEvent.CLICK, _orderDirectionChangeEventHandler );
				
				if( sortColumnDirection == BaseModel.SORT_DIRECTION_DESCENDING )
				{
					orderDirectionButton.selected = true;
				}
				else
				{
					orderDirectionButton.selected = false;
				}
				
				orderDirectionButton.selected ? orderDirectionButton.label = "DESC" : orderDirectionButton.label = "ASC";
			}
		}
		
		
		protected function _refreshButtonClickEventHandler( event:MouseEvent ):void
		{
			_dispatchEvent();
		}
			
		protected function _firstPageClickHandler( event:MouseEvent ):void
		{
			__pageNumber = 1;
			pageNumberCmp.value = 1;
			_dispatchEvent();
		}
		
		protected function _pageNumberChangeHandler( event:Event ):void
		{
			__pageNumber = pageNumberCmp.value;
			_dispatchEvent();
		}
		
		protected function _rowsPerPageChange( event:IndexChangeEvent ):void
		{
			__rowsPerPage = rowsPerPageCmp.selectedItem as uint;
			_dispatchEvent();
		}
		
		protected function _lasPageClickHanndler( event:MouseEvent ):void
		{
			__pageNumber = TOTAL_PAGE_COUNT;	
			_dispatchEvent();
		}
		
		protected function _orderColumnChangeEventHandler( event:IndexChangeEvent ):void
		{
			if( orderColumnsList.selectedItem )
			{
				__sortColumnName = orderColumnsList.selectedItem.value as String;
				_dispatchEvent();
			}
		}
		
		protected function _orderDirectionChangeEventHandler( event:MouseEvent ):void
		{
			orderDirectionButton.selected ? __sortDirection = BaseModel.SORT_DIRECTION_DESCENDING : __sortDirection = BaseModel.SORT_DIRECTION_ASCENDING;
			_dispatchEvent();
		}
		
		protected function _dispatchEvent():void
		{
			var e:PageEvent = new PageEvent( PageEvent.PAGE_CHANGE );
				e.rowsPerPage = rowsPerPage;
				e.pageNumber = pageNumber; // LAST PAGE IS NUMBER OF PAGES AVAILABLE
				e.sortColumnName = sortColumnName;
				e.sortDirection = sortColumnDirection;
			
			dispatchEvent( new PageEvent( PageEvent.PAGE_CHANGE ) );
		}
	}
}