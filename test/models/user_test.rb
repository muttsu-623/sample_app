require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  # [validationが動いているか]のテスト
  test "should be valid" do
    assert @user.valid?
  end

  # [nameの検証がしっかりと動いているか確認する処理]のテスト
  test "name should be present" do
    @user.name = ""
    assert_not @user.valid?
  end

  # [emailの検証が有効か確認する処理]のテスト
  test "email should be present" do
    @user.email = ""
    assert_not @user.valid?
  end

  # [名前が長いと無効にする処理]のテスト
  test "name should not be too long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end

  # [メアドが長いと無効にする処理]のテスト
  test "email should not be too long" do
    @user.email = "a"*244 + "@example.com"
    assert_not @user.valid?
  end

  # [正しいメールアドレスの代入を有効とする処理]のテスト
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  # [正しくないメールアドレスの代入を無効とする処理]のテスト
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]      # 有効でないメールアドレスたち
    invalid_addresses.each do |invalid_address|                               # invalid_addressにアドレスを代入し，くり返す
      @user.email = invalid_address                                           # メアドの代入
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid" # メアドが有効でないためtrueが返ってくる
    end
  end

  # [同じメールアドレスがある場合，saveを受け付けないという処理]のテスト
  test "email addresses should be unique" do
    duplicate_user = @user.dup                # ユーザー情報の複製
    duplicate_user.email.upcase!              # ユーザーのメアドを大文字にする
    @user.save                                # saveの前に処理が入る
    assert_not duplicate_user.valid?          # 有効でないとtrueとなる

  end

  # [saveの前に，emailをすべて小文字にする処理]のテスト
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # [パスワードが空白のとき，無効とする検証]のテスト
  test "password should be present(nonblank)" do
    @user.password = @user.password_confirmation = ""*6
    assert_not @user.valid?
  end

  # 『パスワードが6文字未満のとき，無効とする検証』のテスト
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a"*5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?("")
  end
end
