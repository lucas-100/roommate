class DashboardController < ApplicationController
  before_filter :person_required
  before_filter :house, :person

  respond_to :json
  respond_to :html

  def index
  end
end
