require 'spec_helper'

module Spree
  describe Variant do
    
    context "filter assemblies" do
      let(:mug) { create(:product) }
      let(:tshirt) { create(:product) }
      let(:variant) { create(:variant) }

      # this method implementation was unused & removed but may come back
      
      # context "variant has more than one assembly" do
      #   before { variant.assemblies.push [mug.master, tshirt.master] }
      #     
      #   it "returns both products" do
      #     variant.assemblies_for([mug.master, tshirt.master]).should == [mug.master, tshirt.master]
      #   end
      # end
      #     
      # context "variant no assembly" do
      #   it "returns both products" do
      #     variant.assemblies_for([mug.master, tshirt.master]).should be_empty
      #   end
      # end
    end
  
    context "assembly" do
      before(:each) do
        @assembly = (@product = create(:product)).master
        @part1 = create(:product, :can_be_part => true)
        @part2 = create(:product, :can_be_part => true)
        @assembly.add_part @part1.master, 1
        @assembly.add_part @part2.master, 4
      end

      it "is an assembly" do
        @assembly.should be_assembly
      end
      
      it "the product is also an assembly" do
        @product.should be_assembly
      end

      it 'changing part qty changes count on_hand' do
        @assembly.set_part_count(@part2, 2)
        @assembly.count_of(@part2).should == 2
      end
    end
        
  end
    
end
