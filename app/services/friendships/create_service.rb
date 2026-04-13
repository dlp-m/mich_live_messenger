module Friendships
  class CreateService
    Result = Struct.new(:success?, :friendship, :error, keyword_init: true)

    def self.call(requester:, email:)
      new(requester, email).call
    end

    def initialize(requester, email)
      @requester = requester
      @email = email.to_s.strip.downcase
    end

    def call
      return failure(:user_not_found) unless receiver
      return failure(:self_request) if self_request?

      existing = Friendship.between(@requester, receiver).first

      if existing
        return handle_existing(existing)
      end

      friendship = Friendship.new(requester: @requester, receiver: receiver)

      if friendship.save
        Result.new(success?: true, friendship: friendship, error: nil)
      else
        model_failure(friendship)
      end
    rescue ActiveRecord::RecordNotUnique
      failure(:already_exists)
    end

    private

    def receiver
      @receiver ||= User.find_by(email: @email)
    end

    def self_request?
      @requester.id == receiver.id
    end

    def handle_existing(friendship)
      if friendship.status.pending? || friendship.status.accepted?
        return failure(:already_exists)
      end

      if friendship.status.blocked?
        return failure(:blocked)
      end

      # declined → reset to pending
      if friendship.update(status: :pending, requester: @requester, receiver: receiver)
        Result.new(success?: true, friendship: friendship, error: nil)
      else
        model_failure(friendship)
      end
    end

    def failure(key)
      Result.new(success?: false, friendship: nil, error: I18n.t("friendships.errors.#{key}"))
    end

    def model_failure(friendship)
      Result.new(success?: false, friendship: nil, error: friendship.errors.full_messages.first)
    end
  end
end
