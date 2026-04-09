class WindowComponent < ViewComponent::Base
  def initialize(title:, width: "490px")
    @title = title
    @width = width
  end
end
