require 'oauth2'

module LinkedIn

  class << self
    attr_accessor :client_id, :client_secret, :default_profile_fields

    # config/initializers/linkedin.rb (for instance)
    #
    # LinkedIn.configure do |config|
    #   config.client_id = 'client_id'
    #   config.client_secret = 'client_secret'
    #   config.default_profile_fields = ['education', 'positions']
    # end
    #
    # elsewhere
    #
    # client = LinkedIn::Client.new
    def configure
      yield self
      true
    end
  end

  autoload :Api,     "linked_in/api"
  autoload :Client,  "linked_in/client"
  autoload :Mash,    "linked_in/mash"
  autoload :Errors,  "linked_in/errors"
  autoload :Helpers, "linked_in/helpers"
  autoload :Search,  "linked_in/search"
  autoload :Version, "linked_in/version"
end
