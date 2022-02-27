

class PaceGaugeViewModel {
    var thresholdPace as Float = -1.0;
    var pace as Numeric;

    function initialize() {
       pace = 0.0f;
    }

    function onNewThresholdPaceConfig(thresholdMinutes as Number, thresholdSeconds as Number) {
        thresholdMinutes = clip(thresholdMinutes, 0, 60);
        thresholdSeconds = clip(thresholdSeconds, 0, 60);
        var newThresholdPace = thresholdMinutes + thresholdSeconds / 60.0f;
        if (newThresholdPace > 0.0f) {
            thresholdPace = newThresholdPace;
        }
    }

    function onNewCurrentSpeed(currentSpeed as Float) {
        if(currentSpeed != null){
            pace = mpsToPace(currentSpeed) as Number;
        } else {
            pace = 0.0f;
        }
    }
}
