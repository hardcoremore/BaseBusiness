package modules.sub
{
	import com.desktop.system.Application.Library.ui.FormHelper;
	import com.desktop.system.Application.Library.ui.SkinBase;
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.core.SystemModuleBase;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.interfaces.IResourceHolder;
	import com.desktop.system.utility.CrudOperations;
	import com.desktop.system.vos.NotificationVo;
	import com.desktop.ui.Components.Group.LoadingContainer;
	import com.desktop.ui.vos.ResourceHolderVo;
	
	import components.app.SaveData;
	import components.events.SaveDataEvent;
	
	import factories.ModelFactory;
	
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;
	
	import interfaces.modules.sub.ISaveUserModule;
	
	import models.PrivilegesModel;
	import models.UsersModel;
	
	import mx.controls.DateChooser;
	import mx.controls.DateField;
	import mx.events.FlexEvent;
	
	import skins.Default.modules.sub.SaveUserSkin;
	
	import spark.components.Button;
	import spark.components.CheckBox;
	import spark.components.ComboBox;
	import spark.components.Form;
	import spark.components.FormItem;
	import spark.components.Group;
	import spark.components.Label;
	import spark.components.RadioButtonGroup;
	import spark.components.TextArea;
	import spark.components.TextInput;
	
	import vos.AcgVo;
	import vos.UserVo;
	
	public class SaveUserModule extends SystemModuleBase implements ISaveUserModule
	{	
		private var __userModel:UsersModel;
		private var __privilegesModel:PrivilegesModel;
		
		
		[SkinPart(required="true")]
		public var user_name:TextInput;
		
		[SkinPart(required="true")]
		public var user_last_name:TextInput;
		
		[SkinPart(required="true")]
		public var username:TextInput;
		
		[SkinPart(required="true")]
		public var password:TextInput;
		
		[SkinPart(required="true")]
		public var repeat_password:TextInput;
		
		[SkinPart(required="true")]
		public var user_gender:RadioButtonGroup;
		
		[SkinPart(required="true")]
		public var user_phone_number:TextInput;
		
		[SkinPart(required="true")]
		public var user_mobile_number:TextInput;
		
		[SkinPart(required="true")]
		public var user_email:TextInput;
		
		[SkinPart(required="true")]
		public var user_skype:TextInput;
		
		[SkinPart(required="true")]
		public var user_acg_id:ComboBox;
		
		[SkinPart(required="true")]
		public var passwordItem:FormItem;
		
		[SkinPart(required="true")]
		public var repeatPasswordItem:FormItem;
		
		[SkinPart(required="true")]
		public var userForm:Form;
		
		public function SaveUserModule()
		{
			super();
		}
		
		public function get saveDataComponent():SaveData
		{
			return saveDataCmp;
		}
		
		override public function init():void
		{
			super.init();
			
			__userModel = ModelFactory.usersModel();
			__privilegesModel = ModelFactory.privilegesModel();
			
			//setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "saveCustomerModule", this.session.skinsLocaleName ) );
			setStyle( "skinClass", SaveUserSkin );
			
			__userModel.addEventListener( ModelDataChangeEvent.MODEL_LOADING_DATA, _modelLoadingDataEventHandler );
			__userModel.addEventListener( ModelDataChangeEvent.MODEL_LOADING_DATA_COMPLETE, _modelLoadingDataCompleteEventHandler );
			
			__privilegesModel.addEventListener( ModelDataChangeEvent.MODEL_LOADING_DATA_COMPLETE, _modelLoadingDataCompleteEventHandler );
		}
		
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if( instance == saveDataCmp )
			{
				saveDataCmp.addEventListener( SaveDataEvent.SAVE_DATA, _saveCustomerEventHandler );
				saveDataCmp.addEventListener( SaveDataEvent.RESET_DATA, _resetUserFormEventHandler );
			}
			else if( instance == user_acg_id )
			{
				user_acg_id.labelField = "acg_name";
			}
		
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if( instance == saveDataCmp )
			{
				saveDataCmp.removeEventListener( SaveDataEvent.SAVE_DATA, _saveCustomerEventHandler );
				saveDataCmp.removeEventListener( SaveDataEvent.RESET_DATA, _resetUserFormEventHandler );
			}
			
			super.partRemoved( partName, instance );
		}
		
		protected function _saveCustomerEventHandler( event:SaveDataEvent ):void
		{
			var u:UserVo;
			
			if( mode == CrudOperations.CREATE )
			{
				u = new UserVo();
				u.user_acg_id = ( user_acg_id.selectedItem as AcgVo ).acg_id;
			}
			else if( mode == CrudOperations.UPDATE )
			{
				u = data as UserVo;
			}
			
			u.password = password.text;
			u.user_email = user_email.text;
			u.user_gender = uint( user_gender.selectedValue );
			u.user_last_name = user_last_name.text;
			u.user_mobile_number = user_mobile_number.text;
			u.user_name = user_name.text;
			u.user_phone_number = user_phone_number.text;
			u.username = username.text;
			
			if( mode == CrudOperations.CREATE && u.password != repeat_password.text )
			{
				var nvo:NotificationVo = new NotificationVo();
					nvo.icon = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, 'deleteErrorIcon', session.skinsLocaleName );
					nvo.title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "error" );
					nvo.text = resourceManager.getString( this.session.config.LOCALE_CONFIG.messagesResourceName, "passwordDontMatch" );
					nvo.okButton = true;
					notify( nvo );
					
				return;
			}
			
			if( mode == CrudOperations.CREATE )
			{
				__userModel.create( u, this );
			}
			else
			{
				__userModel.update( u, this );
			}
		}
		
		override public function set data( d:Object ):void
		{
			super.data = d;
			_fillForm( d as UserVo );
		}

		protected function _fillForm( d:UserVo ):void
		{
			if( ! created || ! d )
				return;
			
			FormHelper.setComboBoxSelectedValue( user_acg_id, "acg_id", d.user_acg_id );
			user_email.text = d.user_email;
			user_gender.selectedValue = uint( d.user_gender );
			user_last_name.text = d.user_last_name;
			user_mobile_number.text = d.user_mobile_number;
			user_name.text = d.user_name;
			user_phone_number.text = d.user_phone_number;
			username.text = d.user_name;
			
		}
		
		protected function _clearForm():void
		{
			FormHelper.resetForm( userForm );
		}
		
		protected function _resetUserFormEventHandler( event:SaveDataEvent ):void
		{
			_clearForm();
		}
		
		
		protected function _modelLoadingDataEventHandler( event:ModelDataChangeEvent ):void
		{
			if( event.operationName == PrivilegesModel.PRIVILEGES_READ_ACG_SELECT_OPERATION )
			{
				setLoadingComboBox( user_acg_id );
			}
		}
		
		
		protected function _modelLoadingDataCompleteEventHandler( event:ModelDataChangeEvent ):void
		{
			if( event.operationName == PrivilegesModel.PRIVILEGES_READ_ACG_SELECT_OPERATION && event.requester != this )
			{
				_updateReadData( event.response, user_acg_id );
				
				if( data && data is UserVo && mode == CrudOperations.UPDATE )
				{
					FormHelper.setComboBoxSelectedValue( user_acg_id, "acg_id", ( data as UserVo ).user_acg_id );
				}
			}
		}
		
		override public function modelLoadingData(event:ModelDataChangeEvent):void
		{
			if( event.operationName == UsersModel.USERS_CREATE_OPERATION ||
				event.operationName == UsersModel.USERS_UPDATE_OPERATION )
			{
				super.modelLoadingData( event );
			}
		}
		
		override public function modelLoadingDataComplete(event:ModelDataChangeEvent):void
		{
			if( event.operationName == UsersModel.USERS_CREATE_OPERATION ||
				event.operationName == UsersModel.USERS_UPDATE_OPERATION )
			{
				super.modelLoadingDataComplete( event );
			}
			else if( event.operationName == PrivilegesModel.PRIVILEGES_READ_ACG_SELECT_OPERATION )
			{
				_updateReadData( event.response, user_acg_id );
				
				if( data && data is UserVo )
				{
					FormHelper.setComboBoxSelectedValue( user_acg_id, "acg_id", ( data as  UserVo).user_acg_id );
				}
			}
		}
		
		override protected function _creationComplete(event:FlexEvent):void
		{
			super._creationComplete(event);
			__privilegesModel.readPrivilegesForSelect(this);
				
			if( mode == CrudOperations.UPDATE )
			{
				resourceHolder.height -= passwordItem.measuredHeight;
				resourceHolder.height -= repeatPasswordItem.measuredHeight;
				
				userForm.removeElement( passwordItem );
				userForm.removeElement( repeatPasswordItem );
				
				if( data )
					_fillForm( data as UserVo );
			}
		}
	}
}