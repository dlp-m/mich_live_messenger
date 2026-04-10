require "test_helper"

class UserTest < ActiveSupport::TestCase
  # --- Validations ---

  test "valid with all required attributes" do
    assert Fabricate.build(:user).valid?
  end

  test "invalid without username" do
    user = Fabricate.build(:user, username: "")
    assert_not user.valid?
    assert user.errors[:username].any?
  end

  test "invalid without email" do
    user = Fabricate.build(:user, email: "")
    assert_not user.valid?
  end

  test "invalid with duplicate email" do
    existing = Fabricate(:user)
    user = Fabricate.build(:user, email: existing.email)
    assert_not user.valid?
    assert user.errors[:email].any?
  end

  test "invalid with short password" do
    user = Fabricate.build(:user, password: "short")
    assert_not user.valid?
  end

  test "invalid with nil status" do
    user = Fabricate.build(:user)
    user.write_attribute(:status, nil)
    assert_not user.valid?
    assert user.errors[:status].any?
  end

  test "invalid with personal_message over 129 characters" do
    user = Fabricate.build(:user, personal_message: "a" * 130)
    assert_not user.valid?
  end

  test "valid with personal_message at 129 characters" do
    user = Fabricate.build(:user, personal_message: "a" * 129)
    assert user.valid?
  end

  # --- Enumerize ---

  test "status values are available, away, busy" do
    assert_equal %w[available away busy], User.status.values
  end

  test "default status is available" do
    assert_equal "available", Fabricate.build(:user).status.to_s
  end

  test "status available? predicate" do
    assert Fabricate.build(:user, status: :available).status.available?
  end

  test "status away? predicate" do
    assert Fabricate.build(:user, status: :away).status.away?
  end

  test "status busy? predicate" do
    assert Fabricate.build(:user, status: :busy).status.busy?
  end

  test "invalid with unknown status value" do
    user = Fabricate.build(:user, status: "invisible")
    assert_not user.valid?
  end
end
