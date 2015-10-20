require 'csv'    
module UpdateOrderAssociation
  extend ActiveSupport::Concern

  included do
    def update_association(kind, params)
      association = self.send("#{kind}")
      self.create_association(kind, params)
      self.save
      association.delete if association.send("#{kind}_orders").count == 0
    end
  end
end
