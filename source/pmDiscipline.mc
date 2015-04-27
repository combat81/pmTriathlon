using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Position as Pos;
using Toybox.ActivityRecording as Rec;
using Toybox.Lang as Lang;
using Toybox.System as Sys;
using Toybox.Timer as Timer;

class pmDiscipline {

	static var stageNames = [
		"Tri:Swim", 
		"Tri:Xfer1", 
		"Tri:Cycle", 
		"Tri:Xfer2", 
		"Tri:Run" ];
	static var stageSports = [ 
		Rec.SPORT_SWIMMING, 
		Rec.SPORT_TRANSITION, 
		Rec.SPORT_CYCLING, 
		Rec.SPORT_TRANSITION, 
		Rec.SPORT_RUNNING ];
	static var stageSubSports = [ 
		Rec.SUB_SPORT_LAP_SWIMMING, 
		Rec.SUB_SPORT_GENERIC, 
		Rec.SUB_SPORT_ROAD, 
		Rec.SUB_SPORT_GENERIC, 
		Rec.SUB_SPORT_STREET ];
		
		
	var startTime;
	var endTime;
	var disciplineSession;
	
	var currentStage;
	var currentIcon;

	function initaliseDiscipline(stage) {
		currentStage = stage;
		// currentIcon = Ui.loadResource(Rez.Drawables.CycleIcon);
	}
	
	function onBegin() {
		var logtxt = Lang.format("Starting $1$ ($2$ :: $3$)", [stageNames[currentStage], stageSports[currentStage], stageSubSports[currentStage]]);
		Sys.println(logtxt);
		startTime = Sys.getTimer();
		disciplineSession = Rec.createSession( { :name=>stageNames[currentStage], :sport=>stageSports[currentStage], :subsport=>stageSubSports[currentStage] } );
    	if( disciplineSession != null )
    	{
    		disciplineSession.start();
    	}
	}
	
	function onEnd() {
		endTime = Sys.getTimer();
    	if( disciplineSession != null && disciplineSession.isRecording() )
    	{
			disciplineSession.stop();
			disciplineSession.save();
    	}
		disciplineSession = null;
	}
	
	function onUpdate() {
	}

}
