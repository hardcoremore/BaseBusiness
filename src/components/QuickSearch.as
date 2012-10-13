package components
{
	import components.events.QuickSearchEvent;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	import spark.components.Button;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	
	public class QuickSearch extends SkinnableComponent
	{
		
/***************************************
 *
 *  SKINS 
 * 
 ****************************************/
		[SkinPart(required="true")]
		public var searchInput:TextInput;
		
		[SkinPart(required="true")]
		public var clearSearchButton:Button;
		
/*--------------			END OF SKIN PARTS			---------------*/		
		
		public function QuickSearch()
		{
			super();
		}
		
		protected function _onSeachInputKeyDown( event:KeyboardEvent ):void
		{
			if( event.keyCode == Keyboard.ENTER )
			{
				searchInput.enabled = false;
				
				var e:QuickSearchEvent =  new QuickSearchEvent( QuickSearchEvent.QUICK_SEARCH );
					e.searchQuery = searchInput.text;
					
				dispatchEvent( e );
			}
			else
			{
				clearSearchButton.visible = true;
			}
		}
		
		protected function _onClearButtonClick( event:MouseEvent ):void
		{
			searchInput.text = "";
			clearSearchButton.visible = false;
			dispatchEvent( new QuickSearchEvent( QuickSearchEvent.CLEAR_SEARCH ) );
		}
	}
}