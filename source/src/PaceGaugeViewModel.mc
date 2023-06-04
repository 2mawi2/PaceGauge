import Toybox.Lang;


class PaceGaugeViewModel {
    var pacePercentageCalculator as ZonePacePercentage;
    var thresholdPace as Float = -1.0;
    var pace as Numeric;
    var isMetricSystem as Boolean = true;

    function initialize() {
       pace = 0.0f;
       pacePercentageCalculator = new ZonePacePercentage();
    }

    function onNewThresholdPaceConfig(thresholdMinutes as Number, thresholdSeconds as Number, isMetricSystem as Boolean) {
        thresholdMinutes = clip(thresholdMinutes as Float, 0.0, 60.0);
        thresholdSeconds = clip(thresholdSeconds as Float, 0.0, 59.0);
        var newThresholdPace = thresholdMinutes + thresholdSeconds / 60.0f;
        if (newThresholdPace > 0.0f) {
            thresholdPace = newThresholdPace;
        }
        self.isMetricSystem = isMetricSystem;
        
        System.println("PaceGaugeViewModel: thresholdPace = " + thresholdPace);
        System.println("PaceGaugeViewModel: isMetricSystem = " + isMetricSystem);
        System.println("PaceGaugeViewModel: self.isMetricSystem = " + self.isMetricSystem);
        System.println("PaceGaugeViewModel: thresholdMinutes = " + thresholdMinutes);
        System.println("PaceGaugeViewModel: thresholdSeconds = " + thresholdSeconds);
    }

    function onNewCurrentSpeed(currentSpeed as Float) {
        if(currentSpeed != null){
            pace = mpsToPace(currentSpeed, self.isMetricSystem) as Number;
        } else {
            pace = 0.0f;
        }
    }

    function calculatePacePercentage() as Float {
        return pacePercentageCalculator.calculatePacePercentage(pace, thresholdPace);
    }
}
