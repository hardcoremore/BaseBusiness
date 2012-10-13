package models
{
	import com.desktop.system.core.service.ServiceLoader;
	import com.desktop.system.core.service.events.ServiceEvent;
	import com.desktop.system.core.BaseModel;
	import com.desktop.system.events.ModelDataChangeEvent;
	import com.desktop.system.interfaces.IServiceReqester;
	import com.desktop.system.utility.CrudOperations;
	import com.desktop.system.vos.ModelOperationResponseVo;
	import com.desktop.system.vos.ResourceConfigVo;
	import com.desktop.system.vos.WebServiceRequestVo;
	
	import flash.events.IEventDispatcher;
	import flash.net.URLVariables;
	
	import mx.validators.StringValidator;
	import mx.validators.Validator;
	
	import vos.AuthenticationVo;
	import vos.UserVo;
	
	public class AuthenticationModel extends BaseModel
	{
		public static const AUTHENTICATE_OPERATION:String = "authenticate";
		
		private var __keyValidator:StringValidator;
		private var __userNameValidator:StringValidator;
		private var __passwordValidator:StringValidator;
		
		private var __language:String;
		
		
		public function AuthenticationModel( resourceConfigVo:ResourceConfigVo, target:IEventDispatcher=null)
		{
			super( resourceConfigVo, target );
			
			UserVo;
			
			
			__keyValidator = new StringValidator();
			__userNameValidator = new StringValidator();	
			__passwordValidator = new StringValidator();
			
			__keyValidator.requiredFieldError = __userNameValidator.requiredFieldError = __passwordValidator.requiredFieldError = "Ovo polje je obavezno";
			
			__keyValidator.property = 'text';
			__keyValidator.required = true;
			__keyValidator.maxLength = 32;
			__keyValidator.minLength = 6;
			__keyValidator.tooShortError = "Morate uneti namjanje " + '6 karaktera';
			
			__userNameValidator.property = 'text';
			__userNameValidator.required = true;
			__userNameValidator.minLength = 3;
			__userNameValidator.tooShortError = "Morate uneti namjanje " + '3 karaktera';
			
			
			__passwordValidator.property = 'text';
			__passwordValidator.required = true;
			__passwordValidator.minLength = 6;
			__passwordValidator.tooShortError = "Morate uneti namjanje " + '6 karaktera';
				
		}
		
		public function set language( val:String ):void
		{
			__language = val;
		}
		
		public function get language():String
		{
			if( __language ) return __language;
			else
				return "en_US";
		}
		
		public function get keyValidator():StringValidator
		{
			return __keyValidator;
		}
		
		public function get passwordValidator():StringValidator
		{
			return __passwordValidator;
		}
		
		public function get userNameValidator():StringValidator
		{
			return __userNameValidator;
		}
		
		public function authenticate( authVo:AuthenticationVo, requester:IServiceReqester ):void
		{
			if( Validator.validateAll( [ keyValidator, userNameValidator, passwordValidator] ).length == 0 )
			{
				var service:ServiceLoader = new ServiceLoader();
					service.requester = requester;
				
				var web:WebServiceRequestVo = new WebServiceRequestVo();
					web.module = "users";
					web.action = AUTHENTICATE_OPERATION;
				
				var d:URLVariables = new URLVariables();
					d.username = authVo.username;
					d.password = authVo.password;
					d.CLIENT_KEY = authVo.client_key;
				
				web.data = d;
				
				web.voClasses = new Object();
				web.voClasses.UserVo = "vos.UserVo";
				
				_startOperation( web, service ); 
			} 
			else
			{
				var e:ModelDataChangeEvent  = new ModelDataChangeEvent( ModelDataChangeEvent.MODEL_LOADING_DATA_COMPLETE );
				
				var mvo:ModelOperationResponseVo = new ModelOperationResponseVo();
					mvo.status = STATUS_ERROR;
					mvo.message = "Forma nije validna. Molimo vas proverite sva polja i pokusajte ponovo";
					
				e.response = mvo;
				dispatchEvent( e );
			}
			
			
		}
	}
}