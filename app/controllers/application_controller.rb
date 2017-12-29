class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pundit
  protect_from_forgery with: :exception

  # Pundit: white-list approach.
  after_action :verify_authorized, except: [:index,:search, :search_by_tag, :index_by_tag], unless: :skip_pundit?
  after_action :verify_policy_scoped, only: [:index,:search, :search_by_tag, :index_by_tag], unless: :skip_pundit?

  # Uncomment when you *really understand* Pundit!
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # def user_not_authorized
  #   flash[:alert] = "You are not authorized to perform this action."
  #   redirect_to(root_path)
  # end

  protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :instagram_user])
        devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :current_password, :is_female, :date_of_birth, :instagram_user])
    end

  private
  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end
