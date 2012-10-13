package models
{
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.core.service.ServiceLoader;
	import com.desktop.system.core.service.events.ServiceEvent;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.interfaces.IServiceReqester;
	import com.desktop.system.utility.CrudOperations;
	import com.desktop.system.utility.SystemUtility;
	import com.desktop.system.vos.ModelOperationResponseVo;
	import com.desktop.system.vos.ReadVo;
	import com.desktop.system.vos.ResourceConfigVo;
	import com.desktop.system.vos.UpdateTableFieldVo;
	import com.desktop.system.vos.WebServiceRequestVo;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.net.URLVariables;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.utils.object_proxy;
	
	import spark.components.gridClasses.GridColumn;
	
	import vos.AcgVo;
	import vos.StorageItemCategoryVo;
	import vos.StorageItemVo;
	import vos.StorageVo;
	
	public class PrivilegesModel extends BaseModel
	{
		// employees
		public static const PRIVILEGES_CREATE_ACG_OPERATION:String = "createAcg";
		public static const PRIVILEGES_READ_ACG_OPERATION:String = "readAcg";
		public static const PRIVILEGES_UPDATE_ACG_OPERATION:String = "updateAcg";
		public static const PRIVILEGES_READ_ACG_SELECT_OPERATION:String = "readPrivilegesForSelect";
		
		private var __privileges:ModelOperationResponseVo;
		
		public function PrivilegesModel( resourceConfigVo:ResourceConfigVo, target:IEventDispatcher=null )
		{
			super( resourceConfigVo, target);
			__privileges = new ModelOperationResponseVo();	
		}
		
		// ACCESS CONTROL GROUP
		public function createAcg( item:AcgVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
				
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "privileges";
				web.action = PRIVILEGES_CREATE_ACG_OPERATION;
			
				web.data = _getUrlVariablesFromVo( item );
			
			_startOperation( web, service );
		}
		
		public function readAcgs( read:ReadVo, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
				
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "privileges";
				web.action = PRIVILEGES_READ_ACG_OPERATION;
				
				web.voClasses = new Object();
			    web.voClasses.AcgVo = "vos.AcgVo";
				
			web.data = _getUrlVariablesFromVo( read );
			
			_startOperation( web, service );	
			
		}
				
		public function updateItem( item:StorageItemVo, requester:IServiceReqester  ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
				
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "privileges";
				web.action = PRIVILEGES_UPDATE_ACG_OPERATION;
			
			web.data = _getUrlVariablesFromVo( item );
			
			_startOperation( web, service );
		}
	
		
		
		
		public function readPrivilegesForSelect( requester:IServiceReqester ):void
		{
			if( __privileges )
			{
				var e:ModelDataChangeEvent = new ModelDataChangeEvent( ModelDataChangeEvent.MODEL_LOADING_DATA_COMPLETE );
					e.operationName =  PRIVILEGES_READ_ACG_SELECT_OPERATION;
					e.response = __privileges;
					e.requester = requester;
				
				dispatchEvent( e );
				
				if( requester )
					requester.modelLoadingDataComplete( e );
			}
			
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "privileges";
				web.action = PRIVILEGES_READ_ACG_SELECT_OPERATION;
			
			web.voClasses = new Object();
			web.voClasses.AcgVo = "vos.AcgVo";
			
			_startOperation( web, service );
		}
		
		override protected function _finishOperation( serviceEvent:ServiceEvent, dispatch:Boolean = true ):ModelOperationResponseVo
		{
			var op:ModelOperationResponseVo = super._finishOperation( serviceEvent, false );
			var service:ServiceLoader = serviceEvent.target as ServiceLoader;
			
			if( op.status == STATUS_OK )
			{
				
				if( service.name == PRIVILEGES_CREATE_ACG_OPERATION || service.name == PRIVILEGES_UPDATE_ACG_OPERATION )
				{
					__privileges = null;
					readPrivilegesForSelect( null );
				}
			}
			
			_dispatchOperationResponse( serviceEvent, op );
			
			return op;
		}
		
	}
}