class WizardController < ApplicationController
  before_filter :load_person

  def house
    @house = House.new
  end
end
