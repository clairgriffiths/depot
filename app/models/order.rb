class Order < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  PAYMENT_TYPES = ["Cheque", "Credit Card", "Purchase order"]
  
  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: PAYMENT_TYPES
  
  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      # Rails magic making sure it all saves in the right place
      line_items << item
    end
  end
  
end
