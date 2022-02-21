import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class PaceGaugeView extends WatchUi.DataField {
    hidden var pace as Numeric;

    function initialize() {
        DataField.initialize();
        pace = 0.0f;
    }

    function onLayout(dc as Dc) as Void {
        var obscurityFlags = DataField.getObscurityFlags();
        if (obscurityFlags == (OBSCURE_TOP | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.TopLeftLayout(dc));
        } else if (obscurityFlags == (OBSCURE_TOP | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.TopRightLayout(dc));

        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_LEFT)) {
            View.setLayout(Rez.Layouts.BottomLeftLayout(dc));

        } else if (obscurityFlags == (OBSCURE_BOTTOM | OBSCURE_RIGHT)) {
            View.setLayout(Rez.Layouts.BottomRightLayout(dc));
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var valueView = View.findDrawableById("value");
            valueView.locY = valueView.locY + 15;
        }
    }

    function compute(info as Activity.Info) as Void {
        if(info has :currentSpeed){
            if(info.currentSpeed != null){
                pace = mpsToPace(info.currentSpeed) as Number;
            } else {
                pace = 0.0f;
            }
        }
    }

    function mpsToPace(mps as Float) as Float {
        var kmh = mps * 3.6;
        var pace = 60.0 / kmh;
        return pace;
    } 

    function onUpdate(dc as Dc) as Void {
        (View.findDrawableById("Background") as Text).setColor(getBackgroundColor());
        var value = View.findDrawableById("value") as Text;
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            value.setColor(Graphics.COLOR_WHITE);
        } else {
            value.setColor(Graphics.COLOR_BLACK);
        }
        value.setText(pace.format("%.2f"));
        View.onUpdate(dc);
        drawGauge(dc);
    }

    function calculatePaceGauge(dc as DC) as PaceGauge {
        var obscurityFlags = DataField.getObscurityFlags();
        var additionalBottomAndTopPadding = 0.0;
        var offset = dc.getHeight()/10;
        if (obscurityFlags == 7) {
            offset = dc.getHeight() - offset;
        }
        var padding = dc.getWidth() * 0.15 + additionalBottomAndTopPadding;
        var height = 8;
        var start = 0 + padding;
        var end = dc.getWidth() - padding;
        var currentPacePercent = calculatePercentageFrom(pace); 
        return new PaceGauge(start, end, offset, height, currentPacePercent);
    }


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

    function zonePercentageToTotalPercentage(pThreshold as Float, upper as Float, lower as Float) as Float {
        var percentageOfZone = 1.0 - max((pThreshold - lower), 0) / (upper - lower);
        var totalPercentage = percentageOfZone * (1.0f / 6.0f) * 100.0;
        return totalPercentage;
    }

    function calculatePercentageFrom(pace as Float) as Float {
        var clipped = clip(pace, 0.8f*pace, 1.40f*pace);
        var thresholdPace = 5.5f;
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


    function fillRectangleWithContrast(
        dc as DC, 
        x as Float, 
        y as Float, 
        width as Float, 
        height as Float, 
        color as Int
    ) {
        var contrastSize = 2.0;
        dc.setColor(color, color);
        dc.fillRectangle(x, y, width, height);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.fillRectangle(x, y, contrastSize, height);
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.fillRectangle(x + width - contrastSize, y, contrastSize, height);
    }

    function drawGauge(dc as DC) as Void {
        dc.setAntiAlias(true);
        var gauge = calculatePaceGauge(dc);
        var tile = gauge.tileLength();
        var colors = gauge.getColors();
        for(var i = 0; i < 6; i++) {
            var height = gauge.height;
            if (i == gauge.highlightedIndex()) {
                height = height * 1.8;
            }
            fillRectangleWithContrast(
                dc, 
                gauge.start + tile * i, 
                gauge.offset, 
                tile, 
                height, 
                colors[i]
            );
        }
        drawCurrentPace(dc, gauge);
    }

    function drawCurrentPace(dc as DC, gauge as PaceGauge) {
        var indicatorWidth = 9.0;
        var position = gauge.getIndicatorPosition();
 
        fillRectangleWithContrast(
            dc, 
            position, 
            gauge.offset, 
            indicatorWidth, 
            30, 
            Graphics.COLOR_WHITE
        );
    }
}

 

