import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;


class PaceGaugeView extends WatchUi.DataField {

    hidden var viewModel as PaceGaugeViewModel;

    function initialize() {
        self.viewModel = new PaceGaugeViewModel();
        DataField.initialize();
        
    }

    function handleSettingUpdate() {
        updateThresholdPace();
    }

    function updateThresholdPace() {
        var thresholdMinutes = Application.Properties.getValue("thresholdMinutes") as Number;
        var thresholdSeconds = Application.Properties.getValue("thresholdSeconds") as Number;
        viewModel.onNewThresholdPaceConfig(thresholdMinutes, thresholdSeconds);
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
        } else if (obscurityFlags == 7) {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var valueView = View.findDrawableById("value");
            valueView.locY = valueView.locY - 10;
        } else {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var valueView = View.findDrawableById("value");
            valueView.locY = valueView.locY + 15;
        }
    }

    function compute(info as Activity.Info) as Void {
        if(info has :currentSpeed){
            self.viewModel.onNewCurrentSpeed(info.currentSpeed);
        }
    }


    function onUpdate(dc as Dc) as Void {
        if (viewModel.thresholdPace == -1.0) {
            updateThresholdPace();
        }
        
        (View.findDrawableById("Background") as Text).setColor(getBackgroundColor());
        var value = View.findDrawableById("value") as Text;
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            value.setColor(Graphics.COLOR_WHITE);
        } else {
            value.setColor(Graphics.COLOR_BLACK);
        }
        if (viewModel.thresholdPace != -1.0) {
            hideConfigError();
            var gauge = calculatePaceGauge(dc);
            if (viewModel.pace == 0.0f) {
                value.setText("--:--");
            } else {
                value.setText(format(viewModel.pace));
            }
            View.onUpdate(dc);
            drawGauge(dc, gauge);
        } else {
            showConfigError();
            View.onUpdate(dc);
        }
    }

    function showConfigError() {
        var error = View.findDrawableById("error") as Text;
        error.setText("no config");
    }

    function hideConfigError() {
        var error = View.findDrawableById("error") as Text;
        error.setText("");
    }

    function format(digitalPace as Float) as String {
        var minutes = Math.floor(digitalPace);
        var seconds = Math.floor((digitalPace - minutes) * 60);
        var formattedMinutes = minutes.format("%.0f");
        var formattedSeconds = seconds.format("%.0f");
        if (seconds < 10) {
            formattedSeconds = "0" + formattedSeconds;
        }
        var paceString = formattedMinutes + ":" + formattedSeconds;
        return paceString;
    }

    function calculatePaceGauge(dc as DC) as PaceGauge {
        var obscurityFlags = DataField.getObscurityFlags();
        var additionalBottomAndTopPadding = 0.0;
        var offset = dc.getHeight()/10;
        if (obscurityFlags == 7) {
            offset = dc.getHeight() - offset * 2;
        }
        var padding = dc.getWidth() * 0.14 + additionalBottomAndTopPadding;
        var height = 9;
        var start = 0 + padding;
        var end = dc.getWidth() - padding;
        var currentPacePercent = viewModel.calculatePacePercentage(); 
        var isInverse = obscurityFlags == 7;
        return new PaceGauge(start, end, offset, height, currentPacePercent, isInverse);
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

    function drawGauge(dc as DC, gauge as PaceGauge) as Void {
        dc.setAntiAlias(true);
        var tile = gauge.tileLength();
        var colors = gauge.getColors();
        
        for(var i = 0; i < 6; i++) {
            var height = gauge.height;
            if (i == gauge.highlightedIndex() && viewModel.pace > 0.0001f) {
                height = height * 2.5;
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
        if (viewModel.pace > 0.0001f) {
            drawCurrentPace(dc, gauge);
        }
    }

    function drawCurrentPace(dc as DC, gauge as PaceGauge) {
        var indicatorWidth = 10.0;
        var position = gauge.getIndicatorPosition();
        var indicatorY = gauge.offset - 5;
        var indicatorHeight = 30;
        if (gauge.isInverse) {
            indicatorY = indicatorY - gauge.height;
        }
        fillRectangleWithContrast(
            dc, 
            position, 
            indicatorY, 
            indicatorWidth, 
            indicatorHeight, 
            Graphics.COLOR_WHITE
        );
    }
}

 

