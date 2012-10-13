package vos
{
	public class DesktopAppearanceVo extends Object
	{
		public var desktop_appearance_id:String;
		public var desktop_appearance_user_id:String;
		public var desktop_appearance_name:String;
		public var desktop_appearance_default:String;
		
		public var desktop_appearance_icon_size:uint;
		public var desktop_appearance_font_size:uint;
		public var desktop_appearance_controll_button_size:uint;
		public var desktop_appearance_wallpaper_type:String;
		public var desktop_appearance_wallpaper_url:String;
		public var desktop_appearance_wallpaper_color:uint;
		
		public var desktop_appearance_window_background_color:uint;
		public var desktop_appearance_window_background_alpha:Number;
		public var desktop_appearance_window_border_color:uint;
		public var desktop_appearance_window_border_alpha:Number;
		
		public var desktop_appearance_taskbar_position:String;
		public var desktop_appearance_taskbar_label_visible:String;
		public var desktop_appearance_taskbar_color:uint;
		public var desktop_appearance_taskbar_thickness:uint;
		public var desktop_appearance_taskbar_alpha:Number;
		
		public function DesktopAppearanceVo()
		{
		}
	}
}