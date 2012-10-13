package vos
{
	public class InvoiceVo
	{
		public var invoice_id:String;
		public var invoice_code:String;
		public var invoice_year:uint;
		public var invoice_creation_date:String;
		public var invoice_number:uint;
		public var invoice_prefix:String;
		public var invoice_type:uint;
		public var invoice_customer_id:uint;
		public var invoice_price_without_tax:Number;
		public var invoice_tax_percent:uint;
		public var invoice_tax_value:Number;
		public var invoice_number_items:int;
		public var invoice_total_amount:Number;
		public var invoice_total_price_bruto:Number;
		public var invoice_total_discount:Number;
		public var invoice_payed_total:Number;
		public var invoice_amount_to_pay:Number;
		public var invoice_place:String;
		public var invoice_date:String;
		public var invoice_days_to_pay:uint;
		public var invoice_payment_due_date:String;
		public var invoice_note:String;
		public var user_id:String;
		public var user_name:String;
		
		public function InvoiceVo()
		{
		}
	}
}