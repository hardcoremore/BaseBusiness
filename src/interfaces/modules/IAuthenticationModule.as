package interfaces.modules
{
	import com.desktop.system.core.ApplicationBase;
	
	import flash.events.IEventDispatcher;
	
	import mx.validators.StringValidator;

	public interface IAuthenticationModule extends IEventDispatcher
	{
		function set application( app:ApplicationBase ):void;
		function get mode():uint;
	}
}