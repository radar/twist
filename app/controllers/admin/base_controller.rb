module Admin
  class BaseController < ApplicationController
    before_filter :authorize_admin!

    def authorize_admin!
      
    end
  end
end
