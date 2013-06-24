require 'spec_helper'
require 'item_checkout'

describe Checkout do
  let(:pricing_rules) { [] }
  let(:checkout) { Checkout.new(pricing_rules) }
  let(:apple) { Item.new('A1', 'Apple', 5.0) }
  let(:pear) { Item.new('P1', 'Pear', 4.0) }
  let(:grape) { Item.new('G1', 'Grape', 3.0) }

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
    let(:checkout) { Checkout.new([BuyOneGetOne.new(apple)]) }

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
    let(:checkout) { Checkout.new([BulkDiscount.new(apple, 3, 4.0)]) }

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
    let(:green_tea) { Item.new('GR1', 'Green tea', 3.11) }
    let(:strawberries) { Item.new('SR1', 'Strawberries', 5.00) }
    let(:coffee) { Item.new('CF1', 'Coffee', 11.23) }

    let(:pricing_rules) {
      [
        BuyOneGetOne.new(green_tea),
        BulkDiscount.new(strawberries, 3, 4.50)
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
