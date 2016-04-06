define_template "template_1" do
  template "te*"

  settings do
    index do
      number_of_shards "1"
    end
  end

  mappings do
    type1 do
      _source do
        enabled false
      end

      properties do
        set! "@timestamp" do
          type "date"
        end

        created_at do
          format "EEE MMM dd HH:mm:ss Z YYYY"
          type "date"
        end

        host_name do
          index "not_analyzed"
          type "string"
        end
      end
    end
  end
end
