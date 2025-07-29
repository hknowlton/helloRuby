require "test_helper"

class ProductTest < ActiveSupport::TestCase
  # First, we include the Action Mailer test helpers so we can monitor emails sent during the test.
  include ActionMailer::TestHelper

  test "sends email notifications when back in stock" do
    # The tshirt fixture is loaded using the products() fixture helper and returns the Active Record object for that record.
    product = products(:tshirt)

    # Set product out of stock
    product.update(inventory_count: 0)

    assert_emails 2 do
      product.update(inventory_count: 99)
    end
  end
end
