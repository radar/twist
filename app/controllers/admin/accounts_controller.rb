module Admin
  class AccountsController < Admin::BaseController
    def index
      @account = Account.page(params[:page])
    end
  end
end
