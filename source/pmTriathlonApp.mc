using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Position as Pos;
using Toybox.ActivityRecording as Rec;
using Toybox.Lang as Lang;
using Toybox.System as Sys;
using Toybox.Timer as Timer;

class pmTriathlonApp extends App.AppBase {

    //! onStart() is called on application start up
    function onStart() {
    	// Get the GPS ready
    	Pos.enableLocationEvents( Pos.LOCATION_CONTINUOUS, method(:onPosition));
    }

    //! onStop() is called when your application is exiting
    function onStop() {
    	Pos.enableLocationEvents( Pos.LOCATION_DISABLE, method(:onPosition));
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ new pmTriathlonView(), new pmTriathlonViewInputDelegate() ];
    }
    
    function onPosition(info) {
    }

}