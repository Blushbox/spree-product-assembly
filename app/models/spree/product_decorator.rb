Spree::Product.class_eval do

  scope :individual_saled, where(["spree_products.individual_sale = ?", true])

  scope :active, lambda { |*args|
    not_deleted.individual_saled.available(nil, args.first)
  }

  attr_accessible :can_be_part, :individual_sale

  def all_assemblies_parts
    variants.collect(&:parts).flatten
  end
  
  def assembly?
    all_assemblies_parts.present?
  end
    
end
