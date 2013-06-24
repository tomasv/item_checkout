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
