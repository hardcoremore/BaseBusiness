package modules.creation
{
	import com.desktop.ui.vos.ResourceHolderVo;

	public class UpdateAssociate extends NewAssociate
	{
		public function UpdateAssociate()
		{
			super();
		}
		
		override public function unload():void
		{
			trace( "unloading update associates" );
		}
	}
}