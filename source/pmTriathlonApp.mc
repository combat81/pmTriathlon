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
    	// Load config
    	loadProperties();

		// Make sure we have a default Triathlon mode    	
		var trimode = getProperty( "TriathlonMode" );
		if( trimode == null ) {
			setProperty( "TriathlonMode", 0 );
		}
		

    	// Get the GPS ready
    	Pos.enableLocationEvents( Pos.LOCATION_CONTINUOUS, method(:onPosition));
    }

    //! onStop() is called when your application is exiting
    function onStop() {
    	saveProperties();
    	Pos.enableLocationEvents( Pos.LOCATION_DISABLE, method(:onPosition));
    }

    //! Return the initial view of your application here
    function getInitialView() {
    	var view = new pmTriathlonView();
    	var dele = new pmTriathlonViewInputDelegate();
    	dele.triview = view;
        return [ view, dele ];
    }
    
    function onPosition(info) {
    }

}