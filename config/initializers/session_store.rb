# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_roommate_session',
  :secret => 'afc41c9e59df57f450ce5ad8289fa18d7984ab6284c866bbb2ee75dc9cb01fe297b9da995f5e952cee2fa998d78342bb0606ba488d5662c8d685b2a110f56229'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
