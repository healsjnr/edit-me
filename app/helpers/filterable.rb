# Call scopes directly from your URL params:
#
#     @products = Product.filter(params.slice(:status, :location, :starts_with))
module Filterable
  extend ActiveSupport::Concern

  module ClassMethods

    # Call the class methods with the same name as the keys in <tt>filtering_params</tt>
    # with their associated values. Most useful for calling named scopes from
    # URL params. Make sure you don't pass stuff directly from the web without
    # whitelisting only the params you care about first!
    def filter(filtering_params)
      # Create an anonymous scope and then reduce it base on key / value
      filtering_params.inject(self.where(nil)) do |results, (key, value)|
        results.public_send(key, value) if value.present?
      end
    end
  end
end