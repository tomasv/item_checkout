require 'spec_helper'
require 'item_checkout'

describe ItemCheckout::Checkout do
  let(:pricing_rules) { [] }
  let(:checkout) { ItemCheckout::Checkout.new(pricing_rules) }
  let(:apple) { ItemCheckout::Item.new('A1', 'Apple', 5.0) }
  let(:pear) { ItemCheckout::Item.new('P1', 'Pear', 4.0) }
  let(:grape) { ItemCheckout::Item.new('G1', 'Grape', 3.0) }

  it 'is at 0 sum at first' do
    checkout.total.should == 0.0
  end

  it 'sums up one item' do
    checkout.scan(apple)
    checkout.total.should == 5.0
  end

  it 'sums up several items' do
    checkout.scan(apple)
    checkout.scan(pear)
    checkout.scan(grape)
    checkout.total.should == 12.0
  end

  context 'with buy one get one free rule' do
    let(:checkout) { ItemCheckout::Checkout.new([ItemCheckout::BuyOneGetOne.new(apple)]) }

    it 'gives one apple free for 1 bought' do
      checkout.scan(apple)
      checkout.scan(apple)
      checkout.total.should == 5.0
    end

    it 'counts only 5 apples when checking out 10' do
      10.times { checkout.scan(apple) }
      checkout.total.should == 25.0
    end
  end

  context 'with bulk discount' do
    let(:checkout) { ItemCheckout::Checkout.new([ItemCheckout::BulkDiscount.new(apple, 3, 4.0)]) }

    it 'does not discount if discount quantity is not reached' do
      checkout.scan(apple)
      checkout.scan(apple)
      checkout.total.should == 10.0
    end

    it 'gives a discount for bulk purchases of offer items' do
      3.times { checkout.scan(apple) }
      checkout.total.should == 12.0
    end
  end

  describe 'reference requirements' do
    let(:green_tea) { ItemCheckout::Item.new('GR1', 'Green tea', 3.11) }
    let(:strawberries) { ItemCheckout::Item.new('SR1', 'Strawberries', 5.00) }
    let(:coffee) { ItemCheckout::Item.new('CF1', 'Coffee', 11.23) }

    let(:pricing_rules) {
      [
        ItemCheckout::BuyOneGetOne.new(green_tea),
        ItemCheckout::BulkDiscount.new(strawberries, 3, 4.50)
      ]
    }

    specify 'test case 1' do
      checkout.scan(green_tea)
      checkout.scan(strawberries)
      checkout.scan(green_tea)
      checkout.scan(green_tea)
      checkout.scan(coffee)
      checkout.total.should == 22.45
    end

    specify 'test case 2' do
      checkout.scan(green_tea)
      checkout.scan(green_tea)
      checkout.total.should == 3.11
    end

    specify 'test case 3' do
      checkout.scan(strawberries)
      checkout.scan(strawberries)
      checkout.scan(green_tea)
      checkout.scan(strawberries)
      checkout.total.should == 16.61
    end
  end
end
