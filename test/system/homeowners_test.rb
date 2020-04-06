require "application_system_test_case"

class HomeownersTest < ApplicationSystemTestCase
  setup do
    @homeowner = homeowners(:one)
  end

  test "visiting the index" do
    visit homeowners_url
    assert_selector "h1", text: "Homeowners"
  end

  test "creating a Homeowner" do
    visit homeowners_url
    click_on "New Homeowner"

    fill_in "Activation code", with: @homeowner.activation_code
    fill_in "Address", with: @homeowner.address
    check "Driveway active" if @homeowner.driveway_active
    fill_in "Driveway description", with: @homeowner.driveway_description
    fill_in "Driveway price", with: @homeowner.driveway_price
    check "Driveway verified" if @homeowner.driveway_verified
    fill_in "Last modified", with: @homeowner.last_modified
    fill_in "Latitude", with: @homeowner.latitude
    fill_in "Longitude", with: @homeowner.longitude
    fill_in "Number ratings", with: @homeowner.number_ratings
    fill_in "Total ratings", with: @homeowner.total_ratings
    fill_in "User", with: @homeowner.user_id
    click_on "Create Homeowner"

    assert_text "Homeowner was successfully created"
    click_on "Back"
  end

  test "updating a Homeowner" do
    visit homeowners_url
    click_on "Edit", match: :first

    fill_in "Activation code", with: @homeowner.activation_code
    fill_in "Address", with: @homeowner.address
    check "Driveway active" if @homeowner.driveway_active
    fill_in "Driveway description", with: @homeowner.driveway_description
    fill_in "Driveway price", with: @homeowner.driveway_price
    check "Driveway verified" if @homeowner.driveway_verified
    fill_in "Last modified", with: @homeowner.last_modified
    fill_in "Latitude", with: @homeowner.latitude
    fill_in "Longitude", with: @homeowner.longitude
    fill_in "Number ratings", with: @homeowner.number_ratings
    fill_in "Total ratings", with: @homeowner.total_ratings
    fill_in "User", with: @homeowner.user_id
    click_on "Update Homeowner"

    assert_text "Homeowner was successfully updated"
    click_on "Back"
  end

  test "destroying a Homeowner" do
    visit homeowners_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Homeowner was successfully destroyed"
  end
end
