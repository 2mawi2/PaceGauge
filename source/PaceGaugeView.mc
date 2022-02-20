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

    public function initialize(start, end, offset, height) {
        self.start = start;
        self.end = end;
        self.offset = offset;
        self.height = height;
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
            var labelView = View.findDrawableById("label");
            labelView.locY = labelView.locY - 30;

            var valueView = View.findDrawableById("value");
            valueView.locY = valueView.locY + 7;
        }
        (View.findDrawableById("label") as Text).setText("Pace");//Rez.Strings.label);
    }




    // The given info object contains all the current workout information.
    // Calculate a value and save it locally in this method.
    // Note that compute() and onUpdate() are asynchronous, and there is no
    // guarantee that compute() will be called before onUpdate().
    function compute(info as Activity.Info) as Void {
        // See Activity.Info in the documentation for available information.
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
        if (obscurityFlags == 7) {// || obscurityFlags == 13) {
            additionalBottomAndTopPadding = dc.getWidth()* 0.1 ;
        }
        var padding = dc.getWidth()*0.15 + additionalBottomAndTopPadding;
        var height = 10;
        var start = 0 + padding;
        var end = dc.getWidth() - padding * 2;
        var offset = dc.getHeight()/10;
        return new PaceGauge(start, end, offset, height);
    }

    function drawGauge(dc as DC) {
        var gauge = calculatePaceGauge(dc);
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        dc.fillRectangle(
            gauge.start, 
            gauge.offset,
            gauge.end,
            gauge.height
        );
    }

}

 

