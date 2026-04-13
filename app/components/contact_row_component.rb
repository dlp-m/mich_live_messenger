class ContactRowComponent < ViewComponent::Base
  def initialize(name:, initials:, color:, status: :online, message: nil)
    @name     = name
    @initials = initials
    @color    = color
    @status   = status.to_sym
    @message  = message
  end

  def offline?
    @status == :offline
  end
end
