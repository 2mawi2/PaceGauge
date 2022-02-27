
(:test)
function should_return_max_of_two_numbers(logger as Logger) as Boolean {
    return max(1, 2) == 2;
}

(:test)
function should_return_max_of_two_numbers2(logger as Logger) as Boolean {
    return max(4, 2) == 4;
}

(:test)
function should_return_min_of_two_numbers(logger as Logger) as Boolean {
    return min(1, 2) == 1;
}

(:test)
function should_return_min_of_two_numbers2(logger as Logger) as Boolean {
    return min(4, 2) == 2;
}

(:test)
function should_clip_number_to_min_and_max(logger as Logger) as Boolean {
    return clip(1, 2, 3) == 2;
}

(:test)
function should_clip_number_to_min_and_max2(logger as Logger) as Boolean {
    return clip(4, 2, 3) == 3;
}

(:test)
function should_clip_number_to_min_and_max3(logger as Logger) as Boolean {
    return clip(-1, -2, 3) == -1;
}

(:test)
function should_convert_mps_to_pace(logger as Logger) as Boolean {
    var meterPerSeconds = 8.0;
    return mpsToPace(meterPerSeconds) - 2.083333333333333f < 0.00001f;
}

(:test)
function should_pace_conversion_should_not_fail_for_zero(logger as Logger) as Boolean {
    return areClose(mpsToPace(0.0f), 0.0f);
}

(:test)
function should_return_absolute_negative_value(logger as Logger) as Boolean {
    return abs(-1) == 1;
}

(:test)
function should_return_absolute_positive_value(logger as Logger) as Boolean {
    return abs(1) == 1;
}

(:test)
function should_return_absolute_zero_value(logger as Logger) as Boolean {
    return abs(0.0f) == 0.0f;
}


