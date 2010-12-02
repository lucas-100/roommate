require 'digest/sha1'

class Person < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  belongs_to :house
  has_many :debts
  has_many :loans, :class_name => "Debt", :foreign_key => :loaner_id
  has_many :payments_made, :class_name => "Payment", :foreign_key => :person_paying_id
  has_many :payments_received, :class_name => "Payment", :foreign_key => :person_paid_id
  has_and_belongs_to_many :expenses
  
  validates :name,  :format     => { :with => Authentication.name_regex, :message => Authentication.bad_name_message },
                    :length     => { :maximum => 100 },
                    :allow_nil  => true,
                    :presence   => true

  validates :email, :presence   => true,
                    :uniqueness => true,
                    :format     => { :with => Authentication.email_regex, :message => Authentication.bad_email_message },
                    :length     => { :within => 6..100 }

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessor :password, :password_confirmation
  attr_accessible :email, :name, :password, :password_confirmation

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  class << self
    def authenticate(email, password)
      return nil if email.blank? || password.blank?
      user = find_by_email(email.downcase) # need to get the salt
      user && user.authenticated?(password) ? user : nil
    end
  end
  
  def first_name
    name.split(" ")[0]
  end
  
  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def all_debts_owed
    house.people.map { |person| create_debt(person.name, total_debt_owed(person)) }.compact! || Array.new
  end
  
  def all_debts_loaned
    house.people.map { |person| create_debt(person.name, total_debt_loaned(person)) }.compact! || Array.new
  end

  def recent_expenses 
    debts.includes(:expense).limit(5).where("loaner_id != ?", self.id).order("created_at DESC").map{ |debt| debt.expense } || Array.new
  end
  
  def recent_loans
    loans.includes(:expense).order("created_at DESC").map { |loan| loan.expense }.uniq[0..4] || Array.new
  end
  
  def recent_payments_received
    payments_received.limit(5).order("created_at DESC").map{ |payment| create_payment_hash(payment, payment.person_paying) }
  end
  
  def recent_payments_made
    payments_made.limit(5).order("created_at DESC").map{ |payment| create_payment_hash(payment, payment.person_paid) }
  end
  
  def update_password(params)
    if password_is_valid(params) && password_is_confirmed(params)
      update_attribute(:crypted_password, encrypt(params[:password]))
    else
      errors.add(:password_confirmation, "must match password") if params[:password] != params[:password_confirmation]
      errors.add(:password, "cannot be blank") if params[:password].nil? || params[:password] == ''
      
      false
    end
  end
  
  protected
  # how much the current user owes to another user
  def total_debt_owed(to_user)
    Money.new((debt_received(to_user) + payments_made_from(to_user)) - (payments_made_to(to_user) + debt_loaned(to_user)))
  end
  
  # how much the current user has loaned out to, or is owed by, another user
  def total_debt_loaned(to_user)
    Money.new((debt_loaned(to_user) + payments_made_to(to_user)) - (payments_made_from(to_user) + debt_received(to_user)))
  end
  
  def debt_received(user)
    Debt.where("loaner_id = ? AND person_id = ?", user.id, self.id).all.inject(0) { |amount, debt| amount += debt.amount_in_cents }
  end
  
  def payments_made_from(user)
    Payment.where("person_paying_id = ? AND person_paid_id = ?", user.id, self.id).all.inject(0) { |amount, payment| amount += payment.amount_in_cents }
  end
  
  def payments_made_to(user)
    Payment.where("person_paid_id = ? AND person_paying_id = ?", user.id, self.id).all.inject(0) { |amount, payment|  amount += payment.amount_in_cents }
  end
  
  def debt_loaned(user)
    Debt.where("loaner_id = ? AND person_id = ?", self.id, user.id).all.inject(0) { |amount, debt| amount += debt.amount_in_cents }
  end
  
  def create_debt(person, amount)
    {:person => person, :amount => amount} if amount.cents > 0
  end
  
  def create_payment_hash(payment, user)
    {:name => user.name, :amount => payment.amount, :id => payment.id, :created_at => payment.created_at}
  end
  
  def password_is_valid(params)
    !params[:password].nil? && params[:password] != ""
  end
  
  def password_is_confirmed(params)
    params[:password] == params[:password_confirmation]
  end

end
