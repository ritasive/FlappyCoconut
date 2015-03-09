module msutd.core.event;

import msutd.core;

import std.stdio;

T delegate(PT) to_delegate(T, PT)(T function(PT) f)
{
	T delegate(PT) d = (PT t) {
		return f(t);
	};
	return &d;
}

struct Events {
	
	static:
	private:
	
	Event e;
	void delegate() quit_callback					= null;
	void delegate(Event.WindowEvent) win_callback			= null;
	void delegate(Event.KeyboardEvent) key_down_callback		= null;
	void delegate(Event.KeyboardEvent) key_up_callback		= null;
	void delegate(Event.MouseMotionEvent) mouse_motion_callback	= null;
	void delegate(Event.MouseButtonEvent) mouse_down_callback	= null;
	void delegate(Event.MouseButtonEvent) mouse_up_callback		= null;
	void delegate(Event.MouseWheelEvent) mouse_wheel_callback	= null;
	void delegate(Event.TextEditEvent) text_edit_callback		= null;
	void delegate(Event.TextInputEvent) text_input_callback		= null;
	
	public: 
	void set_quit_callback(void delegate() d) {
		quit_callback = d;
	}
	
	void set_win_callback(void delegate(Event.WindowEvent) d) {
		win_callback = d;
	}
	
	void set_key_down_callback(void delegate(Event.KeyboardEvent) d) {
		key_down_callback = d;
	}
	void set_key_up_callback(void delegate(Event.KeyboardEvent) d) {
		key_up_callback = d;
	}
	void set_mouse_motion_callback(void delegate(Event.MouseMotionEvent) d){
		mouse_motion_callback = d;
	}
	void set_mouse_down_callback(void delegate(Event.MouseButtonEvent) d) {
		mouse_down_callback = d;
	}
	void set_mouse_up_callback(void delegate(Event.MouseButtonEvent) d) {
		mouse_up_callback = d;
	}
	void set_mouse_wheel_callback(void delegate(Event.MouseWheelEvent) d) {
		mouse_wheel_callback = d;
	}
	void set_text_edit_callback(void delegate(Event.TextEditEvent) d) {
		text_edit_callback = d;
	}
	void set_text_input_callback(void delegate(Event.TextInputEvent) d) {
		text_input_callback = d;
	}
	
	
	
	void poll()
	{
		with (Event.Type) {
		
		while (EventHandler.poll(&e)) {
			switch (e.type) {
			case Quit:
				if (quit_callback.ptr == null)
					return;
				quit_callback();
				break;
			case Window:
				if (win_callback.ptr == null)
					return;
				win_callback(e.window);
				break;
			case KeyDown:
				if (key_down_callback.ptr == null)
					return;
				key_down_callback(e.keyboard);
				break;
			case KeyUp:
				if (key_up_callback.ptr == null)
					return;
				key_up_callback(e.keyboard);
				break;
			case MouseMotion:
				if (mouse_motion_callback.ptr == null)
					return;
				mouse_motion_callback(e.mouseMotion);
				break;
			case MouseButtonDown:
				if (mouse_down_callback.ptr == null)
					return;
				mouse_down_callback(e.mouseButton);
				break;
			case MouseButtonUp:
				if (mouse_up_callback.ptr == null)
					return;
				mouse_up_callback(e.mouseButton);
				break;
			case MouseWheel:
				if (mouse_wheel_callback.ptr == null)
					return;
				mouse_wheel_callback(e.mouseWheel);
				break;
			case TextEdit:
				if (text_edit_callback.ptr == null)
					return;
				text_edit_callback(e.textEdit);
				break;
			case TextInput:
				if (text_input_callback.ptr == null)
					return;
				text_input_callback(e.textInput);
				break;
			default:
				break;
			}
		}
		
		}
		
	}
	
}