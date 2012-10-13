package factories
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import interfaces.modules.sub.ISaveCustomerModule;
	
//	import modules.forms.NewAssociate;
	
	public class ModuleFactory extends EventDispatcher
	{
		private static var __instance:ModuleFactory;
		
		public function ModuleFactory(singleton:SingletonEnforcerer, target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static function get instance():ModuleFactory
		{
			if( __instance ) __instance = new ModuleFactory( new SingletonEnforcerer() );
			
			
			return __instance;
		}
		
		public function createINewAssociate( $template:String = null ):ISaveCustomerModule
		{
			//return new NewAssociate();
			
			return null;
		}
		
		
	}
}

class SingletonEnforcerer
{
}