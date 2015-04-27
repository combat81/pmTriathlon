using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Activity as Act;
using Toybox.ActivityRecording as Rec;
using Toybox.Position as Pos;
using Toybox.System as Sys;
using Toybox.Timer as Timer;

class pmRecordingViewInputDelegate extends Ui.InputDelegate {

	var recordingView;

	function onKey(evt) {
	
		var keynum = Lang.format("R $1$", [evt.getKey()]);
		Sys.println(keynum);
		
		if( evt.getKey() == Ui.KEY_ENTER ) {
			//
			recordingView.nextDiscipline();
			Ui.requestUpdate();
		}
	
	}
}

class pmRecordingView extends Ui.View {

	var refreshtimer;
	var blinkOn = 0;
	
	var disciplines = [ new pmDiscipline(), new pmDiscipline(), new pmDiscipline(), new pmDiscipline(), new pmDiscipline() ];
	var currentDiscipline = -1;
	
    function recordingtimercallback()
    {
    	blinkOn = 1 - blinkOn;
        Ui.requestUpdate();
        
    }

    //! Load your resources here
    function onLayout(dc) {
		refreshtimer = new Timer.Timer();
		refreshtimer.start( method(:recordingtimercallback), 1000, true );
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK);
		dc.clear();
		
		drawGPS(dc);
		drawSegments(dc);
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
    
    function drawGPS(dc) {
		var gpsinfo = Pos.getInfo();
		var gpsIsOkay = ( gpsinfo.accuracy == Pos.QUALITY_GOOD || gpsinfo.accuracy == Pos.QUALITY_USABLE );
		
		dc.setColor( pmFunctions.getGPSQualityColour(gpsinfo), Gfx.COLOR_BLACK);
		dc.fillRectangle(0, 24, dc.getWidth(), 4);
    }

	function drawSegments(dc) {
		var segwidth = (dc.getWidth() - 8) / 4;
		var xfwidth = segwidth / 2;
		
		var curx = 0;
		
		
		dc.setColor( getSegmentColour(0), Gfx.COLOR_BLACK );
		pmFunctions.drawChevron(dc, curx, curx + segwidth, 34, 10, true, false);
		curx += segwidth + 2;
		
		dc.setColor( getSegmentColour(1), Gfx.COLOR_BLACK );
		pmFunctions.drawChevron(dc, curx, curx + xfwidth, 34, 10, false, false);
		curx += xfwidth + 2;

		dc.setColor( getSegmentColour(2), Gfx.COLOR_BLACK );
		pmFunctions.drawChevron(dc, curx, curx + segwidth, 34, 10, false, false);
		curx += segwidth + 2;

		dc.setColor( getSegmentColour(3), Gfx.COLOR_BLACK );
		pmFunctions.drawChevron(dc, curx, curx + xfwidth, 34, 10, false, false);
		curx += xfwidth + 2;

		dc.setColor( getSegmentColour(4), Gfx.COLOR_BLACK );
		pmFunctions.drawChevron(dc, curx, dc.getWidth(), 34, 10, false, true);
	}
	
	function getSegmentColour(segmentNumber) {
		if( currentDiscipline == segmentNumber ) {
			return Gfx.COLOR_ORANGE;
		} else if( currentDiscipline > segmentNumber ) {
			return Gfx.COLOR_DK_GREEN;
		}
		return Gfx.COLOR_LT_GRAY;
	}
	
	function configureDisciplines() {
		disciplines[0].initaliseDiscipline(0);
		disciplines[1].initaliseDiscipline(1);
		disciplines[2].initaliseDiscipline(2);
		disciplines[3].initaliseDiscipline(3);
		disciplines[4].initaliseDiscipline(4);
	}
	
	function nextDiscipline() {
		if( currentDiscipline >= 0 ) {
			disciplines[currentDiscipline].onEnd();
		}
		currentDiscipline++;
		if( currentDiscipline == 5 ) {
			Ui.popView( Ui.SLIDE_DOWN );
		} else {
			disciplines[currentDiscipline].onBegin();
			Ui.requestUpdate();
		}
	}
}