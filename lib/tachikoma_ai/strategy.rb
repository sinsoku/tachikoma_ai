module TachikomaAi
  module Strategy
    def self.included(base)
      TachikomaAi.strategies << base
    end

    def pull_request_body
      raise NotImplementedError
    end
  end
end
