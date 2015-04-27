using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Activity as Act;
using Toybox.ActivityRecording as Rec;
using Toybox.Position as Pos;
using Toybox.System as Sys;
using Toybox.Timer as Timer;

class pmFinishViewInputDelegate extends Ui.InputDelegate {

	var recordingView;

	function onKey(evt) {
	
		var keynum = Lang.format("F $1$", [evt.getKey()]);
		Sys.println(keynum);
		
		if( evt.getKey() == Ui.KEY_ENTER ) {
			Ui.popView( Ui.SLIDE_DOWN );
			Ui.popView( Ui.SLIDE_DOWN );
		}
	
	}
}

class pmFinishView extends Ui.View {

	var recordedView;

    //! Load your resources here
    function onLayout(dc) {
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_BLACK);
		dc.clear();

		var elapsedTime = recordedView.disciplines[4].endTime - recordedView.disciplines[0].startTime;
		
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		dc.drawText(0, 0, Gfx.FONT_MEDIUM, "Total:", Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(dc.getWidth() - 2, 0, Gfx.FONT_MEDIUM, pmFunctions.msToTime(elapsedTime), Gfx.TEXT_JUSTIFY_RIGHT);
		
		dc.drawLine( 0, dc.getFontHeight( Gfx.FONT_MEDIUM ), dc.getWidth(), dc.getFontHeight( Gfx.FONT_MEDIUM ) );
		
		drawDataFields(dc);
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

	function drawDataFields(dc) {
		var y = dc.getFontHeight( Gfx.FONT_MEDIUM ) + 1;
		
		// Discipline Time
		var elapsedTime = recordedView.disciplines[0].endTime - recordedView.disciplines[0].startTime;
		y = drawDataField( dc, "Swim:", pmFunctions.msToTime(elapsedTime), y );
		elapsedTime = recordedView.disciplines[1].endTime - recordedView.disciplines[1].startTime;
		y = drawDataField( dc, "Trans 1:", pmFunctions.msToTime(elapsedTime), y );
		elapsedTime = recordedView.disciplines[2].endTime - recordedView.disciplines[2].startTime;
		y = drawDataField( dc, "Cycle:", pmFunctions.msToTime(elapsedTime), y );
		elapsedTime = recordedView.disciplines[3].endTime - recordedView.disciplines[3].startTime;
		y = drawDataField( dc, "Trans 2:", pmFunctions.msToTime(elapsedTime), y );
		elapsedTime = recordedView.disciplines[4].endTime - recordedView.disciplines[4].startTime;
		y = drawDataField( dc, "Run:", pmFunctions.msToTime(elapsedTime), y );

	}
	
	function drawDataField(dc, label, value, y) {
		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
		dc.drawText(2, y, Gfx.FONT_SMALL, label, Gfx.TEXT_JUSTIFY_LEFT);
		dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
		dc.drawText(dc.getWidth() - 2, y, Gfx.FONT_SMALL, value, Gfx.TEXT_JUSTIFY_RIGHT);
		y += dc.getFontHeight( Gfx.FONT_SMALL );
		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
		dc.drawLine( 0, y, dc.getWidth(), y );
		y++;
		return y;
	}
}