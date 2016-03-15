class Cart < ActiveRecord::Base
	
	has_many :line_items, dependent: :destroy
	
  def add_product(product_id)
    current_item = line_items.find_by(product_id: product_id)
    # If the current item is already in the cart, increase the quantity
    if current_item
      current_item.quantity += 1
    else
      # Create a line item
      current_item = line_items.build(product_id: product_id)
    end
    current_item
  end
  
  def total_price
    line_items.to_a.sum{|item| item.total_price}
  end
  
end
