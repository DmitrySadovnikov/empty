module Web
  module V1
    class ApplicationController < Sinatra::Base
      before do
        halt 401 unless current_user
      end

      def current_user
        @current_user ||= User.first
      end
    end
  end
end
