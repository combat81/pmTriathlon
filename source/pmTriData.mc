using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Position as Pos;
using Toybox.ActivityRecording as Rec;
using Toybox.Lang as Lang;
using Toybox.System as Sys;
using Toybox.Timer as Timer;

module pmTriData {

	var disciplines = [ new pmDiscipline(), new pmDiscipline(), new pmDiscipline(), new pmDiscipline(), new pmDiscipline() ];
	var currentDiscipline = -1;

	///////////////////////////////////////////////////////////////////////////////////// External functions
	function configureDisciplines( triMode ) {

		// Normal Triathlon	
		if( triMode == 0 )
		{
			disciplines[0].initaliseDiscipline(0);
			disciplines[1].initaliseDiscipline(1);
			disciplines[2].initaliseDiscipline(2);
			disciplines[3].initaliseDiscipline(3);
			disciplines[4].initaliseDiscipline(4);
		}
		// Reverse Tri
		if( triMode == 1 )
		{
			disciplines[0].initaliseDiscipline(4);
			disciplines[1].initaliseDiscipline(1);
			disciplines[2].initaliseDiscipline(2);
			disciplines[3].initaliseDiscipline(3);
			disciplines[4].initaliseDiscipline(0);
		}
		// Duathlon
		if( triMode == 2 )
		{
			disciplines[0].initaliseDiscipline(4);
			disciplines[1].initaliseDiscipline(1);
			disciplines[2].initaliseDiscipline(2);
			disciplines[3].initaliseDiscipline(3);
			disciplines[4].initaliseDiscipline(4);
		}
	}
	
	function nextDiscipline() {
		if( currentDiscipline >= 0 ) {
			disciplines[currentDiscipline].onEnd();
		}
		currentDiscipline++;
		if( currentDiscipline == 5 ) {
			currentDiscipline = 4;
			Ui.switchToView(new pmFinishView(), new pmFinishViewInputDelegate(), Ui.SLIDE_UP);
		} else {
			disciplines[currentDiscipline].onBegin();
			Ui.requestUpdate();
		}
	}
	
	function abortEvent() {
		if( currentDiscipline >= 0 ) {
			disciplines[currentDiscipline].onEnd();
		}
		currentDiscipline = 4;
		Ui.switchToView(new pmFinishView(), new pmFinishViewInputDelegate(), Ui.SLIDE_UP);
	}
}
