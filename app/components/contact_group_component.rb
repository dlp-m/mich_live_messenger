class ContactGroupComponent < ViewComponent::Base
  def initialize(label:, open: true)
    @label = label
    @open  = open
  end
end
