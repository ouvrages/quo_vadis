require 'test_helper'

class ConfigTest < ActiveSupport::IntegrationCase

  setup do
    user_factory 'Bob', 'bob', 'secret'
  end

  test 'signed_in_url config' do
    sign_in_as 'bob', 'secret'
    assert_equal root_path, current_path
    visit sign_out_path

    QuoVadis.signed_in_url = :articles

    sign_in_as 'bob', 'secret'
    assert_equal articles_path, current_path
  end

  test 'signed_in_url proc config' do
    QuoVadis.signed_in_url = Proc.new do |user, controller|
      user.name == 'Bob' ? :articles : :root
    end
    sign_in_as 'bob', 'secret'
    assert_equal articles_path, current_path

    QuoVadis.signed_in_url = Proc.new do |user, controller|
      user.name != 'Bob' ? :articles : :root
    end
    sign_in_as 'bob', 'secret'
    assert_equal root_path, current_path
  end

  test 'override_original_url config' do
    visit new_article_path
    assert_equal sign_in_path, current_path
    sign_in_as 'bob', 'secret'
    assert_equal new_article_path, current_path
    visit sign_out_path

    QuoVadis.override_original_url = true

    visit new_article_path
    assert_equal sign_in_path, current_path
    sign_in_as 'bob', 'secret'
    assert_equal root_path, current_path
  end

  test 'blocked config' do
    QuoVadis.blocked = Proc.new do |controller|
      controller.params[:username] == 'bob'
    end
    sign_in_as 'bob', 'secret'
    within '.flash' do
      assert page.has_content?('Sorry, your account is blocked.')
    end
    sign_in_as 'jim', 'secret'
    within '.flash' do
      assert page.has_no_content?('Sorry, your account is blocked.')
    end
  end

  test 'signed_out_url config' do
    visit sign_out_path
    assert_equal root_path, current_path

    QuoVadis.signed_out_url = :articles

    visit sign_out_path
    assert_equal articles_path, current_path
  end

  test 'signed_in_hook' do
    QuoVadis.signed_in_hook = Proc.new do |user, request|
      user.update_attributes :name => 'Robert'
    end
    sign_in_as 'bob', 'secret'
    within '#topnav' do
      assert page.has_content?('You are signed in as Robert.')
    end
  end

  test 'failed_sign_in hook' do
    QuoVadis.failed_sign_in_hook = Proc.new do |request|
      request.flash[:muppet] = request.params[:username]
    end
    sign_in_as 'bob', 'wrong'
    within '.flash.muppet' do
      assert page.has_content?('bob')
    end
  end

  test 'signed_out hook' do
    QuoVadis.signed_out_hook = Proc.new do |user, request|
      request.flash[:fyi] = user.name
    end
    sign_in_as 'bob', 'secret'
    visit sign_out_path

    within '.flash.fyi' do
      assert page.has_content?('Bob')
    end
  end

  test 'layout config' do
    QuoVadis.layout = 'sessions'
    visit sign_in_path
    assert page.has_content?('Sessions layout')
  end

  test 'change-password mailer from config' do
    QuoVadis.from = 'jim@example.com'
    (user = User.last).generate_token
    email = QuoVadis::Notifier.change_password(user)
    assert_equal ['jim@example.com'], email.from
  end

end
