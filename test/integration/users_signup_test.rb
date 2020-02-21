require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

	test "invalid signup information(blank)" do
		get signup_path
		assert_no_difference 'User.count' do
			post signup_path, params: {
				user: {
					name:  "",
					email: "",
					password:              "",
					password_confirmation: ""
				}
			}
		end
		assert_template 'users/new'
		assert_select 'div#error_explanation'
		assert_select 'div.field_with_errors'
		assert_select 'ul' do
			assert_select 'li', 'Name can\'t be blank'
			assert_select 'li', 'Email can\'t be blank'
			assert_select 'li', 'Email is invalid'
			assert_select 'li', 'Password can\'t be blank'
			assert_select 'li', 'Password is too short (minimum is 6 characters)'
			assert_select 'li', 'Password can\'t be blank'
		end
    assert_select 'form[action="/signup"]'
	end

	test "invalid signup information(wrong password)" do
		get signup_path
		assert_no_difference 'User.count' do
			post signup_path, params: {
				user: {
					name:  "user",
					email: "user@invalid.com",
					password:              "foobar",
					password_confirmation: "boobar" } }
		end
		assert_template 'users/new'
		assert_select 'div#error_explanation'
		assert_select 'div.field_with_errors'
		assert_select 'ul' do
			assert_select 'li', 'Password confirmation doesn\'t match Password'
		end
    assert_select 'form[action="/signup"]'
	end

	test "valid signup information" do
		get signup_path
		assert_difference 'User.count', 1 do
			post users_path, params: { user: {
				name:  "Example User",
				email: "user@example.com",
				password:              "password",
				password_confirmation: "password" } }
		end
		follow_redirect!
		assert_template 'users/show'
		assert_not flash.empty?
	end

end
