class ContactAvatarComponent < ViewComponent::Base
  STATUS_COLORS = {
    online: "#22aa22",
    away:   "#ddaa22",
    busy:   "#cc4444",
    offline: "#9ca3af"
  }.freeze

  def initialize(initials:, color:, status: :online)
    @initials = initials
    @color    = color
    @status   = status.to_sym
  end

  def status_color
    STATUS_COLORS.fetch(@status, STATUS_COLORS[:offline])
  end
end
