class UnitRobot
  attr_accessor :commands

  def initialize(path)
    raise ArgumentError if !path.is_a?(String) || !File.exists?(path)

    @commands = File.read(path).split("\n")
  end
end
