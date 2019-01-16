require "application_system_test_case"

class BrochuresTest < ApplicationSystemTestCase
  setup do
    @brochure = brochures(:one)
  end

  test "visiting the index" do
    visit brochures_url
    assert_selector "h1", text: "Brochures"
  end

  test "creating a Brochure" do
    visit brochures_url
    click_on "New Brochure"

    fill_in "Arrival", with: @brochure.arrival
    fill_in "Departure", with: @brochure.departure
    fill_in "Room", with: @brochure.room_id
    fill_in "Title", with: @brochure.title
    click_on "Create Brochure"

    assert_text "Brochure was successfully created"
    click_on "Back"
  end

  test "updating a Brochure" do
    visit brochures_url
    click_on "Edit", match: :first

    fill_in "Arrival", with: @brochure.arrival
    fill_in "Departure", with: @brochure.departure
    fill_in "Room", with: @brochure.room_id
    fill_in "Title", with: @brochure.title
    click_on "Update Brochure"

    assert_text "Brochure was successfully updated"
    click_on "Back"
  end

  test "destroying a Brochure" do
    visit brochures_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Brochure was successfully destroyed"
  end
end
