class UnitRobot
  attr_reader :commands, :x, :y, :direction

  DIRECTIONS = %w[NORTH EAST SOUTH WEST]
  PLACE_REGEX = /PLACE (?<x>[0-4]),(?<y>[0-4]),(?<direction>(#{DIRECTIONS.join('|')}))/

  def initialize(path)
    raise ArgumentError if !path.is_a?(String) || !File.exists?(path)

    @commands = File.read(path).split("\n")
  end

  def start
    commands.each do |command|
      place(match) if match = command.match(PLACE_REGEX)
    end
  end

  private

  def place(match)
    self.x = match['x']
    self.y = match['y']
    self.direction = match['direction']
  end
end
