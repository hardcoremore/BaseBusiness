package modules.sub
{
	import com.desktop.system.core.SystemModuleBase;
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.vos.UpdateTableFieldVo;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.utility.SystemUtility;
	import com.desktop.system.vos.NotificationVo;
	import com.desktop.system.vos.ReadVo;
	import com.desktop.ui.Components.Button.DesktopControllButton;
	
	import factories.ModelFactory;
	
	import flash.events.MouseEvent;
	
	import interfaces.modules.sub.IEmployeeEconomicsModule;
	
	import models.EmployeesModel;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.events.FlexEvent;
	
	import spark.components.DataGrid;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.GridEvent;
	import spark.events.GridItemEditorEvent;
	
	import vos.EmployeeEconomicsVo;
	
	public class EmployeeEconomicsModule extends SystemModuleBase implements IEmployeeEconomicsModule
	{
		
		[SkinPart(required="false")]
		public var newEmployeeEconomicsButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var refreshEconomicsButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var deleteEmployeeEconomicsButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var employeeEconomicsDataHolder:SkinnableComponent;
		
		private var __employee_model:EmployeesModel;
		private var __current_editing_row:EmployeeEconomicsVo;
		
		public function EmployeeEconomicsModule()
		{
			super();
		}
		
		override public function init():void
		{
			super.init();
			
			__employee_model = ModelFactory.employeesModel();
			setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "employeeEconomicsModule", this.session.skinsLocaleName ) );
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == newEmployeeEconomicsButton )
			{
				newEmployeeEconomicsButton.addEventListener( MouseEvent.CLICK, _createEmployeeEconomicsButtonClickHandler );
			}
			else if( instance == refreshEconomicsButton )
			{
				refreshEconomicsButton.addEventListener( MouseEvent.CLICK, _refreshEmployeeEcnomicsButtonClickHandler );
			}
			else if( instance == deleteEmployeeEconomicsButton )
			{
				deleteEmployeeEconomicsButton.addEventListener( MouseEvent.CLICK, _deleteEmployeeEconomicsButtonClickHandler );
			}
			
			else if( instance == employeeEconomicsDataHolder )
			{
				( employeeEconomicsDataHolder as DataGrid ).addEventListener( GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE, _economicsDataHolderSaveEventHandler );
				( employeeEconomicsDataHolder as DataGrid ).addEventListener( GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_START, _economicDataHolderStartEditEventHandler );
				( employeeEconomicsDataHolder as DataGrid ).dataProvider = new ArrayList();
			}
			
		}
		
		
		protected function _createEmployeeEconomicsButtonClickHandler( event:MouseEvent ):void
		{
			var e:EmployeeEconomicsVo = new EmployeeEconomicsVo();
				e.employee_economics_name = "NEW";
				
			__employee_model.createEconomic( e, this );	
		}
		
		protected function _refreshEmployeeEcnomicsButtonClickHandler( event:MouseEvent ):void
		{
			_readEconomics();
		}
		
		protected function _deleteEmployeeEconomicsButtonClickHandler( event:MouseEvent ):void
		{
			
		}
		
		
		protected function _economicDataHolderStartEditEventHandler( event:GridItemEditorEvent ):void
		{
			var e:EmployeeEconomicsVo = ( ( employeeEconomicsDataHolder as DataGrid ).dataProvider as ArrayList ).getItemAt( event.rowIndex ) as EmployeeEconomicsVo;
			__current_editing_row = SystemUtility.clone( e ) as EmployeeEconomicsVo;
		}
		
		protected function _economicsDataHolderSaveEventHandler( event:GridItemEditorEvent ):void
		{
			event.preventDefault();
			
			var e:EmployeeEconomicsVo = ( ( employeeEconomicsDataHolder as DataGrid ).dataProvider as ArrayList ).getItemAt( event.rowIndex ) as EmployeeEconomicsVo;
			
			var update:UpdateTableFieldVo = new UpdateTableFieldVo();
				update.id_value = e.employee_economics_id.toString();
				update.value_name = event.column.dataField;
				update.value = e[ event.column.dataField ];
				
			__employee_model.updateEconomicField( update, this );
		}
		
		
		
		override public function modelLoadingDataComplete(event:ModelDataChangeEvent):void
		{
			super.modelLoadingDataComplete( event );
			
			if( event.operationName == EmployeesModel.EMPLOYEE_CREATE_ECONOMIC_OPERATION )
			{
				( ( employeeEconomicsDataHolder as DataGrid ).dataProvider as ArrayList ).addItemAt( event.response.result, 0 );
			}
			else if( event.operationName == EmployeesModel.EMPLOYEE_READ_ECONOMICS_OPERATION )
			{
				( employeeEconomicsDataHolder as DataGrid ).dataProvider = event.response.result as IList;
			}
				
		}
		
		override public function modelLoadingDataError(event:ModelDataChangeEvent):void
		{
			super.modelLoadingDataError(event);
			
			if( event.operationName == EmployeesModel.EMPLOYEE_UPDATE_ECONOMIC_FIELD_OPERATION )
			{
				( ( employeeEconomicsDataHolder as DataGrid ).dataProvider as ArrayList ).setItemAt( __current_editing_row, ( employeeEconomicsDataHolder as DataGrid ).selectedIndex );
				var nvo:NotificationVo = new NotificationVo();
				nvo.icon = resourceManager.getClass( 'systemIconClasses', 'deleteErrorIcon', session.skinsLocaleName );
				nvo.title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "error" );
				nvo.text = resourceManager.getString( this.session.config.LOCALE_CONFIG.messagesResourceName, "serverError" );
				nvo.okButton = true;
				notify( nvo );	
			}
		}
		
		override protected function _creationComplete(event:FlexEvent):void
		{
			super._creationComplete(event);
			_readEconomics();
		}
		
		protected function _readEconomics():void
		{
			var r:ReadVo = new ReadVo();
				r.sortColumnName = "employee_economics_id";
				r.sortColumnDirection = BaseModel.SORT_DIRECTION_DESCENDING;
			
			__employee_model.readEconomics( r, this );
		}
		
	}
}