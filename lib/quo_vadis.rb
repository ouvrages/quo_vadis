require 'quo_vadis/engine'

module QuoVadis

  #
  # Redirection URLs
  #

  # The URL to redirect the user to after s/he signs in.
  mattr_accessor :signed_in_url
  @@signed_in_url = :root

  def self.signed_in_url(user)
    @@signed_in_url.respond_to?(:call) ?  @@signed_in_url.call(user) : @@signed_in_url
  end

  # The URL to redirect the user to after s/he signs out.
  mattr_accessor :signed_out_url
  @@signed_in_url = :root


  #
  # Hooks
  #

  # Code to run when the user has signed in.
  mattr_accessor :signed_in_hook
  @@signed_in_hook = nil

  def self.signed_in_hook(user, request)
    @@signed_in_hook.call(user, request) if @@signed_in_hook
  end

  # Code to run when someone has tried but failed to sign in.
  mattr_accessor :failed_sign_hook
  @@failed_sign_in_hook = nil

  def self.failed_sign_in_hook(request)
    @@failed_sign_in_hook.call(request) if @@failed_sign_in_hook
  end

  # Code to run just before the user has signed out.
  mattr_accessor :signed_out_hook
  @@signed_out_hook = nil

  def self.signed_out_hook(user, request)
    @@signed_out_hook.call(user, request) if @@signed_out_hook
  end


  # Configure from the initializer.
  def self.configure
    yield self
  end

end
