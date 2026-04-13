# frozen_string_literal: true

if Rails.env.development?
  users = [
    { email: "alice@example.com",   username: "alice",   status: :available, personal_message: "Hello there!" },
    { email: "bob@example.com",     username: "bob",     status: :available,      personal_message: "Be right back" },
    { email: "charlie@example.com", username: "charlie", status: :available,      personal_message: "Do not disturb" },
    { email: "diana@example.com",   username: "diana",   status: :available, personal_message: nil },
    { email: "eve@example.com",     username: "eve",     status: :available,      personal_message: nil }
  ]

  users.each do |attrs|
    User.find_or_create_by(email: attrs[:email]).update!(
      username: attrs[:username],
      status: attrs[:status],
      personal_message: attrs[:personal_message],
      password: "password"
    )
  end

  me = User.first
  friends = User.where(email: %w[alice@example.com bob@example.com charlie@example.com])

  friends.each do |friend|
    next if Friendship.between(me, friend).exists?

    Friendship.create!(requester: me, receiver: friend, status: :accepted)
  end
end
