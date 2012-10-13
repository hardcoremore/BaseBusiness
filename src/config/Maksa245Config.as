package config
{
	import com.desktop.system.core.service.ServiceReturnType;
	import com.desktop.system.interfaces.IConfig;
	import com.desktop.system.vos.ApplicationConfigVo;
	import com.desktop.system.vos.LocaleConfigVo;
	import com.desktop.system.vos.ResourceConfigVo;
	import com.desktop.ui.vos.DesktopConfigVo;
	import com.desktop.ui.vos.ResourceHolderVo;
	
	import flash.events.EventDispatcher;
	
	import mx.core.Singleton;
	
	[Bindable("__NoChangeEvent__")]
	public class Maksa245Config extends EventDispatcher implements IConfig
	{
		private static var __ac:ApplicationConfigVo;
		private static var __dc:DesktopConfigVo;
		private static var __rc:ResourceConfigVo;
		private static var __lc:LocaleConfigVo;
		
		public function Maksa245Config()
		{
			__ac  = new ApplicationConfigVo();
			__dc  = new DesktopConfigVo();
			__rc  = new ResourceConfigVo();
			__lc  = new LocaleConfigVo();
		}
		
		public function get APPLICATION_CONFIG():ApplicationConfigVo
		{
			__ac.autoLock = true;
			__ac.loginRequired = true;
			
			return __ac;
		}
		
		
		public function get DESKTOP_CONFIG():DesktopConfigVo
		{
			__dc.notificationAutoCloseTime = 3000;
			return __dc;
		}
		
		
		public function get RESOURCE_CONFIG():ResourceConfigVo
		{	
			__rc.moduleBasePath = "modules/";
			__rc.serviceBasePath = "http://193.34.144.245/BusinessBaseOs/index.php/";	
			__rc.serviceReturnType = ServiceReturnType.XML;
			__rc.postArrayDelimiter = "_A_";
			
			return __rc;
		}
		
		public function get LOCALE_CONFIG():LocaleConfigVo
		{
			__lc.dictonaryResourceName = "base";
			__lc.messagesResourceName = "messages";
			__lc.resourceModulePath = "resourceModules/";
			__lc.skinsResourceName = "skinClasses";
			__lc.systemIconsResourceName = "systemIconClasses";
			
			return __lc;
		}
		
	}
}