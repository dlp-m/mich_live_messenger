Fabricator(:friendship) do
  requester { Fabricate(:user) }
  receiver { Fabricate(:user) }
  status { :pending }
end

Fabricator(:accepted_friendship, from: :friendship) do
  status { :accepted }
end

Fabricator(:declined_friendship, from: :friendship) do
  status { :declined }
end

Fabricator(:blocked_friendship, from: :friendship) do
  status { :blocked }
end
