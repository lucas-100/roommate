class PersonSession < Authlogic::Session::Base
  find_by_login_method :find_by_email
  logout_on_timeout    true
  disable_magic_states true
end
