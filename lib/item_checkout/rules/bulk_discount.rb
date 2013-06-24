module ItemCheckout
  module Rules
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
  end
end
