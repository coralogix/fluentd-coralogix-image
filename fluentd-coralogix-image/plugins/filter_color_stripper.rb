require "fluent/plugin/filter"

module Fluent
  class ColorStripperFilter < Filter
    Fluent::Plugin.register_filter("color_stripper", self)

    config_param :strip_fields, :array, value_type: :string, default: []

    def configure(conf)
      super
    end

    def filter(tag, time, record)
      format_record(record)
    end

    private

    def format_record(record)
      record.each_with_object({}) do |(key, val), object|
        object[key] = if strip_field?(key)
          uncolorize(val)
        else
          val
        end
      end
    end

    #
    # Return uncolorized string
    #
    def uncolorize(string)
      string.gsub(/\\033\[\d{1,2}(\;\d{1,2}){0,2}[mGK]/, "")
    end

    def strip_field?(field)
      @strip_fields.empty? || @strip_fields.include?(field)
    end
  end
end
