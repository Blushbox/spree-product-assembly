require 'spec_helper'

module Spree
  module Stock
    describe Coordinator do
      let(:order) { create(:order_with_line_items) }
      let(:parts) { (1..3).map { create(:variant) } }

      let(:bundle_variant) { order.variants.first }
      let(:bundle) { bundle_variant.product }

      context "a product is ordered both as individual and within a bundle" do
        let(:common_product) { order.variants.last }

        subject { Coordinator.new(order) }

        before do
          expect(bundle_variant).to_not eql common_product

          bundle.parts << [parts, common_product]
          StockItem.update_all 'count_on_hand = 10'
        end

        context "bundle part requires more units than individual product" do
          before { order.contents.add(bundle_variant, 5) }

          let(:bundle_item_quantity) { order.line_items.where(variant_id: bundle_variant.id).first.quantity }

          it "calculates items quantity properly" do
            expected_units_on_package = order.line_items.sum(&:quantity) - bundle_item_quantity + (bundle.parts.count * bundle_item_quantity)

            expect(subject.packages.sum(&:quantity)).to eql expected_units_on_package
          end
        end
      end
    end
  end
end