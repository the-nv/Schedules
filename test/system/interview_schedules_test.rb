require "application_system_test_case"

class InterviewSchedulesTest < ApplicationSystemTestCase
  setup do
    @interview_schedule = interview_schedules(:one)
  end

  test "visiting the index" do
    visit interview_schedules_url
    assert_selector "h1", text: "Interview Schedules"
  end

  test "creating a Interview schedule" do
    visit interview_schedules_url
    click_on "New Interview Schedule"

    click_on "Create Interview schedule"

    assert_text "Interview schedule was successfully created"
    click_on "Back"
  end

  test "updating a Interview schedule" do
    visit interview_schedules_url
    click_on "Edit", match: :first

    click_on "Update Interview schedule"

    assert_text "Interview schedule was successfully updated"
    click_on "Back"
  end

  test "destroying a Interview schedule" do
    visit interview_schedules_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Interview schedule was successfully destroyed"
  end
end
