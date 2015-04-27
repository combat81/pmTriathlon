using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Activity as Act;
using Toybox.ActivityRecording as Rec;
using Toybox.Position as Pos;
using Toybox.System as Sys;
using Toybox.Timer as Timer;


class pmTriathlonViewInputDelegate extends Ui.InputDelegate {

	function onKey(evt) {
	
		var keynum = Lang.format("T $1$", [evt.getKey()]);
		Sys.println(keynum);
		
		if( evt.getKey() == Ui.KEY_ENTER ) {
			// App.getApp().startSession();
			Ui.pushView( new pmRecordingView(), new pmRecordingViewInputDelegate(), Ui.SLIDE_UP );
			Ui.requestUpdate();
		}
	
	}
}

class pmTriathlonView extends Ui.View {

	var viewmethod = 0;
	
	var introtime = 0;
	var pmprogLogo;

	var refreshtimer;
	var blinkOn = 0;
	
    function timercallback()
    {
    	if( viewmethod == 0 ) {
    		introtime++;
    		
    		if( introtime >= 2 ) {
    			viewmethod = 1;
    		}
    		
    	} else {
    	}
    	blinkOn = 1 - blinkOn;
        Ui.requestUpdate();
        
    }

    //! Load your resources here
    function onLayout(dc) {
		refreshtimer = new Timer.Timer();
		refreshtimer.start( method(:timercallback), 1000, true );
		
		pmprogLogo = Ui.loadResource(Rez.Drawables.pmprogLogo);
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
    	if( viewmethod == 0 ) {
    		drawIntro(dc);
    	} else {
    		drawPrepare(dc);
    	}
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }


	function drawIntro(dc) {
		if( introtime == 0 ) {
			dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK);
			dc.clear();
			dc.drawBitmap( (dc.getWidth() / 2) - (pmprogLogo.getWidth() / 2), (dc.getHeight() / 2) - (pmprogLogo.getHeight() / 2), pmprogLogo);
		}
	}
	
	function drawPrepare(dc) {
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK);
		dc.clear();
		
		// Draw GPS Status
		var gpsinfo = Pos.getInfo();
		var gpsIsOkay = ( gpsinfo.accuracy == Pos.QUALITY_GOOD || gpsinfo.accuracy == Pos.QUALITY_USABLE );
		
		if( gpsinfo.accuracy == Pos.QUALITY_GOOD ) {
			dc.setColor(Gfx.COLOR_DK_GREEN, Gfx.COLOR_BLACK);
		} else if( gpsinfo.accuracy == Pos.QUALITY_USABLE ) {
			dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_BLACK);
		} else {
			dc.setColor(Gfx.COLOR_DK_RED, Gfx.COLOR_BLACK);
		}
		dc.fillRectangle(0, 35, dc.getWidth(), 5);
		
		
		if( !gpsIsOkay ) {
			// Draw "Wait for GPS"
			var boxh = (dc.getFontHeight(Gfx.FONT_MEDIUM) * 2) + 6;
			
			dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
			dc.fillRectangle(dc.getWidth() / 6, (dc.getHeight() / 2) - (boxh / 2), (dc.getWidth() / 6) * 4, boxh);
			dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
			dc.drawRectangle(dc.getWidth() / 6, (dc.getHeight() / 2) - (boxh / 2), (dc.getWidth() / 6) * 4, boxh);

			if( blinkOn == 0 ) {
		        dc.drawText(dc.getWidth() / 2, (dc.getHeight() / 2) - dc.getFontHeight(Gfx.FONT_MEDIUM), Gfx.FONT_MEDIUM, "Please Wait", Gfx.TEXT_JUSTIFY_CENTER);
		        dc.drawText(dc.getWidth() / 2, (dc.getHeight() / 2), Gfx.FONT_MEDIUM, "For GPS", Gfx.TEXT_JUSTIFY_CENTER);
	        }
	        
		}
	}

}