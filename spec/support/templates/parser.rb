prop_test = -> do
  props do
    type "prop_test"
  end
end

define_template "template-parser-ruby" do
  template "te*"

  order 1

  settings do
    number_of_shards "1"
  end

  mappings do
    _default_ do
      dynamic_templates do
        child! do
          template1 do
            match "*"
            mapping do
              index "not_analyzed"
            end
          end
        end
      end

      properties do
        set! "@timestamp" do
          type "date"
        end

        host_name do
          type "string"
          index "not_analyzed"
        end

        created_at do
          type "date"
          format "EEE MMM dd HH:mm:ss Z YYYY"
        end

        type1 do
          type2 do
            type "string"
          end
        end

        partial! prop_test
      end
    end

    type1 do
      _source do
        enabled false
      end
    end
  end

  aliases do
    alias2 do
      filter do
        term do
          user "kimchy"
        end
      end
      index_routing "kimchy"
      search_routing "kimchy"
    end
  end
end
