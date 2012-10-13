package modules.creation
{
	import com.desktop.system.core.SystemModuleBase;
	import com.desktop.system.interfaces.IResourceHolder;
	import com.desktop.ui.vos.ResourceHolderVo;
	
	import flash.utils.getDefinitionByName;
	
	import interfaces.modules.creation.INewAssociate;
	
	import spark.components.Button;
	
	public class NewAssociate extends SystemModuleBase implements INewAssociate
	{
		[SkinPart(required="true")]
		public var saveAssociateButton:Button;
		
		private var __rhc:ResourceHolderVo;
		
		public function NewAssociate()
		{
			super();
			
			__rhc = new ResourceHolderVo();
			__rhc.minimizable = false;
			__rhc.maximizable = false;
			__rhc.resizable = true;
			__rhc.title = resourceManager.getString( this.session.config.LOCALE_CONFIG.dictonaryResourceName, "newAssociate" );
			__rhc.titleBarIcon = resourceManager.getClass( this.session.config.LOCALE_CONFIG.systemIconsResourceName, "addIcon", this.session.skinsLocaleName );
			
		}
		
		override public function init():void
		{
			super.init();
			setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName, "newAssociateModule", this.session.skinsLocaleName ) );
		}
		
		override public function get resourceHolderConfig():ResourceHolderVo
		{
			return __rhc;
		}
	}
}