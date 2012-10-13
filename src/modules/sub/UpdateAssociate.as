package modules.sub
{
	import com.desktop.ui.vos.ResourceHolderVo;

	public class UpdateAssociate extends SaveCustomerModule
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