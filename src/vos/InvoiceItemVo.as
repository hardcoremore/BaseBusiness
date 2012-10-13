package vos
{
	public class InvoiceItemVo
	{
		public var invoice_item_id:String;
		public var invoice_id:String;
		public var item_id:String;
		public var invoice_item_number:uint;
		public var invoice_item_amount:Number;
		public var invoice_item_price:Number;
		public var invoice_item_discount_percent:uint;
		public var invoice_item_discount_value:Number;
		public var invoice_item_tax_percent:uint;
		public var invoice_item_tax_value:Number;
		public var invoice_item_price_withot_tax:Number;
		public var invoice_item_price_with_tax:Number;
		
		public function InvoiceItemVo()
		{
		}
	}
}