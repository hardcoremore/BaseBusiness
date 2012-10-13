package factories
{
	import com.desktop.system.vos.ResourceConfigVo;
	
	import models.AuthenticationModel;
	import models.CustomersModel;
	import models.DesktopModel;
	import models.EmployeesModel;
	import models.PrivilegesModel;
	import models.StorageModel;
	import models.SystemModel;
	import models.UsersModel;

	public class ModelFactory
	{	
		public function ModelFactory()
		{
		}
		
		
		private static var __authM:AuthenticationModel;
		public static function authenticationModel():AuthenticationModel
		{
			if( ! __authM ) __authM = new AuthenticationModel( ConfigFactory.lastConfig.RESOURCE_CONFIG );
			return __authM;
		}
		
		private static var __dcm:DesktopModel;
		public static function desktopModel():DesktopModel
		{
			if( ! __dcm ) __dcm = new DesktopModel( ConfigFactory.lastConfig.RESOURCE_CONFIG );
			return __dcm;
		}
		
		private static var __customersM:CustomersModel;
		public static function customersModel():CustomersModel
		{
			if( ! __customersM ) __customersM = new CustomersModel( ConfigFactory.lastConfig.RESOURCE_CONFIG );
			return __customersM;
		}
		
		private static var __employeeM:EmployeesModel;
		public static function employeesModel():EmployeesModel
		{
			if( ! __employeeM ) __employeeM = new EmployeesModel( ConfigFactory.lastConfig.RESOURCE_CONFIG );
			return __employeeM;
		}
		
		private static var __systemM:SystemModel;
		public static function systemModel():SystemModel
		{
			if( ! __systemM ) __systemM = new SystemModel( ConfigFactory.lastConfig.RESOURCE_CONFIG );
			return __systemM;
		}
		
		private static var __storageModel:StorageModel;
		public static function storageModel():StorageModel
		{
			if( ! __storageModel ) __storageModel = new StorageModel( ConfigFactory.lastConfig.RESOURCE_CONFIG );
			return __storageModel;
		}
		
		private static var __usersModel:UsersModel;
		public static function usersModel():UsersModel
		{
			if( ! __usersModel ) __usersModel = new UsersModel( ConfigFactory.lastConfig.RESOURCE_CONFIG );
			return __usersModel;
		}
		private static var __privilegesModel:PrivilegesModel;
		public static function privilegesModel():PrivilegesModel
		{
			if( ! __privilegesModel ) __privilegesModel = new PrivilegesModel( ConfigFactory.lastConfig.RESOURCE_CONFIG );
			return __privilegesModel;
		}
	}
}