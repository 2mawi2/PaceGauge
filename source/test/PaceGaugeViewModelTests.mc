

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