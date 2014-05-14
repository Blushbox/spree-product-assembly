module Spree
  module Stock
    Packer.class_eval do
      # Overriden from Spree core to build a custom package instead of the
      # default_package built in Spree
      def packages
        # original logic except we call product_assembly_package
        if splitters.empty?
          [product_assembly_package]
        else
          build_splitter.split [product_assembly_package]
        end        

        # this forces no splitting at all:
        #[product_assembly_package]
      end

      # Returns a package with all products from current stock location
      #
      # Follows the same logic as `Packer#default_package` except that it
      # loops through associated assembly parts (which is really just a
      # product / variant) to include them on the package if available.
      #
      # The product bundle itself is not included on the shipment because it
      # doesn't actually should have stock items, it's not a real product.
      # We track its parts stock items instead.
      def product_assembly_package
        package = Package.new(stock_location, order)
        order.line_items.each do |line_item|

          variant = line_item.variant
          if variant.assembly?
               
            # original logic applied to each assembly part         
            
            variant.parts.each do |part|
              if line_item.should_track_inventory?
                next unless stock_location.stock_item(part)

                # do not split on backorder items, pretend they are always on hand
                # on_hand, backordered = stock_location.fill_status(part, line_item.quantity * variant.count_of(part))
                # package.add part, on_hand, :on_hand, line_item if on_hand > 0
                # package.add part, backordered, :backordered, line_item if backordered > 0
                package.add part, line_item.quantity, :on_hand, line_item                
              else
                package.add part, line_item.quantity, :on_hand, line_item
              end
            end

          else

            # original logic

            if line_item.should_track_inventory?
              next unless stock_location.stock_item(variant)

              # do not split on backorder items, pretend they are always on hand
              # on_hand, backordered = stock_location.fill_status(variant, line_item.quantity)
              # package.add variant, on_hand, :on_hand, line_item if on_hand > 0
              # package.add variant, backordered, :backordered, line_item if backordered > 0
              package.add variant, line_item.quantity, :on_hand, line_item              
            else
              package.add variant, line_item.quantity, :on_hand, line_item
            end

          end
        end
        package
      end

    end
  end
end
