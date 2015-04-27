using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Position as Pos;
using Toybox.ActivityRecording as Rec;
using Toybox.Lang as Lang;
using Toybox.System as Sys;
using Toybox.Timer as Timer;

module pmFunctions {

    function msToTime(ms) {
    	var seconds = (ms / 1000) % 60;
    	var minutes = (ms / 60000) % 60;
    	var hours = ms / 3600000;
    	
    	return Lang.format("$1$:$2$.$3$", [hours, minutes.format("%02d"), seconds.format("%02d")]); 
    }
    
    function convertSpeedToPace(speed) {
    	var result_min;
    	var result_sec;
    	var result_per;
    	var conversionvalue;
    	var settings = Sys.getDeviceSettings();
    	
		result_min = 0;
		result_sec = 0;
		if( settings.paceUnits == Sys.UNIT_METRIC ) {
			result_per = "/km";
			conversionvalue = 1000.0d;
		} else {
    		result_per = "/mi";
    		conversionvalue = 1609.34d;
    	}

		if( speed != null && speed > 0 ) {
	    	var secpermetre = 1.0d / speed;	// speed = m/s
	    	result_sec = secpermetre * conversionvalue;
			result_min = result_sec / 60;
			result_min = result_min.format("%d").toNumber();
			result_sec = result_sec - ( result_min * 60 );	// Remove the exact minutes, should leave remainder seconds
		}
		
    	return Lang.format("$1$:$2$$3$", [result_min, result_sec.format("%02d"), result_per]);
    }
    
    function convertDistance(metres) {
    	var result;
    	
    	if( metres == null ) {
    		result = 0;
    	} else {
	    	var settings = Sys.getDeviceSettings();
	    	if( settings.distanceUnits == Sys.UNIT_METRIC ) {
	    		result = metres / 1000.0;
	    	} else {
	    		result = metres / 1609.34;
	    	}
	    	
	    }
    	
    	return Lang.format("$1$", [result.format("%.2f")]);
    }

}