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
		if( evt.getKey() == Ui.KEY_ENTER ) {
			pmTriData.nextDiscipline();
			Ui.requestUpdate();
		}
		
		if( evt.getKey() == Ui.KEY_POWER ) {
			pmTriData.abortEvent();
			Ui.requestUpdate();
		}
		
		// Imply that we handle everything
		return true;
	}
	
	function onTap(evt) {
		// No tap events
		return true;
	}
	
	function onSwipe(evt) {
		// No tap events
		return true;
	}
	
	function onHold(evt) {
		// No tap events
		return true;
	}
	
	function onRelease(evt) {
		// No tap events
		return true;
	}


}

class pmRecordingView extends Ui.View {

	var recordingtimer;
	var blinkOn = 0;
	
    function recordingtimercallback()
    {
    	if( pmTriData.currentDiscipline < 5 )
    	{
    		pmTriData.disciplines[pmTriData.currentDiscipline].onTick();
    	}
    	blinkOn = 1 - blinkOn;
        Ui.requestUpdate();
    }

    //! Load your resources here
    function onLayout(dc) {
		recordingtimer = new Timer.Timer();
		recordingtimer.start( method(:recordingtimercallback), 1000, true );
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK);
		dc.clear();
		
		drawTitleBar(dc);
		drawGPS(dc);
		drawSegments(dc);
		drawDataFields(dc);
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }
    
	///////////////////////////////////////////////////////////////////////////////////// Render functions
    function drawGPS(dc) {
		var gpsinfo = Pos.getInfo();
		var gpsIsOkay = ( gpsinfo.accuracy == Pos.QUALITY_GOOD || gpsinfo.accuracy == Pos.QUALITY_USABLE );
		
		dc.setColor( pmFunctions.getGPSQualityColour(gpsinfo), Gfx.COLOR_BLACK);
		dc.fillRectangle(0, 30, dc.getWidth(), 2);
    }

	function drawSegments(dc) {
		var segwidth = (dc.getWidth() - 8) / 4;
		var xfwidth = segwidth / 2;
		
		var curx = 0;
		
		
		dc.setColor( getSegmentColour(0), Gfx.COLOR_BLACK );
		pmFunctions.drawChevron(dc, curx, curx + segwidth, 38, 10, true, false);
		curx += segwidth + 2;
		
		dc.setColor( getSegmentColour(1), Gfx.COLOR_BLACK );
		pmFunctions.drawChevron(dc, curx, curx + xfwidth, 38, 10, false, false);
		curx += xfwidth + 2;

		dc.setColor( getSegmentColour(2), Gfx.COLOR_BLACK );
		pmFunctions.drawChevron(dc, curx, curx + segwidth, 38, 10, false, false);
		curx += segwidth + 2;

		dc.setColor( getSegmentColour(3), Gfx.COLOR_BLACK );
		pmFunctions.drawChevron(dc, curx, curx + xfwidth, 38, 10, false, false);
		curx += xfwidth + 2;

		dc.setColor( getSegmentColour(4), Gfx.COLOR_BLACK );
		pmFunctions.drawChevron(dc, curx, dc.getWidth(), 38, 10, false, true);
	}
	
	function getSegmentColour(segmentNumber) {
		if( pmTriData.currentDiscipline == segmentNumber ) {
			return Gfx.COLOR_ORANGE;
		} else if( pmTriData.currentDiscipline > segmentNumber ) {
			return Gfx.COLOR_DK_GREEN;
		}
		return Gfx.COLOR_LT_GRAY;
	}
	
	function drawTitleBar(dc) {
		var elapsedTime = Sys.getTimer() - pmTriData.disciplines[0].startTime;
		
		dc.drawBitmap( 0, 0, pmTriData.disciplines[pmTriData.currentDiscipline].currentIcon );
		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.drawText(34, 0, Gfx.FONT_MEDIUM, "Total:", Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(dc.getWidth() - 2, 0, Gfx.FONT_MEDIUM, pmFunctions.msToTime(elapsedTime), Gfx.TEXT_JUSTIFY_RIGHT);
	}
	
	function drawDataFields(dc) {
		var y = 44;
		
		// Discipline Time
		var elapsedTime = Sys.getTimer() - pmTriData.disciplines[pmTriData.currentDiscipline].startTime;
		y = drawDataField( dc, "Discipline:", pmFunctions.msToTime(elapsedTime), y );
		
		if( pmTriData.currentDiscipline == 1 || pmTriData.currentDiscipline == 3 ) {
			y = drawDataField( dc, null, "Transistion", y );
		//Added section to show speed vs. pace on Cycle Discipline 	
		} else if (pmTriData.currentDiscipline == 2) {
			var cursession = Act.getActivityInfo();
			y = drawDataField( dc, "Distance:", pmFunctions.convertDistance(cursession.elapsedDistance), y );
			y = drawDataField( dc, "Speed:", cursession.currentSpeed, y );
		}else {
			var cursession = Act.getActivityInfo();
			y = drawDataField( dc, "Distance:", pmFunctions.convertDistance(cursession.elapsedDistance), y );
			y = drawDataField( dc, "Pace:", pmFunctions.convertSpeedToPace(cursession.currentSpeed), y );
		}

	}
	
	function drawDataField(dc, label, value, y) {
		var smalloffset = (dc.getFontHeight( Gfx.FONT_MEDIUM ) - dc.getFontHeight( Gfx.FONT_SMALL )) / 2;
		
		if( label == null ) {
			dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
			dc.drawText(dc.getWidth() / 2, y, Gfx.FONT_MEDIUM, value, Gfx.TEXT_JUSTIFY_CENTER);
		} else {
			dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
			dc.drawText(2, y + smalloffset, Gfx.FONT_SMALL, label, Gfx.TEXT_JUSTIFY_LEFT);
			dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
			dc.drawText(dc.getWidth() - 2, y, Gfx.FONT_MEDIUM, value, Gfx.TEXT_JUSTIFY_RIGHT);
		}
		y += dc.getFontHeight( Gfx.FONT_MEDIUM );
		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
		dc.drawLine( 0, y, dc.getWidth(), y );
		y++;
		return y;
	}
}
