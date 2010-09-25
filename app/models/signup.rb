class Signup < ActiveRecord::Base
  
  validate :check_email_against_people
  validates_presence_of :email
  validates_presence_of :name
  validates_uniqueness_of :email
  
  private
  def check_email_against_people
    people = Person.where("email = ?", email).all
    if people.count > 0
      errors[:base] << "You already have an account with us [="
    end
  end
  
end
