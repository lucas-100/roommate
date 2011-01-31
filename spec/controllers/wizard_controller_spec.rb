require 'spec_helper'

describe WizardController do
  describe "GET house" do
    it "renders the page" do
      get :house
    end
  end
end