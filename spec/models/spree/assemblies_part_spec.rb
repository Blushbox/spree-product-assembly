require 'spec_helper'

module Spree
  describe AssembliesPart do
    let(:assembly_variant) { create(:variant) }
    let(:part_variant) { create(:variant) }

    before do
      assembly_variant.parts.push part_variant
    end

    context "get" do
      it "brings part by assembly variant id and part variant id" do
        subject.class.get(assembly_variant.id, part_variant.id).part.should == part_variant
      end
    end
  end
end
