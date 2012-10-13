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
	import vos.UserVo;
	
	public class UsersModel extends BaseModel
	{
		public static const USERS_READ_OPERATION:String = "read"; 
		public static const USERS_CREATE_OPERATION:String = "create";
		public static const USERS_UPDATE_OPERATION:String = "update";
		
		public static const USERS_DATA_HOLDER_ID:String = "usersDataHolder";
		
		public function UsersModel( resourceConfigVo:ResourceConfigVo, target:IEventDispatcher=null)
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
				web.module = "users";
				web.action = USERS_READ_OPERATION;
				
				web.voClasses = new Object();
				web.voClasses.UserVo = "vos.UserVo";
				
				web.data = _getUrlVariablesFromVo( read );
			
			_startOperation( web, service );
		}
		
		public function create( user:UserVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "users";
				web.action = USERS_CREATE_OPERATION;
			
				web.data = _getUrlVariablesFromVo( user );
			
			_startOperation( web, service );
			
		}
		
		public function update( user:UserVo, requester:IServiceReqester  ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "users";
				web.action = USERS_UPDATE_OPERATION;
			
				web.data = _getUrlVariablesFromVo( user );
			
			_startOperation( web, service );
		}
	}
}