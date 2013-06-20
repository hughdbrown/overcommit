require 'json'

module Overcommit::GitHook
  class JsonFormat < HookSpecificCheck
    include HookRegistry
    file_type :json

    def json_write(filename)
        begin
            File.open(filename, "r") do |fr|
                json_data = JSON.parse(fr.read())
                fr.close()
                File.open(filename, "w") do |fw|
                    fw.write(JSON.pretty_generate(json_data, {:indent => "    "}))
                    fw.close()
                end
            end
            return true, ""
        rescue Exception => err
            return false, err
        end
    end

    def run_check
      results, output = staged.each {|f| json_write(f)}
      return (results.count{|r| r == false} == 0 ? :good : :bad), output.join().split("\n")
    end
  end
end
