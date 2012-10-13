package modules
{
	import com.desktop.system.core.ApplicationBase;
	import com.desktop.system.core.SystemModuleBase;
	import com.desktop.system.core.SystemSession;
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.events.ModelDataChangeEvent;
	
	import factories.ModelFactory;
	
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import interfaces.modules.IAuthenticationModule;
	
	import models.AuthenticationModel;
	
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;
	import mx.states.State;
	import mx.validators.StringValidator;
	import mx.validators.Validator;
	
	import skins.Default.modules.AuthenticationModuleSkin;
	
	import spark.components.Button;
	import spark.components.ComboBox;
	import spark.components.Label;
	import spark.components.TextInput;
	import spark.events.IndexChangeEvent;
	
	import vos.AuthenticationVo;
	import vos.UserVo;
	
	public class AuthenticationModule extends SystemModuleBase implements IAuthenticationModule
	{

		/**
		 *  @public
		 */
		[SkinPart(required="false")]
		public var keyInput:TextInput;
		
		/**
		 *  @public
		 */
		[SkinPart(required="false")]
		public var usernameInput:TextInput;
		
		/**
		 *  @public
		 */
		[SkinPart(required="false")]
		public var passwordInput:TextInput;
		
		/**
		 *  @public
		 */
		[SkinPart(required="false")]
		public var languageCb:ComboBox;
		
		/**
		 *  @public
		 */
		[SkinPart(required="false")]
		public var loginBtn:Button;
		
		/**
		 *  @public
		 */
		[SkinPart(required="false")]
		public var titleLabel:Label;
		
		public static const LOGIN_MODE:uint = 1;
		public static const CHECK_LOGIN_MODE:uint = 2;
		
		private var __stateNormal:State;
		
		private var __stateAuthenticating:State;
		
		private var __stateError:State;

		private var __infoMessageKeyString:String;
		private var __authenticationModel:AuthenticationModel;
		private var __applicationBase:ApplicationBase;
		
		
		public function AuthenticationModule()
		{
			super();
			
			__authenticationModel = ModelFactory.authenticationModel();			
		}
		
		public function set application( app:ApplicationBase ):void
		{
			__applicationBase = app;
		}
		
		override public function init():void
		{
			setStyle( "skinClass", AuthenticationModuleSkin ); 
			
			__stateNormal = new State();
			__stateNormal.name = 'login';
			states.push( __stateNormal );
			
			__stateAuthenticating = new State();
			__stateAuthenticating.name = 'authenticating';
			states.push( __stateAuthenticating );
			
			__stateError = new State();
			__stateError.name = 'error';
			states.push( __stateError );

			mode = LOGIN_MODE;
			
		}

		public function get stateNormal():State{ return __stateNormal; }
		public function get stateAuthenticating():State{ return __stateAuthenticating; }
		public function get stateError():State{ return __stateError; }
		
		
		override public function set mode( m:uint ):void
		{
			if( m < 1 ) return;
			
			super.mode = m;
			
			invalidateSkinState();
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			if( instance == keyInput )
			{
				__authenticationModel.keyValidator.source = keyInput;
			}
			
			if( instance == usernameInput )
			{
				__authenticationModel.userNameValidator.source = usernameInput;
			}
			
			if( instance == passwordInput )
			{
				__authenticationModel.passwordValidator.source = passwordInput;
			}
			
			if( instance == languageCb )
			{
				languageCb.addEventListener( IndexChangedEvent.CHANGE, languageCb_changeHandler);
				languageCb.addEventListener( FlexEvent.VALUE_COMMIT, onLanguageCbCommit );
			}
			
			if( instance == loginBtn )
				loginBtn.addEventListener( MouseEvent.CLICK, _loginButtonClickHandler );

			super.partAdded(partName, instance);
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			if( instance == languageCb )
				languageCb.removeEventListener(IndexChangeEvent.CHANGE, languageCb_changeHandler);
			
			if( instance == loginBtn )
				loginBtn.removeEventListener(MouseEvent.CLICK, _loginButtonClickHandler);
			
			super.partRemoved(partName, instance);
		}
		
		override protected function getCurrentSkinState():String
		{
			var m:String;
			var s:String;
			
			switch( mode )
			{
				case LOGIN_MODE:
					m = 'login';
					break;
				
				case CHECK_LOGIN_MODE:
					m = 'checkLogin';
					break;
			}
			
			
			switch( currentState )
			{
				case __stateError.name:
					s = m + 'Error';
					break;
				
				case __stateAuthenticating.name:
					s = currentState;
					break;
				
				default:
					s = m;
				break;
			}
			
			return s;
		}

		protected function _loginButtonClickHandler(event:MouseEvent):void
		{
			var authVo:AuthenticationVo = new AuthenticationVo();
				authVo.client_key = keyInput.text;
				authVo.username = usernameInput.text;
				authVo.password = passwordInput.text;
			__authenticationModel.authenticate( authVo, this );	
		}
		
		protected function _authModelLoadingData( event:ModelDataChangeEvent ):void
		{
			currentState = stateAuthenticating.name;
		}
		
		override public function modelLoadingDataComplete(event:ModelDataChangeEvent):void
		{
			super.modelLoadingDataComplete( event );
			
			if( event.operationName == AuthenticationModel.AUTHENTICATE_OPERATION )
			{
				if( event.response.status == BaseModel.STATUS_OK )
				{
					SystemSession.instance.user = event.response.result as UserVo;
					currentState = stateNormal.name;
					__applicationBase.startApp();
				}
				else
				{
					currentState = stateError.name;
					titleLabel.text = event.response.message;
				}
			}
		}
		
		protected function onLanguageCbCommit( event:FlexEvent ):void
		{
			__authenticationModel.language = languageCb.selectedItem.value;
		}
		
		protected function languageCb_changeHandler(event:IndexChangeEvent):void
		{
			__authenticationModel.language = languageCb.selectedItem.value;
		}
	}
}