Spree::Product.class_eval do

  has_many :assemblies_parts, :class_name => "Spree::AssembliesPart",
    :foreign_key => "assembly_id"

  scope :individual_saled, where(["spree_products.individual_sale = ?", true])

  scope :active, lambda { |*args|
    not_deleted.individual_saled.available(nil, args.first)
  }

  attr_accessible :can_be_part, :individual_sale

  # exlusive or implementation of spree's variants_including_master scope:
  # if product has non-master variants, return those.  Otherwise, return master as only available variant.
  # note this does not return deleted variants (same as regular variants method)  
  def variants_or_master
    return variants if variants.any?
    [master]
  end
  
  # unlike the original gem whereas assemblies are simpler bundles, here assemblies can have variants, so assembly? truly belongs to a variant instead
  # however, we can say a product is an assembly if at least one of its variants is an assembly
  def assembly?
    !variants_or_master.detect(&:assembly?).nil?
  end
    
end
