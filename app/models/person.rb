# TODO - Dry up this model

require 'digest/sha1'

class Person < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  belongs_to :house

  validates :name,  :format     => { :with => Authentication.name_regex, :message => Authentication.bad_name_message },
                    :length     => { :maximum => 100 },
                    :allow_nil  => true

  validates :email, :presence   => true,
                    :uniqueness => true,
                    :format     => { :with => Authentication.email_regex, :message => Authentication.bad_email_message },
                    :length     => { :within => 6..100 }

  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :email, :name, :password, :password_confirmation

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find_by_email(email.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def all_debts_owed
    debts = []
    
    house.people.each do |p|
      total_debt = total_debt_owed(p)
      if total_debt.cents > 0
        debt = {:person => p.name, :amount => total_debt}
        debts << debt
      end
    end
    
    return debts
  end
  
  def all_debts_loaned
    debts = []
    
    house.people.each do |p|
      total_debt = total_debt_loaned(p)
        if total_debt.cents > 0
          debt = {:person => p.name, :amount => total_debt}
          debts << debt
        end
    end
    
    return debts
  end
  
  protected
  def total_debt_owed(to_user)
    payments = 0
    debt_received = 0
    debt_loaned = 0
    
    Debt.where("loaner_id = ? AND person_id = ?", to_user.id, self.id).all.each do |d|
      debt_received = debt_received + d.amount_in_cents
    end
    
    Debt.where("loaner_id = ? AND person_id = ?", self.id, to_user.id).all.each do |d|
      debt_loaned = debt_loaned + d.amount_in_cents
    end
    
    Payment.where("person_paid_id = ? AND person_paying_id = ?", to_user.id, self.id).all.each do |p|
      payments = payments + p.amount_in_cents
    end
    
    total_debt_in_cents = (debt_received) - (payments + debt_loaned)
    
    return Money.new(total_debt_in_cents)
  end
  
  def total_debt_loaned(to_user)
    payments = 0
    debt_received = 0
    debt_loaned = 0
    
    Debt.where("loaner_id = ? AND person_id = ?", to_user.id, self.id).all.each do |d|
      debt_received = debt_received + d.amount_in_cents
    end
    
    Debt.where("loaner_id = ? AND person_id = ?", self.id, to_user.id).all.each do |d|
      debt_loaned = debt_loaned + d.amount_in_cents
    end
    
    Payment.where("person_paid_id = ? AND person_paying_id = ?", self.id, to_user.id).all.each do |p|
      payments = payments + p.amount_in_cents
    end
    
    total_debt_in_cents = (debt_loaned) - (payments + debt_received)
    
    return Money.new(total_debt_in_cents)
  end

  protected
    


end
