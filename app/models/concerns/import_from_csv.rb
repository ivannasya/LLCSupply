require 'csv'
module ImportFromCsv
  extend ActiveSupport::Concern

  included do
    def create_points(row)
      create_association('origin', point_params("origin", row))
      create_association('destination', point_params("destination", row))
    end

    def create_association(kind, params)
      association = Point.find_by_attrs(*params.values).first
      if association.nil?
        self.send("create_#{kind}", params)
      else
        self.send("#{kind}_id=", association.id)
      end
    end

    def point_params(kind, row)
      { zip:        row["#{kind}_zip"],
        name:       row["#{kind}_name"] || row['client name'],
        raw_line_1: row["#{kind}_raw_line_1"],
        city:       row["#{kind}_city"],
        state:      row["#{kind}_state"],
        country:    row["#{kind}_country"]
      }
    end
  end

  module ClassMethods
    def import_from_csv(file)
      if file
        CSV.foreach(file.path, headers: true) do |row|
        	row   = row.to_hash
      	  order = Order.new(csv_order_params(row))
      	  order.create_points(row)
      	  order.save
        end
      end
    end

    private

    def csv_order_params(row)
      { delivery_date:          (Date.strptime(row['delivery_date'], '%m/%d/%Y') if row['delivery_date']),
        shift:                  row['delivery_shift'],
        phone_number:           row['phone_number'],
        mode:                   row['mode'],
        order_number:           row['purchase_order_number'],
        volume:                 row['volume'],
        handling_unit_quantity: row['handling_unit_quantity'],
        handling_unit_type:     row['handling_unit_type']
      }
    end
  end
end
