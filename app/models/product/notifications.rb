module Product::Notifications
  extend ActiveSupport::Concern

  # The Product model now has a decent amount of code for handling notifications.
  # To better organize our code, we can extract this to an ActiveSupport::Concern.
  # A Concern is a Ruby module with some syntactic sugar to make using them easier.

  included do
    has_many :subscribers, dependent: :destroy
    # after_update_commit is an Active Record callback that is fired after changes are saved to the database.
    after_update_commit :notify_subscribers, if: :back_in_stock?
  end

  def back_in_stock?
    inventory_count_previously_was == 0 && inventory_count > 0
  end

  def notify_subscribers
    subscribers.each do |subscriber|
      ProductMailer.with(product: self, subscriber: subscriber).in_stock.deliver_later
    end
  end
end
