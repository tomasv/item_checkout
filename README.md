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

checkout = ItemCheckout::Checkout.new(pricing__rules)
checkout.scan(item)
checkout.scan(item)
price = checkout.total # => 6.54

