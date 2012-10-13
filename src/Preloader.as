package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import mx.core.MovieClipLoaderAsset;
	import mx.preloaders.SparkDownloadProgressBar;

	public class Preloader extends SparkDownloadProgressBar
	{		
		protected var _animInstance:MovieClip;
		
		public function Preloader() 
		{
			super();
			
			_animInstance = new LoaderMain();
			addChild( _animInstance );
			
			addEventListener( Event.ADDED_TO_STAGE, _onAddedToStage );
		}
		
		
		protected function _onAddedToStage( event:Event ):void
		{
			event.target.removeEventListener( Event.ADDED_TO_STAGE, _onAddedToStage );
			
			_animInstance.x = stage.stageWidth / 2 - _animInstance.width / 2;
			_animInstance.y = stage.stageHeight / 2 - _animInstance.height / 2;
		
			addChild( _animInstance );		
		}
	
		override protected function progressHandler(event:ProgressEvent):void
		{
			var p:uint;
		
			p = Math.ceil(event.bytesLoaded / event.bytesTotal * 100);
			
			_animInstance.gotoAndStop( p );
		}
		
	}
}