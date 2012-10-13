package modules.sub
{
	import com.desktop.system.core.SystemModuleBase;
	import com.desktop.system.events.ComponentCRUDEvent;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.utility.CommonErrorType;
	import com.desktop.ui.vos.ResourceHolderVo;
	
	import components.DataGridColumnSelector;
	
	import factories.ModelFactory;
	
	import interfaces.modules.sub.IEmployeesConfigModule;
	
	import models.EmployeesModel;
	import models.SystemModel;
	
	import mx.collections.ArrayList;
	import mx.events.FlexEvent;
	import mx.states.OverrideBase;
	
	import skins.Default.modules.sub.EmployeesConfigModuleSkin;
	
	import spark.components.DataGrid;
	
	import vos.DataHolderColumnVo;
	
	public class EmployeesConfigModule extends SystemModuleBase implements IEmployeesConfigModule
	{
		private var __employeesModel:EmployeesModel;
		private var __systemModel:SystemModel;
		
		[SkinPart(required="false")]
		public var employeesColumnSelector:DataGridColumnSelector;
		
		private var __columns:ArrayList;
		
		public function EmployeesConfigModule()
		{
			super();
		}
		
		override public function init():void
		{
			super.init();
			//setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "employeesConfigModule", this.session.skinsLocaleName ) );
			
			setStyle( "skinClass", EmployeesConfigModuleSkin );
			
			__employeesModel = ModelFactory.employeesModel();
			__systemModel = ModelFactory.systemModel();
		}
		
		override public function set resourceHolderConfig(rhc:ResourceHolderVo):void
		{
			super.resourceHolderConfig = rhc;
			
			if( resourceHolderConfig ) resourceHolderConfig.height = 600;
		}
		
		override public function set data(d:Object):void
		{
			if( d is ArrayList )
			{
				__columns = d as ArrayList;
			}
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == employeesColumnSelector )
			{
				employeesColumnSelector.addEventListener( ComponentCRUDEvent.SAVE, _employeesColumnSelectorSaveEventHandler );
			}
		}

		protected function _employeesColumnSelectorSaveEventHandler( event:ComponentCRUDEvent ):void
		{			
			if( ! event.data )
			{
				notifyCommonError( CommonErrorType.PROGRAM, SystemModel.SYSTEM_SAVE_DATA_HOLDER_COLUMNS_OPERATION );
				return;
			}
			
			__systemModel.saveDataHolderColumns( ( event.data as ArrayList ).source, EmployeesModel.EMPLOYEES_DATA_HOLDER_ID, this.session.user.user_id, this );
		}
		
		override protected function _creationComplete(event:FlexEvent):void
		{
			employeesColumnSelector.data = __columns;
		}
	}
}