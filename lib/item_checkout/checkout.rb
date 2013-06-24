module ItemCheckout
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
end
