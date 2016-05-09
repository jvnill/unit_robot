class UnitRobot
  attr_reader :commands, :x, :y, :direction

  DIRECTIONS = %w[NORTH EAST SOUTH WEST]
  PLACE_REGEX = /PLACE (?<x>[0-4]),(?<y>[0-4]),(?<direction>(#{DIRECTIONS.join('|')}))/

  MOVE_DIRECTION_MAPPING = {
    'NORTH' => [0, 1],
    'EAST'  => [1, 0],
    'WEST'  => [-1, 0],
    'SOUTH' => [0, -1]
  }

  def initialize(path)
    raise ArgumentError if !path.is_a?(String) || !File.exists?(path)

    @commands = File.read(path).split("\n")
  end

  def start
    commands.each do |command|
      if match = command.match(PLACE_REGEX)
        place(match)
      elsif x && command == 'MOVE'
        move
      end
    end
  end

  private

  def place(match)
    @x = match['x'].to_i
    @y = match['y'].to_i
    @direction = match['direction']
  end

  def move
    x_movement, y_movement = MOVE_DIRECTION_MAPPING[direction]

    @x = x + x_movement
    @y = y + y_movement
  end
end
