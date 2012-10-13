package vos
{
	import spark.components.gridClasses.GridColumn;

	public class DataHolderColumnVo
	{
		public var data_holder_column_id:String;
		public var data_holder_id:String;
		public var data_holder_column_user_id:String;
		
		public var data_holder_column_position_index:int;
		
		public var data_holder_column_data_field:String;
		public var data_holder_column_visible:int;
		
		public var data_holder_column_header_text:String;
		public var data_holder_header_text_translated:String;
		
		public var data_holder_column_custom_header_text:String;
		public var data_holder_column_custom_header:int;  // boolean
		
		public var grid_column_object:GridColumn;
		
		
		public function DataHolderColumnVo()
		{
		}
	}
}