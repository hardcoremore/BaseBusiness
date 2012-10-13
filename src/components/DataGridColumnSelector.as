package components
{
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.events.ComponentCRUDEvent;
	import com.desktop.system.utility.SystemUtility;
	import com.desktop.ui.Components.Button.DesktopControllButton;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import models.SystemModel;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	
	import spark.components.CheckBox;
	import spark.components.List;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.IndexChangeEvent;
	
	import vos.DataHolderColumnVo;
	
	public class DataGridColumnSelector extends SkinnableComponent
	{
		[SkinPart(required="true")]
		public var removedColumnsList:List;
		
		[SkinPart(required="true")]
		public var addedColumnsList:List;
		
		
		[SkinPart(required="true")]
		public var data_holder_custom_header:CheckBox;
		
		[SkinPart(required="true")]
		public var data_holder_custom_header_text:TextInput;
		
		
		[SkinPart(required="true")]
		public var saveButton:DesktopControllButton;
		
		[SkinPart(required="true")]
		public var resetButton:DesktopControllButton;

		
		[SkinPart(required="true")]
		public var insertColumnButton:DesktopControllButton;
		
		[SkinPart(required="true")]
		public var removeColumnButton:DesktopControllButton;
		
		private var __update_list_pending:Boolean = false;
		
		public function DataGridColumnSelector()
		{
			super();
			
			addEventListener( FlexEvent.CREATION_COMPLETE, _creationCompleteEventHandler, false, 0, true );
		}
		
		private var __data:ArrayList;
		private var __workingData:ArrayList;
		
		public function set data( d:ArrayList ):void
		{
			if( d )
			{
				__data = d;
				__workingData = SystemUtility.cloneArrayList( d ); 
				_fillLists( __workingData );
			}
		}
		
		public function get data():ArrayList
		{
			return __workingData;
		}
		
		public function get originalData():ArrayList
		{
			return __data;
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == removedColumnsList )
			{
				removedColumnsList.addEventListener( IndexChangeEvent.CHANGE, _listIndexChangeEventHandler, false, 0, true  );
				removedColumnsList.labelFunction = _columnListLabelFunction;
			}
			else if( instance == addedColumnsList )
			{
				addedColumnsList.addEventListener( IndexChangeEvent.CHANGE, _listIndexChangeEventHandler, false, 0, true  );
				addedColumnsList.labelFunction = _columnListLabelFunction;
				
				addedColumnsList.addEventListener( DragEvent.DRAG_ENTER, _addedColumnsListDragEventHandler, false, 0, true );
				addedColumnsList.addEventListener( DragEvent.DRAG_START, _addedColumnsListDragEventHandler, false, 0, true );
				addedColumnsList.addEventListener( DragEvent.DRAG_OVER, _addedColumnsListDragEventHandler, false, 0, true );
				addedColumnsList.addEventListener( DragEvent.DRAG_COMPLETE, _addedColumnsListDragEventHandler, false, 0, true );
			}
			else if( instance == insertColumnButton || instance == removeColumnButton )
			{
				instance.addEventListener( MouseEvent.CLICK, _insertRemoveColumnsEventHandler );
			}
			else if( instance == saveButton )
			{
				saveButton.addEventListener( MouseEvent.CLICK, _saveButtonClickHandler, false, 0, true );
			}
			else if( instance == resetButton )
			{
				resetButton.addEventListener( MouseEvent.CLICK, _resetButtonClickHandler, false, 0, true );
			}
			else if( instance == data_holder_custom_header )
			{
				data_holder_custom_header.addEventListener( Event.CHANGE, _dataHolderCustomTextCheckBoxChangeEventHander );
			}
			else if( instance == data_holder_custom_header_text )
			{
				data_holder_custom_header_text.addEventListener( Event.CHANGE, _dataHolderCustomTextHeaderChangeEventHandler );
			}
			
		}
		
		protected function _columnListLabelFunction(item:Object):String
		{
			var i:DataHolderColumnVo = item as DataHolderColumnVo;
			
			if( i )
			{
				if( i.data_holder_column_custom_header == SystemModel.DATA_HOLDER_CUSTOM_HEADER_TEXT_TRUE )
				{
					return i.data_holder_column_custom_header_text;
				}
				else
				{
					return i.data_holder_header_text_translated;
				}
			}
			
			return "";
		}
		
		protected function _saveButtonClickHandler( event:MouseEvent ):void
		{
			var e:ComponentCRUDEvent = new ComponentCRUDEvent( ComponentCRUDEvent.SAVE );
				e.data = __workingData;
			
			dispatchEvent( e );	
		}
		
		protected function _resetButtonClickHandler( event:MouseEvent ):void
		{
			var e:ComponentCRUDEvent = new ComponentCRUDEvent( ComponentCRUDEvent.RESET );
				e.data = __workingData;
			
			dispatchEvent( e );
			
			__workingData = SystemUtility.cloneArrayList( __data );
			
			_fillLists( __workingData );
			
			data_holder_custom_header.selected = false;
			data_holder_custom_header_text.text = "";
		}
		
		protected function _addedColumnsListDragEventHandler( event:DragEvent ):void
		{
			if( event.ctrlKey )
			{
				event.preventDefault();
				event.stopImmediatePropagation();
				return;
			}	
			
			if( event.type == DragEvent.DRAG_COMPLETE )
			{
				_updateItemsPositionIndexes();
			}
		}
		
		protected function _dataHolderCustomTextCheckBoxChangeEventHander( event:Event ):void
		{
			var item:DataHolderColumnVo = addedColumnsList.selectedItem as DataHolderColumnVo || removedColumnsList.selectedItem as DataHolderColumnVo;
				
			item.data_holder_column_custom_header = 
				data_holder_custom_header.selected ? SystemModel.DATA_HOLDER_CUSTOM_HEADER_TEXT_TRUE : SystemModel.DATA_HOLDER_CUSTOM_HEADER_TEXT_FALSE;
			
			addedColumnsList.dataProvider.itemUpdated( item );
		}
		
		protected function _dataHolderCustomTextHeaderChangeEventHandler( event:Event ):void
		{
			var item:DataHolderColumnVo = addedColumnsList.selectedItem as DataHolderColumnVo || removedColumnsList.selectedItem as DataHolderColumnVo;
				item.data_holder_column_custom_header_text = data_holder_custom_header_text.text;
			
			if( addedColumnsList.selectedItem )
			{
				addedColumnsList.dataProvider.itemUpdated( item );
			}
			else
			{
				removedColumnsList.dataProvider.itemUpdated( item );
			}
		}
		
		protected function _listIndexChangeEventHandler( event:IndexChangeEvent ):void
		{
			if( event.target == removedColumnsList )
			{
				addedColumnsList.selectedIndex = -1;
				
				removeColumnButton.enabled = false;
				insertColumnButton.enabled = true;
			}
			else
			{
				removeColumnButton.enabled = true;
				insertColumnButton.enabled = false;
				
				removedColumnsList.selectedIndex = -1;
			}
			
			var item:DataHolderColumnVo = addedColumnsList.selectedItem as DataHolderColumnVo || removedColumnsList.selectedItem as DataHolderColumnVo;
			
			if( item )
			{
				if( item.data_holder_column_custom_header == SystemModel.DATA_HOLDER_CUSTOM_HEADER_TEXT_TRUE )
				{
					data_holder_custom_header.selected = true;
					data_holder_custom_header_text.text = item.data_holder_column_custom_header_text;
				}
				else
				{
					data_holder_custom_header.selected = false;
					data_holder_custom_header_text.text = "";
				}
			}	
		}
		
		protected function _insertRemoveColumnsEventHandler( event:MouseEvent ):void
		{
			var itemIndexes:Vector.<int>;
			var sourceDataProivder:IList;
			var destinationDataProvider:IList;
			
			if( ! removedColumnsList.dataProvider ) removedColumnsList.dataProvider = new ArrayList(); 
			
			if( event.currentTarget == removeColumnButton )
			{
				itemIndexes = addedColumnsList.selectedIndices;
				sourceDataProivder = addedColumnsList.dataProvider;
				destinationDataProvider = removedColumnsList.dataProvider;
			}
			else
			{
				itemIndexes = removedColumnsList.selectedIndices;		
				sourceDataProivder = removedColumnsList.dataProvider;
				destinationDataProvider = addedColumnsList.dataProvider;
			}
			
			// sort item index in descending order so that items with lower index don't change their index in array when removing
			itemIndexes.sort( SystemUtility.sortIntDescending );
			
			var item:DataHolderColumnVo;
			
			for each ( var i:int in itemIndexes ) 
			{
				item = sourceDataProivder.getItemAt( i ) as DataHolderColumnVo;
				item.data_holder_column_visible = event.currentTarget == insertColumnButton ? 1 : 0;
				
				destinationDataProvider.addItem( item );
				destinationDataProvider.itemUpdated( item );
				sourceDataProivder.removeItemAt( i );
			}		
			
			_updateItemsPositionIndexes();
		}
		
		protected function _updateItemsPositionIndexes():void
		{
			if( ! addedColumnsList || ! addedColumnsList.dataProvider ) return;
			
			var item:DataHolderColumnVo;
			var i:int;
			
			for( i = 0; i < addedColumnsList.dataProvider.length; i++ )
			{
				item = addedColumnsList.dataProvider.getItemAt( i ) as DataHolderColumnVo;
				
				if( item )
				{
					item.data_holder_column_position_index = i;
				}
			}
			
			for( i = 0; i < removedColumnsList.dataProvider.length; i++ )
			{
				item = removedColumnsList.dataProvider.getItemAt( i ) as DataHolderColumnVo;
				
				if( item )
				{
					item.data_holder_column_position_index = addedColumnsList.dataProvider.length + i;
				}
			}
		}
		
		protected function _fillLists( d:ArrayList ):void
		{
			if( d && removedColumnsList && addedColumnsList )
			{
				removedColumnsList.dataProvider = new ArrayList();
				addedColumnsList.dataProvider = new ArrayList();
			}
			else
			{
				__update_list_pending = true;
				return;
			}
			
			var col:DataHolderColumnVo; 
			for( var i:int = 0; i < d.length; i++ )
			{
				col = d.getItemAt( i ) as DataHolderColumnVo;
				if( col.data_holder_column_visible == SystemModel.DATA_HOLDER_ITEM_VISIBLE_TRUE )
				{
					addedColumnsList.dataProvider.addItem( col );
				}
				else
				{
					removedColumnsList.dataProvider.addItem( col );
				}
			}
		}
		
		protected function _creationCompleteEventHandler( event:FlexEvent ):void
		{
			if( __update_list_pending )
			{
				_fillLists( __workingData );
				__update_list_pending = false;
			}
		}
	}
}