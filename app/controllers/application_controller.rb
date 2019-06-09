class ApplicationController < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  private

  def current_user
    @current_user ||= User.first
  end
end
