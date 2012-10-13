package models
{
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.core.service.ServiceLoader;
	import com.desktop.system.interfaces.IServiceReqester;
	import com.desktop.system.utility.ModelReadParameters;
	import com.desktop.system.utility.SystemUtility;
	import com.desktop.system.vos.ResourceConfigVo;
	import com.desktop.system.vos.WebServiceRequestVo;
	
	import flash.events.IEventDispatcher;
	import flash.net.URLVariables;
	
	import mx.collections.ArrayList;
	
	import vos.DataHolderColumnVo;
	
	public class SystemModel extends BaseModel
	{
		
		public static const SYSTEM_SAVE_DATA_HOLDER_COLUMNS_OPERATION:String = "saveDataHolderColumns";
		public static const SYSTEM_READ_DATA_HOLDER_COLUMNS_OPERATION:String = "readDataHolderColumns";
		
		public static const DATA_HOLDER_COLUMNS_NAME:String = "_data_holder_columns_";
		
		
		public static const DATA_HOLDER_ITEM_VISIBLE_TRUE:int = 1;
		public static const DATA_HOLDER_ITEM_VISIBLE_FALSE:int = 0;
		
		public static const DATA_HOLDER_CUSTOM_HEADER_TEXT_TRUE:int = 1;
		public static const DATA_HOLDER_CUSTOM_HEADER_TEXT_FALSE:int = 0;
		
		
		public function SystemModel(resourceConfigVo:ResourceConfigVo, target:IEventDispatcher=null)
		{
			super(resourceConfigVo, target);
		}
		
		public function saveDataHolderColumns( columns:Array, dataHolderId:String, userId:String, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "system";
				web.action = SYSTEM_SAVE_DATA_HOLDER_COLUMNS_OPERATION; 
			
			web.data = buildUrlVarialbesFromAssociateArray( columns, DATA_HOLDER_COLUMNS_NAME );
			
			var col:DataHolderColumnVo;
			for( var i:uint = 0; i < columns.length; i++ )
			{
				col = columns[ i ] as DataHolderColumnVo;
				col.data_holder_column_user_id = userId;
				col.data_holder_id = dataHolderId;
			}
			
			_startOperation( web, service );
		}
		
		public function readDataHolderColumns( dataHolderId:String, userId:String, requester:IServiceReqester ):void
		{
			var service:ServiceLoader = new ServiceLoader();
				service.requester = requester;
			
			var web:WebServiceRequestVo = new WebServiceRequestVo();
				web.module = "system";
				web.action = SYSTEM_READ_DATA_HOLDER_COLUMNS_OPERATION;
				
			web.voClasses = new Object();
			web.voClasses.DataHolderColumnVo = "vos.DataHolderColumnVo";
			
			web.data = new URLVariables();
			web.data.data_holder_id = dataHolderId;	
			web.data.user_id = userId;
			
			_startOperation( web, service );
		}
	}
}