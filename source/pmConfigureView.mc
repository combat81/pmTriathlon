using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Lang as Lang;
using Toybox.Activity as Act;
using Toybox.ActivityRecording as Rec;
using Toybox.Position as Pos;
using Toybox.System as Sys;
using Toybox.Timer as Timer;

class pmConfigureViewInputDelegate extends Ui.InputDelegate {

	var ConfigView;

	function onKey(evt) {
	
		var keynum = Lang.format("C $1$", [evt.getKey()]);
		Sys.println(keynum);
		
		if( evt.getKey() == Ui.KEY_ESC ) {
			Ui.popView( Ui.SLIDE_DOWN );
			return true;
		}
	
		return true;
	}
	
	
	function onTap(evt) {
	
		if( ConfigView.CurrentSetting == 0 )
		{
			var trimode = App.getApp().getProperty( "TriathlonMode" );
			trimode = (trimode + 1) % 3;
			App.getApp().setProperty( "TriathlonMode", trimode );
			Ui.requestUpdate();
		}
	
		// No tap events
		return true;
	}
	
	function onSwipe(evt) {
	
		if( evt.getDirection() == Ui.SWIPE_LEFT )
		{
			ConfigView.CurrentSetting = (ConfigView.CurrentSetting + 1) % 7;
		}
		if( evt.getDirection() == Ui.SWIPE_RIGHT )
		{
			ConfigView.CurrentSetting = (ConfigView.CurrentSetting + 6) % 7;
		}
	
	
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

class pmConfigureView extends Ui.View {

	var CurrentSetting = 0;
	
	var Settings = [ "Type", "Swim Data 1", "Swim Data 2", "Cycle Data 1", "Cycle Data 2", "Run Data 1", "Run Data 2" ];

    //! Load your resources here
    function onLayout(dc) {
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_BLACK);
		dc.clear();

		dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
		dc.drawText( dc.getWidth() / 2, 0, Gfx.FONT_MEDIUM, Settings[CurrentSetting], Gfx.TEXT_JUSTIFY_CENTER );
		dc.drawLine( 0, dc.getFontHeight( Gfx.FONT_MEDIUM ), dc.getWidth(), dc.getFontHeight( Gfx.FONT_MEDIUM ) );
		
		if( CurrentSetting == 0 )
		{
			renderTriMode( dc );
		}
		if( CurrentSetting == 1 || CurrentSetting == 2 )
		{
			renderSwimData( dc, CurrentSetting - 1 );
		}
		if( CurrentSetting == 3 || CurrentSetting == 4 )
		{
			renderCycleData( dc, CurrentSetting - 3 );
		}
		if( CurrentSetting == 5 || CurrentSetting == 6 )
		{
			renderRunData( dc, CurrentSetting - 5 );
		}
		
		// Draw base line
		var curx = (dc.getWidth() / 2) - (6 * 3.5);
		for( var i = 0; i < 7; i++ )
		{
			if( i == CurrentSetting )
			{
				dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
			} else {
				dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
			}
			dc.fillCircle( curx, dc.getHeight() - 8, 2);
			curx += 6;
		}
		
    }

    //! The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    //! Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

	function renderTriMode( dc ) {
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		var trimode = App.getApp().getProperty( "TriathlonMode" );
		if( trimode == 0 )
		{
			dc.drawText( dc.getWidth() / 2, (dc.getHeight() - dc.getFontHeight(Gfx.FONT_LARGE)) / 2, Gfx.FONT_LARGE, "Triathlon", Gfx.TEXT_JUSTIFY_CENTER );
		} else if ( trimode == 1 ) {
			dc.drawText( dc.getWidth() / 2, (dc.getHeight() - dc.getFontHeight(Gfx.FONT_LARGE)) / 2, Gfx.FONT_LARGE, "Reverse Tri", Gfx.TEXT_JUSTIFY_CENTER );
		} else {
			dc.drawText( dc.getWidth() / 2, (dc.getHeight() - dc.getFontHeight(Gfx.FONT_LARGE)) / 2, Gfx.FONT_LARGE, "Duathlon", Gfx.TEXT_JUSTIFY_CENTER );
		}
	}
	
	function renderSwimData( dc, Slot ) {
		// Not yet implemented
		dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
		if( Slot == 0 ) {
			dc.drawText( dc.getWidth() / 2, (dc.getHeight() - dc.getFontHeight(Gfx.FONT_LARGE)) / 2, Gfx.FONT_LARGE, "Distance", Gfx.TEXT_JUSTIFY_CENTER );
		} else {
			dc.drawText( dc.getWidth() / 2, (dc.getHeight() - dc.getFontHeight(Gfx.FONT_LARGE)) / 2, Gfx.FONT_LARGE, "Pace", Gfx.TEXT_JUSTIFY_CENTER );
		}
	}

	function renderCycleData( dc, Slot ) {
		renderSwimData( dc, Slot );
	}

	function renderRunData( dc, Slot ) {
		renderSwimData( dc, Slot );
	}

}
