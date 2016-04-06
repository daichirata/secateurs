jmx_props = ->(field) do
  set! field do
    properties do
      OneMinuteRate do
        type "float"
        doc_values "true"
      end

      Count do
        type "float"
        doc_values "true"
      end

      FifteenMinuteRate do
        type "float"
        doc_values "true"
      end

      FiveMinuteRate do
        type "float"
        doc_values "true"
      end

      MeanRate do
        type "float"
        doc_values "true"
      end
    end
  end
end

define_template "kafkabeat" do
  template "kafkabeat-*"

  settings do
    index do
      refresh_interval "5s"
    end
  end

  mappings do
    _default_ do
      dynamic_templates do
        child! do
          template1 do
            match "*"

            mapping do
              ignore_above 1024
              index "not_analyzed"
              type "{dynamic_type}"
              doc_values true
            end
          end
        end
      end

      _all do
        norms do
          enabled false
        end

        enabled true
      end

      properties do
        set! "@timestamp" do
          type "date"
        end

        jmx do
          properties do
            partial! jmx_props, "MessagesInPerSec"
            partial! jmx_props, "BytesOutPerSec"
            partial! jmx_props, "BytesInPerSec"
            partial! jmx_props, "FailedProduceRequestsPerSec"
            partial! jmx_props, "FailedFetchRequestsPerSec"
            partial! jmx_props, "BytesRejectedPerSec"
          end
        end
      end
    end
  end
end
