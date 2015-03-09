import std.stdio;

import std.conv;

import std.random;

import msutd.core;

string title = "Flappy Coconut";

int main(string[] args)
{
	auto style = Window.Style.Default;
		//| Window.Style.Resizeable;
	Window win = new Window(VideoMode(800, 400), title, style);
	win.setVerticalSync(Window.Sync.Disable);
	win.setFramerateLimit(60);
	

	
	Text[] t = new Text[10];
	foreach (i, ref e; t) {
		e = new Text(Font("C:/Windows/Fonts/Ubuntu-R.ttf", 16, Font.Mode.Blended));
		e.setPosition(4, i * 18);
	}
	
	Image wall_bot_img = new Image("F:/Daten/Github/flappy/assets/textures/wallbot.png");
	Sprite[] wall_bot = new Sprite[8];
	foreach (i, ref e; wall_bot) {
		e = new Sprite(wall_bot_img);
	}
	Image wall_top_img = new Image("F:/Daten/Github/flappy/assets/textures/walltop.png");
	Sprite[] wall_top = new Sprite[8];
	foreach (i, ref e; wall_top) {
		e = new Sprite(wall_top_img);
	}
	for(int i = 0 ; i < 5 ; i++) {
		wall_top[i].setPosition(848 + 200 * i, uniform(-320,-80));
		wall_bot[i].setPosition(848 + 200 * i, wall_top[i].getPosition().y + 480);	
	}
	Image bg_img = new Image("F:/Daten/Github/flappy/assets/textures/background.png");
	Sprite bg = new Sprite(bg_img);
	bg.setPosition(0, 0);
	Image bg2_img = new Image("F:/Daten/Github/flappy/assets/textures/background.png");
	Sprite bg2 = new Sprite(bg2_img);
	bg2.setPosition(bg.width(), 0);
	Image p_img = new Image("F:/Daten/Github/flappy/assets/textures/coco_straight.png");
	Sprite p = new Sprite(p_img);
	Image p_up_img = new Image("F:/Daten/Github/flappy/assets/textures/coco_up.png");
	Sprite p_up = new Sprite(p_up_img);
	Image p_down_img = new Image("F:/Daten/Github/flappy/assets/textures/coco_down.png");
	Sprite p_down = new Sprite(p_down_img);
	
	p.setPosition(100, 190);
	p_up.setPosition(100, 190);
	p_down.setPosition(100, 190);
	
	p.setScale(0.25);
	p_up.setScale(0.25);
	p_down.setScale(0.25);
	
	
	Clock clock = Clock();
	Clock timeout = Clock();
	
	//Mouse.showCursor(false);
	
	bool playing = true;
	bool F3_pressed = true;
	bool F2_pressed = false;
	bool jump_pressed = false;
	bool fall = false;
	short x = 0;
	short y = 0;
	short w_x = 0;
	//string jump = Space;
	int jumpcount = 0;
	
	
	Events.set_win_callback((e) {
		if (e.eventId == WindowEventId.SizeChanged) {
			win.setSize(win.width, win.height);
		}
	});
	
	Events.set_key_down_callback((e) {
		switch (e.code) {
		case Keyboard.Code.F3: F3_pressed ^= true; break;
		case Keyboard.Code.F2:
			F2_pressed ^= true;
			if (F2_pressed) {
				win.setVerticalSync(Window.Sync.Enable);
			} else {
				win.setVerticalSync(Window.Sync.Disable);
			}
			break;
		case Keyboard.Code.Space: jump_pressed = true; break;	
		case Keyboard.Code.Esc:
			win.close();
			break;
		default:
			break;
		}
	});
	
	Events.set_mouse_motion_callback((e) {
		x = e.x;
		y = e.y;
	});
	Events.set_quit_callback(() => win.close());
	
	
	int updateLatch = 250;
	int noplanhowtocallit = 0;
	
	while (win.isOpen()) {
		win.clear();
		playing = true;
		
		while(playing) {
				
			if(bg.getPosition().x <= -1600) {
				bg.setPosition(0,0);
				bg2.setPosition(1600,0);
			}
			
			bg.move(-1,0);
			bg2.move(-1,0);
			
			if (jump_pressed) {
				jumpcount = 120;
				fall = true;
				jump_pressed = false;
			}
			if (jumpcount > 0) {
				p.move(0,-(jumpcount / 20));
				p_up.move(0,-(jumpcount / 20));
				p_down.move(0,-(jumpcount / 20));
				}
			else {
				p.move(0, -(jumpcount / 8));
				p_up.move(0,-(jumpcount / 8));
				p_down.move(0,-(jumpcount / 8));
			}
			jumpcount -= 4;	 
			
			win.draw(bg);
			win.draw(bg2);
			  
			for(int i = 0 ; i < 5 ; i++) {
				if(wall_top[i].getPosition().x < -100) {
					wall_top[i].setPosition(900, uniform(-300,-100));
					wall_bot[i].setPosition(900, wall_top[i].getPosition().y + 480);
				}
				wall_top[i].move(-3,0);
				win.draw(wall_top[i]);
				wall_bot[i].move(-3,0);
				win.draw(wall_bot[i]);			
			}
	
			if (jumpcount < -16)
				win.draw(p_down);
			else if (jumpcount >= -16 && jumpcount <= 16 )
				win.draw(p);
			else if (jumpcount > 16)
				win.draw(p_up);	
				
			if (p.position.y + p_img.height*0.25 >= win.height + 10 || p.position.y < -6) {
				playing = false;
				break;
				}
				
			if (F3_pressed) {
				//t.format("FPS Limit: %s, Current FPS: %s, Hz: %s", win.getFramerateLimit(), clock.getCurrentFps(), win.getVerticalSync());
				t[0].format("FPS Limit: %s", win.getFramerateLimit() == 0 ? "NoLimit" : to!string(win.getFramerateLimit));
				t[1].format("Current FPS: %s", clock.getCurrentFps());
				t[2].format("Vsync: %s", win.getVerticalSync());
				t[3].format("X: %s, Y: %s", x, y);
				t[4].format("jump: %s", jumpcount);
				t[5].format("BGpos: %s", bg.getPosition().x);
				
				win.draw(t[0]);
				win.draw(t[1]);
				win.draw(t[2]);
				win.draw(t[3]);
				win.draw(t[4]);
				win.draw(t[5]);
			}
		
			win.display();
			Events.poll();
		}

	}
	
	return 0;
}
