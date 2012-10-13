package modules.sub
{
	import com.desktop.system.core.SystemModuleBase;
	
	import factories.ModelFactory;
	
	import interfaces.modules.sub.IEmployeeSalaryModule;
	
	import models.EmployeesModel;
	
	public class EmployeeSalaryModule extends SystemModuleBase implements IEmployeeSalaryModule
	{
		private var __employees_model:EmployeesModel;
		
		public function EmployeeSalaryModule()
		{
			super();
		}
		
		override public function init():void
		{
			super.init();
			
			__employees_model = ModelFactory.employeesModel();
			setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "employeeSalaryModule", this.session.skinsLocaleName ) );
		}
	}
}