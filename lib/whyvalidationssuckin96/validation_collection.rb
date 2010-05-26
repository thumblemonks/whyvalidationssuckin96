module WhyValidationsSuckIn96
  class ValidationCollection < Array

    def to_json(options={})
      to_hash.to_json(options)
    end

    def to_hash
      inject({}) do |acc,validation|
        acc[validation.attribute] = validation.options
        acc
      end
    end

    def select(&block)
      self.class.new super
    end

  end
end
