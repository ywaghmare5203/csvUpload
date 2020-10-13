class PorductImporterForm < BaseForm
  require 'csv'

  attribute :file, File, default: nil, coerce: false
  attribute :object_state_logs_from_csv, Array[ProductDetail], default: []

  validates_presence_of :file

  def save
    return false unless valid?

    initialize_object_state_logs_from_csv
    validate_all_object_state_logs!
    save_all_object_state_logs!
    true
  rescue ActiveRecord::RecordInvalid => invalid
    add_to_base_errors(invalid)
  rescue CSV::MalformedCSVError => csv_error
    errors.add(:base, csv_error.message)
    false
  end

  private

  def save_all_object_state_logs!
    ProductDetail.transaction do
      object_state_logs_from_csv.each(&:save!)
    end
  end

  def validate_all_object_state_logs!
    error_messages = collect_error_messages
    if error_messages.any?
      errors.add(:base, error_messages.join("\n"))
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end

  def collect_error_messages
    object_state_logs_from_csv.map.with_index(1) do |object_state_log_from_csv, row_number|
      unless object_state_log_from_csv.valid?
        "Error on row #{row_number}: #{object_state_log_from_csv.errors.full_messages.to_sentence}"
      end
    end.compact
  end

  def initialize_object_state_logs_from_csv
    File.foreach(file.path) do |file_line|
      escaped_csv_line = escape_double_quotes_in_csv_line(file_line)
      material_code, product_category_code, name, status = CSV.parse_line(escaped_csv_line)

      object_state_logs_from_csv << ProductDetail.new(
        material_code: material_code,
        product_category_code: product_category_code,
        name: name,
        status: status
      )
    end
  end

  def escape_double_quotes_in_csv_line(csv_line)
    csv_line.gsub('\"','""')
  end
end
