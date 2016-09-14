# Rails.application.config.reform.validations = :dry


# require "trailblazer/operation/dispatch"

# Trailblazer::Operation.class_eval do
#   include Trailblazer::Operation::Dispatch
# end

# require "roar/decorator"
# require "roar/json/hal"

# ::Roar::Representer.module_eval do
#   include Rails.application.routes.url_helpers
#   # include Rails.app.routes.mounted_helpers

#   def default_url_options
#     {}
#   end
# end

# require "trailblazer/autoloading"

# Rails.application.config.reform.validations = :active_model





require "trailblazer/operation/dispatch"

Trailblazer::Operation.class_eval do
  include Trailblazer::Operation::Dispatch
end

require "roar/decorator"
require "roar/json/hal"

::Roar::Representer.module_eval do
  include Rails.application.routes.url_helpers
  # include Rails.app.routes.mounted_helpers

  def default_url_options
    {}
  end
end