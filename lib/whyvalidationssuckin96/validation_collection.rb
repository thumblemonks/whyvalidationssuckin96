module WhyValidationsSuckIn96
  class ValidationCollection < Array

    def to_json#(options={})
      inject({}) do |acc,validation|
        acc[validation.attribute] = validation.options
        acc
      end.to_json
    end

  end
end
