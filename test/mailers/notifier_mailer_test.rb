require 'test_helper'

class NotifierMailerTest < ActionMailer::TestCase
  test "gmail_message" do
    mail = NotifierMailer.gmail_message
    assert_equal "Gmail message", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
