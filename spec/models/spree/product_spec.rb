require 'spec_helper'

describe Spree::Product do
  before(:each) do
    @product = FactoryGirl.create(:product, :name => "Foo Bar")
    @master_variant = Spree::Variant.find_by_product_id(@product.id, :conditions => ["is_master = ?", true])
  end
    
  describe "Spree::Product.active" do
    before(:each) do
      Spree::Product.delete_all
      @not_available = create(:product, :available_on => Time.now + 15.minutes)
      @future_product = create(:product, :available_on => Time.now + 2.weeks)
    end

    it "includes available, individually saled, non deleted product with a price in the correct currency" do
      product = create(:product, :available_on => Time.now - 15.minutes)
      create(:price, variant: product.master)
      Spree::Product.active('USD').should include(product)
    end

    it "excludes future products" do
      product = create(:product, :available_on => Time.now + 15.minutes)
      Spree::Product.active.should_not include(product)
    end

    it "excludes deleted products" do
      product = create(:product, :deleted_at => Time.now - 15.minutes)
      Spree::Product.active.should_not include(product)
    end

    it "excludes products which are only available as a part" do
      product = create(:product, :individual_sale => false)
      Spree::Product.active.should_not include(product)
    end

    it "excludes products which do not have a price in the correct currency" do
      product = create(:product, :individual_sale => false)
      create(:price, variant: product.master)
      Spree::Product.active('GBP').should_not include(product)
    end
  end

end
