package modules.creation
{
	import com.desktop.system.core.SystemModuleBase;
	
	import flash.utils.getDefinitionByName;
	
	import interfaces.modules.creation.INewItem;
	
	public class NewItem extends SystemModuleBase implements INewItem
	{
		public function NewItem()
		{
			super();
		}
		
		override public function init():void
		{
			super.init();
			setStyle( "skinClass", resourceManager.getClass( this.session.config.LOCALE_CONFIG.skinsResourceName,
															 "newItemModule",
															  this.session.skinsLocaleName
															) );
		}
	}
}