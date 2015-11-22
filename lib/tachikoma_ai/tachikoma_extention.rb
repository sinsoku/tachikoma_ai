module TachikomaAi
  module TachikomaExtention
    def run(strategy)
      begin
        @strategy = TachikomaAi::Strategies.const_get(strategy.capitalize).new
      rescue NameError
        fail LoadError, "Could not find matching strategy for #{strategy}."
      end
      super
    end

    def pull_request
      @pull_request_body = @pull_request_body.to_s
      if @strategy
        Dir.chdir("#{Tachikoma.repos_path}/#{@build_for}") do
          @pull_request_body += "\n\n" + @strategy.pull_request_body
        end
      end
      super
    end
  end
end
