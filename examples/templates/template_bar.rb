define_template "template_bar" do
  template "te*"

  settings do
    index do
      number_of_shards "1"
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

    set! "{index}-alias" do
    end
  end
end
