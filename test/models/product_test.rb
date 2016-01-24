require 'test_helper'

class ProductTest < ActiveSupport::TestCase
	test "product attributes must not be empty" do
		# Create a product with no attributes
		product = Product.new
		# Check that there is at least one error message for each validation that fails
		assert product.invalid?
		assert product.errors[:title].any?
		assert product.errors[:description].any?
		assert product.errors[:image_url].any?
		assert product.errors[:price].any?
	end
	
	test "product price must be positive" do
		product = Product.new(title: "My Title", description: "My description", image_url: "test.jpg")
		
		# Test with a negative price
		product.price = -1
		assert product.invalid?
		assert_equal ["must be greater than or equal to 0.01"], 
			product.errors[:price]
		
		# Test with a price of 0		
		product.price = 0
		assert product.invalid?
		assert_equal ["must be greater than or equal to 0.01"], 
			product.errors[:price]
		
		# Test with a price of 1
		product.price = 1
		assert product.valid?
	end
	
end
