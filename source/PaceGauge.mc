
class PaceGauge 
{
    public var start;
    public var end;
    public var offset;
    public var height;
    public var currentPacePercent;
   
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

    public function length() as Number {
        return self.end - self.start;
    }

    public function getIndicatorPosition() as Number {
        return self.start + self.length() * (self.currentPacePercent / 100.0);
    }


    public function highlightedIndex() as Number {
        var tileLength = self.tileLength();
        for (var i = 0; i < 6; i++) {
            if (self.getIndicatorPosition() <= self.start + tileLength * (i + 1)) {
                return i;
            }
        }
        return 0;
    }

    public function tileLength() as Number {
        return self.length() / 6;
    }


    function getColors() as Array {
        return [
            Graphics.COLOR_BLUE, 
            Graphics.COLOR_GREEN, 
            Graphics.COLOR_YELLOW, 
            Graphics.COLOR_ORANGE, 
            Graphics.COLOR_RED,
            Graphics.COLOR_DK_RED
        ];
    }

}

