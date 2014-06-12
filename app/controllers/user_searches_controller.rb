class UserSearchesController < ApplicationController
  respond_to :json

  def create
    @email = params[:userSearch][:email]
    person = if @email.present?
               Person.find_by_email(@email)
             end

    @house  = person.house
    @person = current_person

    respond_with(@person, @house, @email, :location => "/user_searches/1", :status => "201 Created")
  end
end
