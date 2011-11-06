module ApplicationHelper
  
  def intercom_settings(person)
    data = {
      "app_id" => 'icmeqg8c',
      "widget" => { "activator" => "#IntercomDefaultWidget" }
    }
    if person
      data["email"]       = person.email
      data["custom_data"] = intercom_custom_data(person)
      data["user_hash"]   = Digest::SHA1.hexdigest('qf6kliuq' + person.email)
      data["created_at"]  = person.created_at.to_time.to_i
    end
    data.to_json
  end
  
  def intercom_custom_data(person)
    data = {}
    if person
      data["Expenses Count"]          = person.expenses.count
      data["Payments Made Count"]     = person.payments_made.count
      data["Payments Received Count"] = person.payments_received.count
    end
    data
  end
  
end
