class Account < ActiveRecord::Base
  belongs_to :user
  belongs_to :marketplace

  has_many :sales_orders
  
  serialize :state

  def state
    @state ||= HashWithCallbacks.new(self[:state] || {}, :changed => -> (changed_values) {
      self.update_attribute(:state, @state.to_h)
    })
  end

  def integration
    @integration ||= Integrations.by_uid(marketplace.api_uid).new(state)
  end
end
