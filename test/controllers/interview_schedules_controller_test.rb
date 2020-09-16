require 'test_helper'

class InterviewSchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @interview_schedule = interview_schedules(:one)
  end

  test "should get index" do
    get interview_schedules_url
    assert_response :success
  end

  test "should get new" do
    get new_interview_schedule_url
    assert_response :success
  end

  test "should create interview_schedule" do
    assert_difference('InterviewSchedule.count') do
      post interview_schedules_url, params: { interview_schedule: {  } }
    end

    assert_redirected_to interview_schedule_url(InterviewSchedule.last)
  end

  test "should show interview_schedule" do
    get interview_schedule_url(@interview_schedule)
    assert_response :success
  end

  test "should get edit" do
    get edit_interview_schedule_url(@interview_schedule)
    assert_response :success
  end

  test "should update interview_schedule" do
    patch interview_schedule_url(@interview_schedule), params: { interview_schedule: {  } }
    assert_redirected_to interview_schedule_url(@interview_schedule)
  end

  test "should destroy interview_schedule" do
    assert_difference('InterviewSchedule.count', -1) do
      delete interview_schedule_url(@interview_schedule)
    end

    assert_redirected_to interview_schedules_url
  end
end
