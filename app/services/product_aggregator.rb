class ProductAggregator
  def self.generate_aggregated_products(material_code:, product_category_code:, name:)
    new(material_code, product_category_code, name).aggregate_changes
  end

  def initialize(material_code, product_category_code, name)
    @material_code = material_code
    @product_category_code = product_category_code
    @name = name
  end

  def aggregate_changes
    retrieve_object_changes_since_timestamp
    aggregate_object_changes.to_json
  rescue ActiveRecord::StatementInvalid # Catch extremely large timestamp
    "{}"
  end

  private

  def aggregate_object_changes
    @object_changes.each_with_object({}) do |changes_json, aggregate|
      aggregate.deep_merge!(JSON.parse(changes_json))
    end
  end

  def retrieve_object_changes_since_timestamp
    @object_changes = ObjectStateLog
      .where(material_code: @material_code)
      .pluck(:object_changes)
  end
end
