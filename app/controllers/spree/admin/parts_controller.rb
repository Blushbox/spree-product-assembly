class Spree::Admin::PartsController < Spree::Admin::BaseController
  before_filter :find_product_and_assemblies
  before_filter :find_part_and_assembly, :only => [:remove, :set_count, :create]

  def index
  end

  def remove
    @assembly.remove_part(@part)
    render 'spree/admin/parts/update_parts_table'
  end

  def set_count
    @assembly.set_part_count(@part, params[:count].to_i)
    render 'spree/admin/parts/update_parts_table'
  end

  def create
    qty = params[:part_count].to_i
    @assembly.add_part(@part, qty) if qty > 0
    render 'spree/admin/parts/update_parts_table'
  end
  
  def available
    if params[:q].blank?
      @available_products = []
    else
      query = "%#{params[:q]}%"
      @available_products = Spree::Product.not_deleted.available.joins(:master).where("(spree_products.name #{LIKE} ? OR spree_variants.sku #{LIKE} ?) AND can_be_part = ?", query, query, true).limit(30)
      
      @available_products.uniq!
    end
    respond_to do |format|
      format.html {render :layout => false}
      format.js {render :layout => false}
    end
  end

  private
    def find_product_and_assemblies
      @product = Spree::Product.find_by_permalink(params[:product_id])
      @assemblies = @product.variants_or_master
    end
    
    def find_part_and_assembly
      @part = Spree::Variant.find(params[:id])
      @assembly = Spree::Variant.find(params[:assembly_id])
    end
    
end
