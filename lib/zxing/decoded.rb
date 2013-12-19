module ZXing

  class Decoded
    attr_reader :text, :points, :result_metadata

    def self.create_from(decoder_results)
      decoder_results.collect do |decoder_result|
        new decoder_result
      end
    end

    def initialize(decoder_result)
      @text = decoder_result.get_text
      @result_metadata = decoder_result.get_result_metadata
      @points = DecodedPoint.create_from decoder_result.get_result_points
    end

    def point_coordinates
      points.each.collect do |point|
        [point.x, point.y]
      end
    end

    def to_s
      text
    end

  end

  class DecodedPoint

    attr_reader :string, :x, :y, :hash_code

    def self.create_from(decoder_result_points)
      decoder_result_points.collect do |decoder_result_point|
        new decoder_result_point
      end
    end

    def initialize(decoder_result_point)
      @string = decoder_result_point.to_string
      @x = decoder_result_point.x
      @y = decoder_result_point.y
    end

  end

end
