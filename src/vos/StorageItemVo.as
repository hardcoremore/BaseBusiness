package vos
{
	public class StorageItemVo
	{
		public var storage_item_id:String;
		public var storage_item_code:String;
		public var storage_item_name:String;
		public var storage_item_description:String;
		
		public var storage_item_category:uint;
		public var storage_item_category_name:String;
		
		public var storage_item_order_quantity:Number;
		public var storage_item_volume:Number;
		public var storage_item_weight:Number;
		
		public var storage_item_type:uint;
		
		public var storage_item_unit_of_measure:uint;
		
		public var storage_item_display_decimal:uint;
		public var storage_item_bar_code:String;
		
		public var storage_item_tax_percent:Number;
		public var storage_item_date_created:String;
		
		public function StorageItemVo()
		{
		}
	}
}