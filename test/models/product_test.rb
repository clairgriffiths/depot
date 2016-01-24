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
	
	def new_product(image_url)
		Product.new(title: "My Title", 
								description: "My description", 
								price: 1.23,
								image_url: image_url)
	end
	
	test "image url must be valid" do
		ok = %w{fred.gif fred.jpg fred.png FRED.gif FRED.Png http://a.c.b/x/y/z/fred.gif}
		bad = %w{fred.doc fred.gif/more fred.gif.more}
		
		ok.each do |name|
			assert new_product(name).valid?, "#{name} should be valid"
		end
		
		bad.each do |name|
			assert new_product(name).invalid?, "#{name} shouldn't be valid"
		end
	end
	
	test "product is not valid without a unique title" do
		product = Product.new(title: products(:ruby).title, description: "yyy", price: 2, image_url: "fred.gif")
		assert product.invalid?
		assert_equal ["has already been taken"], product.errors[:title]
	end
	
	def new_prod(title)
		Product.new(description: "My description", image_url: "ruby.jpg", price: 9.99, title: title)
	end
	
	test "title must be at least 3 characters" do
		assert new_prod("Hi").invalid?
		assert new_prod("Hello").valid?
	end
	
end
