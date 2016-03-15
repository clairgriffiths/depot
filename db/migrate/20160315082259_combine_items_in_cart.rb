class CombineItemsInCart < ActiveRecord::Migration
  def change
    # replace multiple items for a single product in a cart with a single item
    Cart.all.each do |cart|
     
      # Group is an active record query method, pretty much just group_by
      sums = cart.line_items.group(:product_id).sum(:quantity)
      # the above returns the following: {5=>3, 6=>3}
      
      sums.each do |product_id, quantity|
        if quantity > 1
          # delete it
          cart.line_items.where(product_id: product_id).delete_all
          # replace it with 1 line with the quantity as passed in from sums
          item = cart.line_items.build(product_id: product_id)
          item.quantity = quantity
          item.save!
        end
      end
    end
  end
  
  def down
    LineItem.where("quantity>1").each do |line_item|
      line_item.quantity.times do 
        LineItem.create cart_id: line_item.cart_id, product_id: line_item.product_id, quantity: 1
      end
      line_item.destroy
    end
  end
  
end
