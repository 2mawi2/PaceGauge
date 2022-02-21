import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;


class PaceGauge 
{
    public var start;
    public var end;
    public var offset;
    public var height;
    public var currentPacePercent;

    public function length() as Number {
        return self.end - self.start;
    }

    public function getIndicatorPosition() as Number {
        return self.start + self.length() * (self.currentPacePercent / 100.0);
    }

    public function highlightedIndex() as Number {
        var tileLength = self.length() / 6;
        for (var i = 0; i < 6; i++) {
            if (self.getIndicatorPosition() <= self.start + tileLength * (i + 1)) {
                return i;
            }
        }
        return 0;
    }

    public function initialize(
        start, 
        end, 
        offset, 
        height, 
        currentPacePercent
    ) {
        self.start = start;
        self.end = end;
        self.offset = offset;
        self.height = height;
        self.currentPacePercent = currentPacePercent;
    }
}


class PaceGaugeView extends WatchUi.DataField {

    hidden var mValue as Numeric;

    function initialize() {
        DataField.initialize();
        mValue = 0.0f;
    }

    // Set your layout here. Anytime the size of obscurity of
    // the draw context is changed this will be called.
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
            valueView.locY = valueView.locY + 7;
        }
    }


    function compute(info as Activity.Info) as Void {
        if(info has :currentSpeed){
            if(info.currentSpeed != null){
                mValue = mpsToPace(info.currentSpeed) as Number;
            } else {
                mValue = 0.0f;
            }
        }
    }

    function mpsToPace(mps as Float) as Float {
        var kmh = mps * 3.6;
        var pace = 60.0 / kmh;
        return pace;
    } 

    // Display the value you computed here. This will be called
    // once a second when the data field is visible.
    function onUpdate(dc as Dc) as Void {
        // Set the background color
        (View.findDrawableById("Background") as Text).setColor(getBackgroundColor());

        // Set the foreground color and value
        var value = View.findDrawableById("value") as Text;
        if (getBackgroundColor() == Graphics.COLOR_BLACK) {
            value.setColor(Graphics.COLOR_WHITE);
        } else {
            value.setColor(Graphics.COLOR_BLACK);
        }
        value.setText(mValue.format("%.2f"));
        View.onUpdate(dc);
        drawGauge(dc);
    }

    function calculatePaceGauge(dc as DC) as PaceGauge {
        var obscurityFlags = DataField.getObscurityFlags();
        var additionalBottomAndTopPadding = 0.0;
        var offset = dc.getHeight()/10;
        if (obscurityFlags == 7) {// || obscurityFlags == 13) {
            offset = dc.getHeight() - offset;
        }
        var padding = dc.getWidth() * 0.15 + additionalBottomAndTopPadding;
        var height = 8;
        var start = 0 + padding;
        var end = dc.getWidth() - padding;
        var currentPacePercent = 51; 
        return new PaceGauge(start, end, offset, height, currentPacePercent);
    }

    function getColors() as Array {
        return [
            Graphics.COLOR_RED, 
            Graphics.COLOR_BLUE, 
            Graphics.COLOR_DK_BLUE, 
            Graphics.COLOR_DK_GREEN, 
            Graphics.COLOR_YELLOW,
            Graphics.COLOR_ORANGE
        ];
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

    function drawGauge(dc as DC) {
        dc.setAntiAlias(true);
        var gauge = calculatePaceGauge(dc);
        var tile = gauge.length() / 6;
        var colors = getColors();
        for(var i = 0; i < 6; i++) {
            var height = gauge.height;
            if (i == gauge.highlightedIndex()) {
                height = height * 1.7;
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

 

