require 'quo_vadis/engine'

module QuoVadis

  # Configuration

  mattr_accessor :signed_in_url
  @@signed_in_url = :root

  mattr_accessor :signed_out_url
  @@signed_in_url = :root

  # Configure from the initializer (generated by generator).
  def self.configure
    yield self
  end

end
