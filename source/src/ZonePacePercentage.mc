import Toybox.Lang;



class ZonePacePercentage {

    function calculatePacePercentage(pace as Float, thresholdPace as Float) as Float {
        var clipped = clip(pace, 0.8f*pace, 1.40f*pace);
        var pThreshold = clipped / thresholdPace;
        if (pThreshold > 1.29f) {
            var base = 0.0 * (100.0 / 6.0);
            var percentage = zonePercentageToTotalPercentage(pThreshold, 1.4f, 1.29f);
            return base + percentage;
        } else if (pThreshold > 1.14f) {
            var base = 1.0 * (100.0 / 6.0);
            var percentage = zonePercentageToTotalPercentage(pThreshold, 1.29f, 1.14f);
            return base + percentage;
        } else if (pThreshold > 1.06f) {
            var base = 2.0 * (100.0 / 6.0);
            var percentage = zonePercentageToTotalPercentage(pThreshold, 1.14f, 1.06f);
            return base + percentage;
        } else if (pThreshold > 0.97f) {
            var base = 3.0 * (100.0 / 6.0);
            var percentage = zonePercentageToTotalPercentage(pThreshold, 1.06f, 0.97f);
            return base + percentage;
        } else if (pThreshold > 0.90f) {
            var base = 4.0 * (100.0 / 6.0);
            var percentage = zonePercentageToTotalPercentage(pThreshold, 0.97f, 0.90f);
            return base + percentage;
        } else {
            var base = 5.0 * (100.0 / 6.0);
            var percentage = zonePercentageToTotalPercentage(pThreshold, 0.90f, 0.80f);
            return base + percentage;
        }
    }

    private function zonePercentageToTotalPercentage(pThreshold as Float, upper as Float, lower as Float) as Float {
        var clippedPThreshold = clip(pThreshold, lower, upper);
        var totalPercentage = (clippedPThreshold - lower) / (upper - lower);
        return (1-clip(totalPercentage, 0.0, 1.0)) * (100.0 / 6.0);
    }
}
