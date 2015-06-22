module Dorsale
  module BillingMachine
    class CommonTrackingId
      def self.get_invoice_tracking_id(date, unique_index)
        if date
          year_on_two_digits = year_on_two_digits(date)
          index = unique_index_with_at_least_two_digits(unique_index)
          return "#{year_on_two_digits}#{index}" # eg: 1442
        else # no date
          unique_index.to_s
        end
      end

      def self.get_quotation_tracking_id(date, unique_index)
        if date
          year_on_two_digits = year_on_two_digits(date)
          index = unique_index_with_at_least_two_digits(unique_index)
          return "#{year_on_two_digits}#{index}" # eg: 1442
        else # no date
          unique_index.to_s
        end
      end

      def self.unique_index_with_at_least_two_digits(unique_index)
          if unique_index < 10
            unique_index = "0" + unique_index.to_s
          else
            unique_index
          end
      end

      def self.year_on_two_digits(date)
          year = date.strftime("%Y")
          year_on_two_digits = Integer(year) % 100
          return year_on_two_digits
      end
    end
  end
end
