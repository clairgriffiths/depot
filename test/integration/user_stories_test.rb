require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  
  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)
    
    #A user goes to the store index page
    get "/"
    assert_response :success
    assert_template "index"
    
    # They select a product and add it to their cart
    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success
    
    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product
    
    # They check out
    get "/orders/new"
    assert_response :success
    assert_template "new"
    
    post_via_redirect "/orders",
                      order: {name: "Clair Griffiths",
                              address: "123 The Street",
                              email: "clair@example.com",
                              pay_type: "Cheque"}
    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size
    
    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]
    
    assert_equal "Clair Griffiths", order.name
    assert_equal "123 The Street", order.address
    assert_equal "clair@example.com", order.email
    assert_equal "Cheque", order.pay_type
    
    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product
    
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["clair@example.com"], mail.to
    assert_equal "Clair Griffiths <clair@example.com>", mail[:from].value
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
    
  end
  
end
