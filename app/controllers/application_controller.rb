class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  rescue_from ActionPolicy::Unauthorized, with: :user_not_authorized

  def after_sign_in_path_for(resource)
    return administrators_root_path if resource.is_a?(Administrator)

    root_path
  end

  private

  def user_not_authorized
    respond_to do |format|
      format.json { render json: { error: I18n.t("errors.not_authorized") }, status: :forbidden }
      format.html { redirect_back fallback_location: root_path, alert: I18n.t("errors.not_authorized") }
    end
  end
end
