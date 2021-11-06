import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;

class FirstWatchFaceView extends WatchUi.WatchFace {
	var myShapes;
	var middleX;
	var middleY;
	var arcRadius;
	var image;
	var font, fontNumeral;
    function initialize() {
        WatchFace.initialize();
       var bg = getApp().getProperty("BackgroundTheme");
    	switch(bg){
    		case 0: 
    			image = Application.loadResource( Rez.Drawables.Background ) as BitmapResource;
    			break;
    		case 1: 
    			image = Application.loadResource( Rez.Drawables.BackgroundYellow ) as BitmapResource;
    			break;
    		case 2: 
    			image = Application.loadResource( Rez.Drawables.BackgroundBlue ) as BitmapResource;
    			break;
    		case 3: 
    			image = Application.loadResource( Rez.Drawables.BackgroundRed ) as BitmapResource;
    			break;
    		default:
    			image = Application.loadResource( Rez.Drawables.Background ) as BitmapResource;
    			break;
    	}
    	font = WatchUi.loadResource(Rez.Fonts.Gsf);
    	fontNumeral = WatchUi.loadResource(Rez.Fonts.os108);
//        myShapes = new Rez.Drawables.shapes();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    	
    	
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get and show the current time
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        
        var hours = today.hour;
        var mins = today.min;
        var secs = today.sec;
//        var timeLabel = View.findDrawableById("TimeLabel") as Text;
//        var dateLabel = View.findDrawableById("DateLabel") as Text;
//        timeLabel.setText(hour+":"+minute);
//        dateLabel.setText(today.day + " " + today.month);
//		System.println(
//    		clockTime.hour.format("%02d") + ":" +
//    		clockTime.min.format("%02d") + ":" +
//    		clockTime.sec.format("%02d")
//		);
        // Call the parent onUpdate function to redraw the layout
        middleX = dc.getWidth() / 2;
		middleY = dc.getHeight() / 2;
		arcRadius = dc.getHeight() / 3;
		dc.clear();
		dc.drawBitmap(0,0,image);
//        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
//		dc.setPenWidth(6);
//        for (var i=0; i < 12; i++) {
//	        dc.fillCircle(middleX + (middleX - 6)*Math.sin(Math.PI*30*i/180),middleY - (middleY-6)*Math.cos(Math.PI*30*i/180), 3);
//        }
        
        dc.setColor(getApp().getProperty("NumeralColor") as Number, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() * 0.77 , dc.getHeight() * 0.25, fontNumeral, "3", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() * 0.5 , dc.getHeight() * 0.5, fontNumeral, "6", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(dc.getWidth() * 0.23 , dc.getHeight() * 0.25, fontNumeral, "9", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(getApp().getProperty("DateColor") as Number, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
        	dc.getWidth() * 0.5,                      // gets the width of the device and divides by 2
        	dc.getHeight() * 0.12,                     // gets the height of the device and divides by 2
        	font,                    // sets the font size
       		today.day_of_week + " " + today.day,                          // the String to display
        	Graphics.TEXT_JUSTIFY_CENTER            // sets the justification for the text
        );
        drawHands(dc, hours, mins, secs);   
        
        dc.setColor(0x00ff00, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawArc(middleX, middleY, middleY - 4, Graphics.ARC_COUNTER_CLOCKWISE, 90, 210);
        dc.setColor(0xFF0000, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawArc(middleX, middleY, middleY - 8, Graphics.ARC_COUNTER_CLOCKWISE, 90, 120);
//        View.onUpdate(dc);
//        myShapes.draw(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }
	
	function drawHands(dc, hours, mins, secs) as Void {
		hours = hours%12;
		dc.setPenWidth(1);
		// min hand
        dc.setColor(getApp().getProperty("MinuteHandColor") as Number, Graphics.COLOR_TRANSPARENT);
//        dc.drawLine(middleX, middleY, middleX + arcRadius*Math.sin(Math.PI*6*mins/180),middleY - arcRadius*Math.cos(Math.PI*6*mins/180));
        drawHand(dc, middleX, middleY, Math.PI*6*mins/180, arcRadius, 12);
//        dc.fillCircle(middleX + arcRadius*Math.sin(Math.PI*6*mins/180),middleY - arcRadius*Math.cos(Math.PI*6*mins/180),5);
        // hour hand
        dc.setColor(getApp().getProperty("HourHandColor") as Number, Graphics.COLOR_TRANSPARENT);
//        dc.drawLine(middleX, middleY, middleX + arcRadius*Math.sin(Math.PI*30*hours/180)/1.618,middleY - arcRadius*Math.cos(Math.PI*30*hours/180)/1.618);
		drawHand(dc, middleX, middleY, Math.PI*(30*hours + 0.5*mins)/180, arcRadius/1.618, 12);
//        dc.fillCircle(middleX + arcRadius*Math.sin(Math.PI*(30*hours + 0.5*mins)/180)/1.618,middleY - arcRadius*Math.cos(Math.PI*(30*hours + 0.5*mins)/180	)/1.618,5);
        dc.fillCircle(middleX,middleY,6);
        
        dc.setColor(getApp().getProperty("SecondDotColor") as Number, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(middleX + arcRadius*Math.sin(Math.PI*6*secs/180),middleY - arcRadius*Math.cos(Math.PI*6*secs/180),6);
        
//        drawHand(dc, middleX, middleY, Math.PI*(6*secs)/180, arcRadius/4, 2);
	}	
	function drawHand(dc, x, y, angle, length, width)
	{
		var coords = [[width/2, 0], [width/2, -length], [-width/2, -length], [-width/2, 0]];
		var result = new [coords.size()];
		var centerX = x;
		var centerY = y;
		var cos = Math.cos(angle);
		var sin = Math.sin(angle);

		for (var i = 0; i < coords.size(); i += 1)
		{
			var xdash = (coords[i][0] * cos) - (coords[i][1] * sin);
			var ydash = (coords[i][0] * sin) + (coords[i][1] * cos);
			result[i]= [ centerX+xdash, centerY+ydash];
		}
		dc.fillCircle((result[1][0]+result[2][0])/2, (result[1][1]+result[2][1])/2, width/2);
		dc.fillPolygon(result);
	}
}
