module Spree
  LineItem.class_eval do
    scope :assemblies, -> { joins(:variant => :parts).uniq }
  end
end
