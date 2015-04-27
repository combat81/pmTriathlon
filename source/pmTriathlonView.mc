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

	var triview;

	function onKey(evt) {
	
		var keynum = Lang.format("T $1$", [evt.getKey()]);
		Sys.println(keynum);
		
		if( evt.getKey() == Ui.KEY_ENTER ) {
			var recview = new pmRecordingView();
			var inpdelegate = new pmRecordingViewInputDelegate();
			
			inpdelegate.recordingView = recview;
			recview.originalview = triview;
			recview.configureDisciplines();
			recview.nextDiscipline();
			
			Ui.pushView( recview, inpdelegate, Ui.SLIDE_UP );
			Ui.requestUpdate();
		}
	
	}
}

class pmTriathlonView extends Ui.View {

	var viewmethod = 0;
	var pmprogLogo;

	var refreshtimer;
	var blinkOn = 0;
	
	var recordedDisciplines;
	
    function timercallback()
    {
    	if( viewmethod == 0 ) {
    		viewmethod = 1;
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
    	} else if( viewmethod == 2 ) {
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
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK);
		dc.clear();
		dc.drawBitmap( (dc.getWidth() / 2) - (pmprogLogo.getWidth() / 2), (dc.getHeight() / 2) - (pmprogLogo.getHeight() / 2), pmprogLogo);
	}
	
	function drawPrepare(dc) {
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK);
		dc.clear();
		
		// Draw GPS Status
		var gpsinfo = Pos.getInfo();
		var gpsIsOkay = ( gpsinfo.accuracy == Pos.QUALITY_GOOD || gpsinfo.accuracy == Pos.QUALITY_USABLE );
		
		dc.setColor( pmFunctions.getGPSQualityColour(gpsinfo), Gfx.COLOR_BLACK);
		dc.fillRectangle(0, dc.getHeight() - 4, dc.getWidth(), 4);
		dc.fillRectangle(0, dc.getHeight() - 32, dc.getWidth(), 4);

		dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_BLACK);
		dc.drawText(dc.getWidth() / 2, 0, Gfx.FONT_XTINY, "www.pmprog.co.uk", Gfx.TEXT_JUSTIFY_CENTER);
		dc.drawText(dc.getWidth() / 2, (dc.getHeight() - dc.getFontHeight(Gfx.FONT_LARGE)) / 2, Gfx.FONT_LARGE, "pmTriathlon", Gfx.TEXT_JUSTIFY_CENTER);
		
		var segwidth = (dc.getWidth() - 8) / 4;
		var xfwidth = segwidth / 2;
		
		var curx = 0;
		
		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
		pmFunctions.drawChevron(dc, curx, curx + segwidth, dc.getHeight() - 16, 20, true, false);
		curx += segwidth + 2;
		
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK);
		pmFunctions.drawChevron(dc, curx, curx + xfwidth, dc.getHeight() - 16, 20, false, false);
		curx += xfwidth + 2;

		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
		pmFunctions.drawChevron(dc, curx, curx + segwidth, dc.getHeight() - 16, 20, false, false);
		curx += segwidth + 2;

		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK);
		pmFunctions.drawChevron(dc, curx, curx + xfwidth, dc.getHeight() - 16, 20, false, false);
		curx += xfwidth + 2;

		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_BLACK);
		pmFunctions.drawChevron(dc, curx, dc.getWidth(), dc.getHeight() - 16, 20, false, true);

		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
		dc.drawText(dc.getWidth() - 4, 30, Gfx.FONT_SMALL, "START >", Gfx.TEXT_JUSTIFY_RIGHT);
		
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