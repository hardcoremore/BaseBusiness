package factories
{
	import com.desktop.system.interfaces.IConfig;
	import com.desktop.system.vos.LocaleConfigVo;
	
	import config.LocalConfig;
	import config.Maksa245Config;
	
	import flash.events.EventDispatcher;

	public class ConfigFactory extends EventDispatcher
	{
		private static var __localConfig:IConfig;
		
		private static var __lastConfig:IConfig;
		
		public function ConfigFactory()
		{
		}
		
		public static function get lastConfig():IConfig
		{
			return __lastConfig;
		}
		
		public static function createLocalConfig():IConfig
		{
			if( ! __localConfig )
				__localConfig = new LocalConfig();
		
			__lastConfig = __localConfig;
			return __localConfig;
		}
		
		public static function createStagingConfig():IConfig
		{
			var c:IConfig = new Maksa245Config();
			__lastConfig = c;
			
			return c;
		}
		
		public static function createLiveConfig():IConfig
		{
			var c:IConfig = new LocalConfig();
			
			return c;
		}
		
	}
}