require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  test "product attributes must not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  def new_product(price, image_url)
    Product.new(title: "My Book", description: "some description", image_url: image_url, price: price)
  end

  test "price" do
    ok = [10.00, 1.55, 279.99, 0.01]
    bad = [0.001, 0, -1, -345.99]
    
    ok.each do |price|
      assert new_product(price, "zzz.jpg").valid?, "#{price} should be valid"
    end
    
    bad.each do |price|
      assert new_product(price, "zzz.jpg").invalid?, "#{price} shouldn't be valid"
    end 
  end

  test "image_url" do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }
    
    ok.each do |image_url|
      assert new_product(10.00, image_url).valid?, "#{image_url} should be valid"
    end
    
    bad.each do |image_url|
      assert new_product(10.00, image_url).invalid?, "#{image_url} shouldn't be valid"
    end 
  end  

  test "product is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "yyy",
                          price: 1.00,
                          image_url: "fred.gif")
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')],
                  product.errors[:title]
  end


  # test "the product price must be positive" do
  #   product = Product.new(title: "My Book", description: "some description", image_url: "zzz.jpg")
  #   product.price = 1
  #   assert product.valid?
  # end

  # test "the product price can't be negative" do
  #   product = Product.new(title: "My Book", description: "some description", image_url: "zzz.jpg")
  #   product.price = -1
  #   assert product.invalid?
  #   assert_equal ["must be greater than or equal to 0.01"], 
  #     product.errors[:price]
  # end

  # test "the product price can't be zero" do
  #   product = Product.new(title: "My Book", description: "some description", image_url: "zzz.jpg")
  #   product.price = 0
  #   assert product.invalid?
  #   assert_equal ["must be greater than or equal to 0.01"], 
  #     product.errors[:price]  
  # end
end
