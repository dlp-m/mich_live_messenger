Fabricator(:user) do
  email { sequence(:user_email) { |i| "user#{i}@example.com" } }
  password { "password123" }
  username { sequence(:username) { |i| "User #{i}" } }
  status { :available }
end
