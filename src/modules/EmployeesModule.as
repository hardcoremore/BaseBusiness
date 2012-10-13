package modules
{
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.core.SystemModuleBase;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.events.ResourceEvent;
	import com.desktop.system.interfaces.ILoadResourceRequester;
	import com.desktop.system.interfaces.IModuleBase;
	import com.desktop.system.utility.CrudOperations;
	import com.desktop.system.utility.ResourceLoadStatus;
	import com.desktop.system.utility.ResourceTypes;
	import com.desktop.system.vos.LoadResourceRequestVo;
	import com.desktop.system.vos.NotificationVo;
	import com.desktop.system.vos.ReadVo;
	import com.desktop.ui.Components.Button.DesktopControllButton;
	import com.desktop.ui.Components.Window.DesktopAlert;
	import com.desktop.ui.vos.ResourceHolderVo;
	
	import components.Paging;
	import components.app.SaveData;
	import components.events.PageEvent;
	import components.events.SaveDataEvent;
	
	import factories.ModelFactory;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import interfaces.modules.IEmployeesModule;
	import interfaces.modules.sub.IEmployeeCostsAndStimulationsModule;
	import interfaces.modules.sub.IEmployeeEconomicsModule;
	import interfaces.modules.sub.IEmployeeSalaryModule;
	import interfaces.modules.sub.IEmployeeWorkSheetModule;
	import interfaces.modules.sub.IEmployeeWorkingScenarioModule;
	import interfaces.modules.sub.IEmployeesConfigModule;
	import interfaces.modules.sub.ISaveEmployeeModule;
	
	import models.EmployeesModel;
	import models.SystemModel;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.collections.XMLListCollection;
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.resources.ResourceManager;
	
	import spark.components.DataGrid;
	import spark.components.gridClasses.GridColumn;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.events.GridSelectionEvent;
	import spark.events.GridSortEvent;
	
	import vos.DataHolderColumnVo;
	import vos.EmployeesVo;
	
	public class EmployeesModule extends SystemModuleBase implements IEmployeesModule, ILoadResourceRequester
	{
		
		[SkinPart(required="false")]
		public var newEmployeeButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var updateEmployeeButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var employeeEconomicsButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var employeeCostsAndStimulationsButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var workingScenarioButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var workSheetButton:DesktopControllButton;
		
		[SkinPart(required="false")]
		public var employeeSalaryButton:DesktopControllButton;
		
		[SkinPart(required="true")]
		public var employeesPaging:Paging;
		
		[SkinPart(required="true")]
		public var employeesDataHolder:DataGrid;
		
		
		//EmployeeSalaryModule
		
		private var __saveEmployeeModule:ISaveEmployeeModule;
		private var __updateEmployeeModule:ISaveEmployeeModule;
		private var __workingScenarioModule:IEmployeeWorkingScenarioModule;
		private var __workSheetModule:IEmployeeWorkSheetModule;
		private var __employeeSalaryModule:IEmployeeSalaryModule;
		private var __employeeEconomicsModule:IEmployeeEconomicsModule;
		private var __employeeCostsAndStimulationsModule:IEmployeeCostsAndStimulationsModule;
		private var __employeesConfigModule:IEmployeesConfigModule;
		
		private var __saveEmployeeLRV:LoadResourceRequestVo;
		
		private var __employeesDataHolderColumns:IList;
		
		private var __employees_model:EmployeesModel;
		private var __selected_employee:EmployeesVo;
		
		
		public function EmployeesModule()
		{
			super()
		}
		
		override public function init():void
		{
			super.init();
			
			__employees_model = ModelFactory.employeesModel();
			__employees_model.addEventListener( ModelDataChangeEvent.MODEL_LOADING_DATA_COMPLETE, _modelLoadingDataCompleteEventHandler );
			
			setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "employeesModule", this.session.skinsLocaleName ) );
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded( partName, instance );
			
			if( instance == newEmployeeButton )
			{
				newEmployeeButton.addEventListener( MouseEvent.CLICK, _saveEmployeeButtonClickHandler );
			}
			else if( instance == updateEmployeeButton )
			{
				updateEmployeeButton.addEventListener( MouseEvent.CLICK, _saveEmployeeButtonClickHandler );
			}
			else if( instance == employeeEconomicsButton )
			{
				employeeEconomicsButton.addEventListener( MouseEvent.CLICK, _employeeEconomicsButtonClickHandler );
			}
			else if( instance == employeeCostsAndStimulationsButton )
			{
				employeeCostsAndStimulationsButton.addEventListener( MouseEvent.CLICK, _employeeCostsAndStimulationsButtonClickHandler );
			}
			else if( instance == workingScenarioButton )
			{
				workingScenarioButton.addEventListener( MouseEvent.CLICK, _workingScenarioButtonClickHandler );
			}
			else if( instance == workSheetButton )
			{
				workSheetButton.addEventListener( MouseEvent.CLICK, _workSheetButtonClickHandler );
			}
			else if( instance == employeeSalaryButton )
			{
				employeeSalaryButton.addEventListener( MouseEvent.CLICK, _salaryButtonClickHandler );
			}
			else if( instance == employeesPaging )
			{
				employeesPaging.addEventListener( PageEvent.PAGE_CHANGE, _employeesPagingChangeEventHandler );
			}
			else if( instance == employeesDataHolder )
			{
				employeesDataHolder.addEventListener( GridSortEvent.SORT_CHANGING, _employeesSortChangingEventHandler );
				employeesDataHolder.addEventListener( GridSelectionEvent.SELECTION_CHANGE, _employeesDataHolderSelectionChange );
				employeesDataHolder.addEventListener( FlexEvent.VALUE_COMMIT, _employeesDataHolderSelectionChange );
				
				__employeesDataHolderColumns = _createColumnVos( employeesDataHolder.columns );
				
				_readEmployeesColumns();
			} 
		
		}
		
		protected function _employeesSortChangingEventHandler( event:GridSortEvent ):void
		{
			event.preventDefault();
		}
		
		protected function _employeesDataHolderSelectionChange( event:Event ):void
		{
			__selected_employee = ( employeesDataHolder as DataGrid ).selectedItem as EmployeesVo;
			
			if( __updateEmployeeModule )
				__updateEmployeeModule.data = __selected_employee;
			
			if( __workSheetModule )
				__workSheetModule.data = __selected_employee;
			
			if( __employeeCostsAndStimulationsModule )
				__employeeCostsAndStimulationsModule.data = __selected_employee;
		}
		
		protected function _modelLoadingDataCompleteEventHandler( event:ModelDataChangeEvent ):void
		{
			if( event.operationName == EmployeesModel.EMPLOYEE_UPDATE_OPERATION )
			{				
				if( __updateEmployeeModule )
					employeesDataHolder.dataProvider.itemUpdated( __updateEmployeeModule.data as EmployeesVo );
			}
		}
		
		override public function modelLoadingData(event:ModelDataChangeEvent):void
		{
			if( event.operationName == EmployeesModel.EMPLOYEE_READ_OPERATION )
			{
				employeesDataHolder.enabled = false;
			}
		}
		
		override public function modelLoadingDataComplete(event:ModelDataChangeEvent ):void
		{
			if( event.operationName == EmployeesModel.EMPLOYEE_READ_OPERATION )
			{
				employeesDataHolder.enabled = true;
				
				var sdc:SaveData;
				
				if( __updateEmployeeModule )
					sdc = __updateEmployeeModule.saveDataComponent;
				
				_updateReadData( event.response, employeesDataHolder, employeesPaging, sdc );
				
				__selected_employee = null;
			}
			else if( event.operationName == SystemModel.SYSTEM_READ_DATA_HOLDER_COLUMNS_OPERATION )
			{
				var cols:IList = event.response.result as IList;
				
				employeesDataHolder.columns = setupDataGridColumns( __employeesDataHolderColumns, cols );
				__employeesDataHolderColumns = cols;
			}
		}	
		
		protected function _saveEmployeeButtonClickHandler( event:MouseEvent ):void
		{
			var title:String;
			var icon:Class;
			
			if( event.currentTarget == newEmployeeButton )
			{
				if( __saveEmployeeModule )
				{
					if( __saveEmployeeModule.resourceHolder )
						__saveEmployeeModule.resourceHolder.toFront();
					
					return;
				}
				else
				{
					title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "newEmployee" );
					icon = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "addIcon", this.session.skinsLocaleName );
					newEmployeeButton.enabled = false;
				}
			}
			else if( event.currentTarget == updateEmployeeButton )
			{
				if( __updateEmployeeModule )
				{
					if( __updateEmployeeModule.resourceHolder )
						__updateEmployeeModule.resourceHolder.toFront();
					
					return;
				}
				else
				{
					title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "updateEmployee" );
					icon = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "updateIcon", this.session.skinsLocaleName );
					updateEmployeeButton.enabled = false;
				}
			}
			
			var lvo:LoadResourceRequestVo = new LoadResourceRequestVo(
				event.currentTarget.id,
				this.session.config.RESOURCE_CONFIG.moduleBasePath + "sub/" + "SaveEmployeeModule.swf",
				ResourceTypes.MODULE, 
				title, 
				icon
			);
			
			lvo.createResourceHolderAutomatically = true;
			lvo.requester = this;
			lvo.getNew = true;
			
			var rhc:ResourceHolderVo = new ResourceHolderVo();
				rhc.child = true;
				rhc.parent = this.resourceHolder;
				rhc.cObject = event.currentTarget as IVisualElement;
				rhc.hideOnClose = true;
				rhc.title = title;
				rhc.titleBarIcon = icon;
				rhc.resizable = true;
			
			lvo.resourceHolderConfig = rhc;
			
			var e:ResourceEvent = new ResourceEvent( ResourceEvent.RESOURCE_LOAD_REQUEST, true );
				e.resourceInfo = lvo;
			
			dispatchEvent( e );
		}
		
		protected function _employeeEconomicsButtonClickHandler( event:MouseEvent ):void
		{
			if( __employeeEconomicsModule )
			{
				__employeeEconomicsModule.resourceHolder.toFront();
				return;	
			}
			
			var title:String = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "employeeEconomics" );
			var icon:Class = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "employeeEconomicsIcon", this.session.skinsLocaleName );
			
			employeeEconomicsButton.enabled = false;
			
			var lvo:LoadResourceRequestVo = new LoadResourceRequestVo(
				event.currentTarget.id,
				this.session.config.RESOURCE_CONFIG.moduleBasePath + "sub/" + "EmployeeEconomicsModule.swf",
				ResourceTypes.MODULE, 
				title, 
				icon
			);
			
			lvo.createResourceHolderAutomatically = true;
			lvo.requester = this;
			lvo.getNew = true;
			
			var rhc:ResourceHolderVo = new ResourceHolderVo();
				rhc.hideOnClose = true;
				rhc.title = title;	
				rhc.titleBarIcon = icon;
				rhc.resizable = true;
				rhc.minimizable = true;
				rhc.maximizable = true;
			
			lvo.resourceHolderConfig = rhc;
			
			var e:ResourceEvent = new ResourceEvent( ResourceEvent.RESOURCE_LOAD_REQUEST, true );
			e.resourceInfo = lvo;
			
			dispatchEvent( e );
			
		
		}
		
		protected function _employeeCostsAndStimulationsButtonClickHandler( event:MouseEvent ):void
		{
			if( __employeeCostsAndStimulationsModule )
			{
				__employeeCostsAndStimulationsModule.resourceHolder.toFront();
				return;	
			}
			
			var title:String = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "employeeCostsAndStimulation" );
			var icon:Class = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "calculatorIcon", this.session.skinsLocaleName );
			
			employeeCostsAndStimulationsButton.enabled = false;
			
			var lvo:LoadResourceRequestVo = new LoadResourceRequestVo(
				event.currentTarget.id,
				this.session.config.RESOURCE_CONFIG.moduleBasePath + "sub/" + "EmployeeCostsAndStimulationModule.swf",
				ResourceTypes.MODULE, 
				title, 
				icon
			);
			
			lvo.createResourceHolderAutomatically = true;
			lvo.requester = this;
			lvo.getNew = true;
			
			var rhc:ResourceHolderVo = new ResourceHolderVo();
				rhc.child = true;
				rhc.parent = this.resourceHolder;
				rhc.cObject = event.currentTarget as IVisualElement;
				rhc.hideOnClose = true;
				rhc.title = title;
				rhc.titleBarIcon = icon;
				rhc.resizable = true;
					
			lvo.resourceHolderConfig = rhc;
			
			var e:ResourceEvent = new ResourceEvent( ResourceEvent.RESOURCE_LOAD_REQUEST, true );
				e.resourceInfo = lvo;
			
			dispatchEvent( e );
		}
		
		protected function _workingScenarioButtonClickHandler( event:MouseEvent ):void
		{
			if( __workingScenarioModule )
			{
				__workingScenarioModule.resourceHolder.toFront();
				return;	
			}
			
			var title:String = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "employeeWorkingScenario" );
			var icon:Class = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "reportIcon", this.session.skinsLocaleName );
			
			workingScenarioButton.enabled = false;
			
			var lvo:LoadResourceRequestVo = new LoadResourceRequestVo(
				event.currentTarget.id,
				this.session.config.RESOURCE_CONFIG.moduleBasePath + "sub/" + "EmployeeWorkingScenarioModule.swf",
				ResourceTypes.MODULE, 
				title, 
				icon
			);
			
			lvo.createResourceHolderAutomatically = true;
			lvo.requester = this;
			lvo.getNew = true;
			
			var rhc:ResourceHolderVo = new ResourceHolderVo();
				rhc.hideOnClose = true;
				rhc.title = title;	
				rhc.titleBarIcon = icon;
				rhc.resizable = true;
				rhc.minimizable = true;
				
			lvo.resourceHolderConfig = rhc;
			
			var e:ResourceEvent = new ResourceEvent( ResourceEvent.RESOURCE_LOAD_REQUEST, true );
				e.resourceInfo = lvo;
			
			dispatchEvent( e );
			
		}
		
		protected function _workSheetButtonClickHandler( event:MouseEvent ):void
		{
			if( __workSheetModule )
			{
				__workSheetModule.resourceHolder.toFront();
				return;	
			}
			
			var title:String = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "workSheet" );
			var icon:Class = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "scheduleIcon", this.session.skinsLocaleName );
			
			workSheetButton.enabled = false;
			
			var lvo:LoadResourceRequestVo = new LoadResourceRequestVo(
				event.currentTarget.id,
				this.session.config.RESOURCE_CONFIG.moduleBasePath + "sub/" + "EmployeeWorkSheetModule.swf",
				ResourceTypes.MODULE, 
				title, 
				icon
			);
			
			lvo.createResourceHolderAutomatically = true;
			lvo.requester = this;
			lvo.getNew = true;
			
			var rhc:ResourceHolderVo = new ResourceHolderVo();
				rhc.child = true;
				rhc.parent = this.resourceHolder;
				rhc.cObject = event.currentTarget as IVisualElement;
				rhc.hideOnClose = true;
				rhc.title = title;
				rhc.titleBarIcon = icon;
				rhc.resizable = true;
				rhc.maximizable  = true;
			
			lvo.resourceHolderConfig = rhc;
			
			var e:ResourceEvent = new ResourceEvent( ResourceEvent.RESOURCE_LOAD_REQUEST, true );
				e.resourceInfo = lvo;
			
			dispatchEvent( e );
			
		}
				
		protected function _salaryButtonClickHandler( event:MouseEvent ):void
		{
			if( __employeeSalaryModule )
			{
				__employeeSalaryModule.resourceHolder.toFront();
				return;	
			}
			
			var title:String = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "employeeSalary" );
			var icon:Class = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "billsIcon", this.session.skinsLocaleName );
			
			employeeSalaryButton.enabled = false;
			
			var lvo:LoadResourceRequestVo = new LoadResourceRequestVo(
				event.currentTarget.id,
				this.session.config.RESOURCE_CONFIG.moduleBasePath + "sub/" + "EmployeeSalaryModule.swf",
				ResourceTypes.MODULE, 
				title, 
				icon
			);
			
			lvo.createResourceHolderAutomatically = true;
			lvo.requester = this;
			lvo.getNew = true;
			
			var rhc:ResourceHolderVo = new ResourceHolderVo();
			rhc.child = true;
			rhc.parent = this.resourceHolder;
			rhc.cObject = event.currentTarget as IVisualElement;
			rhc.hideOnClose = true;
			rhc.title = title;
			rhc.titleBarIcon = icon;
			rhc.resizable = true;
			
			lvo.resourceHolderConfig = rhc;
			
			var e:ResourceEvent = new ResourceEvent( ResourceEvent.RESOURCE_LOAD_REQUEST, true );
				e.resourceInfo = lvo;
	
			dispatchEvent( e );
		}
		
		override protected function _configButtonClickEventHandler( event:MouseEvent ):void
		{
			if( ! __employeesConfigModule )
			{
				configButton.enabled = false;
				
				var lvo:LoadResourceRequestVo = new LoadResourceRequestVo(
					event.currentTarget.id,
					this.session.config.RESOURCE_CONFIG.moduleBasePath + "sub/" + "EmployeesConfigModule.swf",
					ResourceTypes.MODULE
				);
				
				var rhc:ResourceHolderVo = BaseModel.createConfigResourceHolderVo( resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "employees" ) );
					rhc.parent = resourceHolder;
					rhc.maximizable = false;
					
				lvo.createResourceHolderAutomatically = true;
				lvo.requester = this;
				lvo.getNew = true;
				
				lvo.resourceHolderConfig = rhc;
				
				var e:ResourceEvent = new ResourceEvent( ResourceEvent.RESOURCE_LOAD_REQUEST, true );
					e.resourceInfo = lvo;
					
				dispatchEvent( e );
			}
			else
			{
				_configResourceHolder.toFront();
			}
		}
													   
		override protected function _creationComplete( event:FlexEvent ):void
		{		
			super._creationComplete( event );
			_setupOrder( employeesDataHolder, employeesPaging );
			_readEmployees();
		}
		
		protected function _employeesPagingChangeEventHandler( event:PageEvent ):void
		{
			_readEmployees();
		}
		
		override public function get resourceHolderConfig():ResourceHolderVo
		{ 
			var rh:ResourceHolderVo = new ResourceHolderVo();
				rh.title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "employees" );
				rh.width = 1200;
				rh.height = 800;
				rh.maximizable = true;
				rh.resizable = true;
				rh.minimizable = true;
				rh.maximized = true;
				rh.titleBarIcon = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "employeesModuleIcon", this.session.skinsLocaleName );
			
			return rh;
		}
		
		public function updateResourceLoadStatus( resource:LoadResourceRequestVo ):void
		{
			if( resource.status.statusCode == ResourceLoadStatus.RESOURCE_LOAD_COMPLETED )
			{
				var mi:IModuleBase = resource.resource as IModuleBase;
				
				if( resource.resourceId == newEmployeeButton.id )
				{	
					__saveEmployeeModule = ISaveEmployeeModule( resource.resource );
					__saveEmployeeModule.resourceHolderConfig.parent = this.resourceHolder;
					
					__saveEmployeeModule.mode = CrudOperations.CREATE;
					
					newEmployeeButton.enabled = true;
				}
				else if( resource.resourceId == updateEmployeeButton.id )
				{
					__updateEmployeeModule = ISaveEmployeeModule( resource.resource );
					__updateEmployeeModule.resourceHolderConfig.parent = this.resourceHolder;
					
					__updateEmployeeModule.mode = CrudOperations.UPDATE;
					
					updateEmployeeButton.enabled = true;
					
					var si:Object = ( employeesDataHolder as DataGrid ).selectedItem;
					
					if( si ) 
						__updateEmployeeModule.data = si;
					
					__updateEmployeeModule.saveDataComponent.addEventListener( SaveDataEvent.PREVIEW_DATA_INDEX_CHANGE, _previewIndexChange );
					
					if( currentReadData )
					{
						__updateEmployeeModule.saveDataComponent.previewDataLength = currentReadData.numRows;
						
						if( employeesDataHolder )
							__updateEmployeeModule.saveDataComponent.previewDataIndex = ( employeesDataHolder as DataGrid ).selectedIndex;
					}
					
				}
				else if( resource.resourceId == workingScenarioButton.id )
				{
					__workingScenarioModule = IEmployeeWorkingScenarioModule( resource.resource );
					__workingScenarioModule.resourceHolderConfig.parent = this.resourceHolder;
					
					workingScenarioButton.enabled = true;
				}
				else if( resource.resourceId == workSheetButton.id )
				{
					__workSheetModule = IEmployeeWorkSheetModule( resource.resource );
					__workSheetModule.resourceHolderConfig.parent = this.resourceHolder;
					__workSheetModule.data = __selected_employee;
					
					workSheetButton.enabled = true;
				}
				else if( resource.resourceId == employeeSalaryButton.id )
				{
					__employeeSalaryModule = IEmployeeSalaryModule( resource.resource );
					__employeeSalaryModule.resourceHolderConfig.parent = this.resourceHolder;
					__employeeSalaryModule.data = __selected_employee;
					
					employeeSalaryButton.enabled = true;
				}
				else if( resource.resourceId == employeeEconomicsButton.id )
				{
					__employeeEconomicsModule = IEmployeeEconomicsModule( resource.resource );
					__employeeEconomicsModule.resourceHolderConfig.parent = this.resourceHolder;
					
					employeeEconomicsButton.enabled = true;
				}
				else if( resource.resourceId == employeeCostsAndStimulationsButton.id )
				{
					__employeeCostsAndStimulationsModule = IEmployeeCostsAndStimulationsModule( resource.resource );
					__employeeCostsAndStimulationsModule.resourceHolderConfig.parent = this.resourceHolder;
					__employeeCostsAndStimulationsModule.data = __selected_employee;
					
					employeeCostsAndStimulationsButton.enabled = true;
				}
				else if( resource.resourceId == configButton.id )
				{
					__employeesConfigModule = IEmployeesConfigModule( resource.resource );
					__employeesConfigModule.data = __employeesDataHolderColumns;
					_configResourceHolder = __employeesConfigModule.resourceHolder;
					configButton.enabled = true;
				}
			}
		}
		
		protected function _previewIndexChange( event:SaveDataEvent ):void
		{
			if( employeesDataHolder )
				( employeesDataHolder as  DataGrid ).selectedIndex = event.previewDataIndex;
		}
		
		protected function _readEmployees():void
		{
			var r:ReadVo = new ReadVo();
				r.numRows = employeesPaging.rowsPerPage;
				r.pageNum = employeesPaging.pageNumber;
				
				if( employeesPaging.sortColumnName || employeesPaging.orderColumnsList.selectedItem )
					r.sortColumnName = employeesPaging.sortColumnName || employeesPaging.orderColumnsList.selectedItem.value;
				
				r.sortColumnDirection = employeesPaging.sortColumnDirection;
			
			__employees_model.read( r, this ); 
		}
		
		protected function _readEmployeesColumns():void
		{
			systemModel.readDataHolderColumns(EmployeesModel.EMPLOYEES_DATA_HOLDER_ID, this.session.user.user_id, this ); 
		}
	}
}