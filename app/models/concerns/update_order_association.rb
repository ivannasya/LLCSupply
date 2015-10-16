require 'csv'    
module UpdateOrderAssociation
  extend ActiveSupport::Concern

  included do
    def update_association(kind, params)
      association = self.send("#{kind}")
      Point.find_by_attrs(*params.values)
      point = Point.find_by_attrs(*params.values).first
      if point.nil?
	    if association.send("#{kind}_orders").count == 1
	      association.update_attributes(params) 
	    else
	      self.send("create_#{kind}", params)
          self.save
	    end
      else
        self.origin_id = point.id
        self.save
        association.delete
      end
    end
  end
end
