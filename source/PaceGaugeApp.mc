import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class PaceGaugeApp extends Application.AppBase {

    var paceGaugeView = new PaceGaugeView();

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    //! Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates>? {
        return [ paceGaugeView ] as Array<Views or InputDelegates>;
    }

    function onSettingsChanged() { // triggered by settings change in GCM
        paceGaugeView.handleSettingUpdate();
        WatchUi.requestUpdate();   // update the view to reflect changes
    }

}

function getApp() as PaceGaugeApp {
    return Application.getApp() as PaceGaugeApp;
}