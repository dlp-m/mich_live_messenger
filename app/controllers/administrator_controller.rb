# frozen_string_literal: true
class AdministratorController < ApplicationController
  include Pagy::Backend
  layout 'administrator'
  before_action :authenticate_administrator!, :set_default_locale
  authorize :user, through: :current_administrator

  private

  def namespace
    @namespace ||= Bo::Administrators
  end

  def set_default_locale
    I18n.default_locale = :fr
  end

  protected

  # Devise routing overwrite for multiples resources
  def after_sign_in_path_for(resource)
    send(:"#{resource.class.name.underscore.pluralize}_root_path")
  end

  def after_sign_out_path_for(resource)
    send(:"new_#{resource}_session_path")
  end
end
