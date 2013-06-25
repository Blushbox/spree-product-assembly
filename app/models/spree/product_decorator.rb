Spree::Product.class_eval do

  scope :individual_saled, where(["spree_products.individual_sale = ?", true])

  scope :active, lambda { |*args|
    not_deleted.individual_saled.available(nil, args.first)
  }

  attr_accessible :can_be_part, :individual_sale

  # unlike the original gem whereas assemblies are simpler bundles, here assemblies can have variants, so assembly? truly belongs to a variant instead
  # however, we can say a product is an assembly if at least one of its variants is an assembly
  def assembly?
    variants.detect(&:assembly?).present?
  end
    
end
