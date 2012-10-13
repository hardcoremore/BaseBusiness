package interfaces.modules.sub
{
	import com.desktop.system.interfaces.IModuleBase;
	
	import components.app.SaveData;

	public interface ISaveInvoiceModule extends IModuleBase
	{		   
		function get saveDataComponent():SaveData;
	}
}