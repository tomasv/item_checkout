# ItemCheckout

This is a simple item checkout gem.
Given a checkout, when some items are scanned, a total price sum is then returned.

## Installation

Add this line to your application's Gemfile:

    gem 'item_checkout'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install item_checkout

## Usage

    checkout = ItemCheckout::Checkout.new(pricing_rules)
    checkout.scan(item)
    checkout.scan(item)
    price = checkout.total # => 6.54

Where pricing\_rules is an array of rule objects.
A rule object must respond to discount\_for and return the total discount for the passed in
item array.
Example rule object:

    class HalfPrice
      def discount_for(items)
		items.map { |item| item.price / 2 }.inject(0, &:+)
      end
    end

Items should implement price and product\_code methods.

Discounts are applied upon invoking the total method on the checkout.
