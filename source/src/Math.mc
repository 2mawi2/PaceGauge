import Toybox.Lang;

function max(a as Float, b as Float) as Float {
    if (a > b) {
        return a;
    } else {
        return b;
    }
}

function min(a as Float, b as Float) as Float {
    if (a < b) {
        return a;
    } else {
        return b;
    }
}

function clip(a as Float, min as Float, max as Float) as Float {
    return max(min(a, max), min);
}

function abs(a as Float) as Float {
    if (a < 0) {
        return -a;
    } else {
        return a;
    }
}

function areClose(a as Float, b as Float) as Boolean {
    var epsilon = 0.000001f;
    return abs(a - b) < epsilon;
}

function mpsToPace(mps as Float, isMetricSystem as Boolean) as Float {
    if (areClose(mps, 0.0f)) { return 0.0f; }
    
    var speed = getSpeedFor(mps, isMetricSystem);
    var pace = 60.0 / speed;
    return pace;
}

function getSpeedFor(mps as Float, isMetricSystem as Boolean) as Float {
    if (isMetricSystem) {
        return mps * 3.6;
    } else {
        return mps * 3.6 * 0.621371192;
    }
}
