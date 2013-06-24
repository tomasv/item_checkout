Item = Struct.new(:product_code, :name, :price)

class BuyOneGetOne
  def initialize(item)
    @offer_item = item
  end

  def apply(items)
    offer_items = items.select { |item| item == @offer_item }
    discountable_count = offer_items.size / 2
    @offer_item.price * discountable_count
  end
end

class BulkDiscount
  def initialize(item, quantity, new_price)
    @offer_item = item
    @quantity = quantity
    @new_price = new_price
  end

  def apply(items)
    offer_items = items.select { |item| item == @offer_item }

    if offer_items.size >= @quantity
      discount_per_item = @offer_item.price - @new_price
      offer_items.size * discount_per_item
    else
      0
    end
  end
end

class Checkout
  def initialize(pricing_rules)
    @pricing_rules = pricing_rules
    @items = []
  end

  def scan(item)
    @items << item
  end

  def total
    total_without_discounts = @items.inject(0) { |sum, item| sum + item.price }
    discounts = @pricing_rules.map { |rule| rule.apply(@items) }
    discount_sum = discounts.inject(0, &:+)
    total_without_discounts - discount_sum
  end
end
