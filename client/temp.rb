class Temp
        def initialize(location, temperature)
                @location = location
                @temperature = temperature
        end

        def to_json(*a)
                {
                        "location" => @location,
                        "temperature" => @temperature
                }.to_json(*a)
        end

        attr_reader :location
        attr_reader :temperature
end
