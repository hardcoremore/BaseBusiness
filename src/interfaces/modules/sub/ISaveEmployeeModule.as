package interfaces.modules.sub
{
	import com.desktop.system.interfaces.IModuleBase;
	
	import components.app.SaveData;
	
	import vos.EmployeesVo;

	public interface ISaveEmployeeModule extends IModuleBase
	{
		function get saveDataComponent():SaveData;
	}
}