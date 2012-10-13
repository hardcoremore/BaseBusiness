package vos
{
	public class CustomersVo extends Object
	{
		public var customer_id:String;
		public var customer_code:String;
		public var customer_sales_type:uint;
		public var customer_tax_enabled:Boolean;
		public var customer_vat_value:uint;
		
		public var customer_name:String;
		public var customer_telephone:String;
		public var customer_telephone2:String;
		public var customer_mobile:String;
		public var customer_mobile2:String;
		public var customer_contact_person:String;
		
		public var customer_country:uint;
		public var customer_zip_code:uint;
		public var customer_city:String;
		public var customer_address:String;
		
		public var customer_email_address:String;
		
		public var customer_company_number:String;
		public var customer_company_vat_number:String;
		public var customer_company_tax_number:String;
		
		public var customer_since:String;
		public var customer_note:String;
		
		
		public var customer_bank_account:String;
		public var customer_bank_account2:String;
		public var customer_bank_account3:String;
		
		
		public var customer_currency:String;
		public var customer_credit_limit:Number;
		public var customer_credit_status:uint;
		
		public function CustomersVo()
		{
			
		}
	}
}