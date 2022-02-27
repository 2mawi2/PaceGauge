

(:test)
function should_update_pace_if_current_speed_not_null(logger as Logger) as Boolean {
    // arrange
    var viewModel = new PaceGaugeViewModel();
    // act
    viewModel.onNewCurrentSpeed(1.0f);
    // assert
    return viewModel.pace != 0.0f;
}

    
(:test)
function should_convert_mps_to_pace_if_current_speed_not_null(logger as Logger) as Boolean {
    // arrange
    var mps = 1.0f;
    var viewModel = new PaceGaugeViewModel();
    // act
    viewModel.onNewCurrentSpeed(mps);
    // assert
    return viewModel.pace == mpsToPace(mps);
}

(:test)
function should_not_throw_when_current_speed_is_zero(logger as Logger) as Boolean {
    // arrange
    var viewModel = new PaceGaugeViewModel();
    // act
    viewModel.onNewCurrentSpeed(0.0f);
    // assert
    return viewModel.pace == 0.0f;
}

    
(:test)
function should_calculate_threshold_pace(logger as Logger) as Boolean {
    // arrange
    var viewModel = new PaceGaugeViewModel();
    var thresholdMinutes = 1;
    var thresholdSeconds = 30;
    // act
    viewModel.onNewThresholdPaceConfig(thresholdMinutes, thresholdSeconds);
    // assert
    return viewModel.thresholdPace == 1.5;
}

(:test)
function should_clip_low_configured_minutes_when_calculating_threshold_pace(logger as Logger) as Boolean {
    // arrange
    var viewModel = new PaceGaugeViewModel();
    var thresholdMinutes = -1;
    var thresholdSeconds = 30;
    // act
    viewModel.onNewThresholdPaceConfig(thresholdMinutes, thresholdSeconds);
    // assert
    return viewModel.thresholdPace == 0.5;
}

(:test)
function should_clip_low_configured_seconds_when_calculating_threshold_pace(logger as Logger) as Boolean {
    // arrange
    var viewModel = new PaceGaugeViewModel();
    var thresholdMinutes = 1;
    var thresholdSeconds = -1;
    // act
    viewModel.onNewThresholdPaceConfig(thresholdMinutes, thresholdSeconds);
    // assert
    return viewModel.thresholdPace == 1.0;
}

(:test)
function should_clip_high_configured_minutes_when_calculating_threshold_pace(logger as Logger) as Boolean {
    // arrange
    var viewModel = new PaceGaugeViewModel();
    var thresholdMinutes = 61;
    var thresholdSeconds = 30;
    // act
    viewModel.onNewThresholdPaceConfig(thresholdMinutes, thresholdSeconds);
    // assert
    return viewModel.thresholdPace == 60.5;
}

(:test)
function should_clip_high_configured_seconds_when_calculating_threshold_pace(logger as Logger) as Boolean {
    // arrange
    var viewModel = new PaceGaugeViewModel();
    var thresholdMinutes = 1;
    var thresholdSeconds = 61;
    // act
    viewModel.onNewThresholdPaceConfig(thresholdMinutes, thresholdSeconds);
    // assert
    return areClose(viewModel.thresholdPace, 1.98333333f);
}

(:test)
function should_only_update_threshold_pace_if_config_changed(logger as Logger) as Boolean {
    // arrange
    var viewModel = new PaceGaugeViewModel();
    viewModel.thresholdPace = 1.0f;
    var thresholdMinutes = 0.0;
    var thresholdSeconds = 0.0;
    // act
    viewModel.onNewThresholdPaceConfig(thresholdMinutes, thresholdSeconds);
    // assert
    return viewModel.thresholdPace == 1.0f;
}

