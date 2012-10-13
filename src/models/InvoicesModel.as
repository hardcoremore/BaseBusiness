package models
{
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.core.service.ServiceLoader;
	import com.desktop.system.core.service.events.ServiceEvent;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.interfaces.IServiceReqester;
	import com.desktop.system.vos.ModelOperationResponseVo;
	import com.desktop.system.vos.ReadVo;
	import com.desktop.system.vos.ResourceConfigVo;
	import com.desktop.system.vos.WebServiceRequestVo;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLVariables;
	
	import spark.components.gridClasses.GridColumn;
	
	import vos.CustomersVo;
	
	public class InvoicesModel extends BaseModel
	{
		public static const CUSTOMERS_READ_OPERATION:String = "read"; 
		public static const CUSTOMERS_CREATE_OPERATION:String = "create";
		public static const CUSTOMERS_UPDATE_OPERATION:String = "update";
		
		public static const CUSTOMER_TYPE_BUYER:uint = 1;
		public static const CUSTOMER_TYPE_SUPPLIER:uint = 2;
		public static const CUSTOMER_TYPE_BOTH:uint = 3;
		
		public static const CUSTOMERS_DATA_HOLDER_ID:String = "invoicesDataHolder";
		
		public function InvoicesModel( resourceConfigVo:ResourceConfigVo, target:IEventDispatcher=null)
		{
			super( resourceConfigVo, target);
			CustomersVo;
		}
		
		public static function buyerSupplierLabel( item:Object, column:GridColumn ):String
		{
			return "Test";
		}
		
		public function read( read:ReadVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
				
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "customers";
				web.action = CUSTOMERS_READ_OPERATION;
				
				web.voClasses = new Object();
				web.voClasses.CustomersVo = "vos.CustomersVo";
				
			web.data = _getUrlVariablesFromVo( read );
			
			_startOperation( web, service );
		}
		
		public function create( customer:CustomersVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "customers";
				web.action = CUSTOMERS_CREATE_OPERATION;
			
			web.data = _getUrlVariablesFromVo( customer );
			
			_startOperation( web, service );
			
		}
		
		public function update( customer:CustomersVo, requester:IServiceReqester  ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "customers";
				web.action = CUSTOMERS_UPDATE_OPERATION;
			
			web.data = _getUrlVariablesFromVo( customer );
			
			_startOperation( web, service );
		}
	}
}