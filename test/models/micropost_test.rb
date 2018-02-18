require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    # このコードは慣習的には正しくない
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  # [micropostが有効かどうか]のテスト
  test "should be valid" do
    assert @micropost.valid?
  end

  # [user_idが存在しているか]のテスト
  test "user_id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  # [contentが存在しているかの]テスト
  test "content should be present" do
    @micropost.content = ""
    assert_not @micropost.valid?
  end

  # [contentが140文字以下]かのテスト
  test "content should be at most 140 characters" do
    @micropost.content = "a"*141
    assert_not @micropost.valid?
  end


  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
