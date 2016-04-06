define_template "test-template" do
  order 0
  settings do
    number_of_shards 1
  end
  mappings do
    properties do
      set! "@timestamp" do
        type "date"
      end
      host_name do
        type "string"
        index "not_analyzed"
      end
    end
  end
  aliases do

  end
  template "runner-create-*"
end
