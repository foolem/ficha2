module Fog
  module Rackspace
    class Orchestration
      class Real
        def preview_stack(options = {})
          request(
            :body     => Fog::JSON.encode(options),
            :expects  => [200],
            :method   => 'POST',
            :path     => 'stacks/preview'
          )
        end
      end
    end
  end
end
