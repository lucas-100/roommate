require 'spec_helper'

describe House do
  before(:each) do
    @house = House.new
  end
  
  it "is valid with valid attributes" do
    @house.should be_valid
  end
end