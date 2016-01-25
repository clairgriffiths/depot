require 'test_helper'

class StoreControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
		# Also check that the page contains layout, product info and number formatting
		assert_select "#columns #side a", minimum: 4
		assert_select "#main .entry", 3
		assert_select "h3", "MyString"
		assert_select ".price", /\$[,\d]+\.\d\d/
  end

end
