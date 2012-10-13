package interfaces.modules.sub
{
	import com.desktop.system.interfaces.IModuleBase;
	
	import components.app.SaveData;

	public interface ISaveCustomerModule extends IModuleBase
	{		   
		function get saveDataComponent():SaveData;
	}
}