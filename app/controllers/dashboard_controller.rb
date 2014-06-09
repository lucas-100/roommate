class DashboardController < ApplicationController
  before_filter :person_required
  before_filter :check_for_house
  before_filter :house, :person

  respond_to :json
  respond_to :html

  def index
    respond_to do |format|
      format.json do
        res = Jbuilder.encode do |json|
          json.person do |per|
            per.name    person.name
            per.debtees person.all_debts_loaned
            per.debtors person.all_debts_owed
          end
        end

        render :json => res
      end

      format.all  { render }
    end
  end

  protected
    def check_for_house
      redirect_to house_wizard_path if current_person.house_id.nil?
    end
end
