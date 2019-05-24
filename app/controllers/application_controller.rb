class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Pundit

  # If Authorization by pundit fails
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Transform '-' to '_' in the keys of attributes in the request body, only json api data.
  # before_action :transform_param_keys

  # meta of pagination
  def pagination_dict(object)
    {
        # current_page: object.current_page,
        # next_page: object.next_page,
        # prev_page: object.prev_page,
        # total_pages: object.total_pages,
        total_count: object.total_count
    }
  end

  def get_current_user
    authenticate_or_request_with_http_token do |token, options|
      begin
        payload = JsonWebToken.decode(token)
      rescue
        return render status: :unauthorized
      end

      if payload
        @current_user ||= User.find_by(login_name: payload[:login_name])
      else
        render status: :unauthorized
      end
    end
  end

  # Get the current user
  def current_user
    @current_user ||= nil
  end

  def transform_param_keys
    # params[:data][:attributes].transform_keys! { |key| key.to_s.tr("-", "_") } if request.headers.include?('Content-Type') && request.headers['Content-Type'] == 'application/vnd.api+json'
    params[:data][:attributes].transform_keys! {|key| key.to_s.tr("-", "_")} if params[:data] && params[:data][:attributes]
  end

  private
  # if user authorization fails
  def user_not_authorized
    user = User.new
    user.errors.add(:error, "该用户没有操作权限")
    render status: :forbidden, json: user, serializer: ActiveModel::Serializer::ErrorSerializer
  end
end
