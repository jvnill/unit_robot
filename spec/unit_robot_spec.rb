require 'unit_robot'

describe UnitRobot do
  context 'reading file input' do
    it 'should raise an error if file does not exist' do
      expect { UnitRobot.new('foo.txt') }.to raise_error(ArgumentError)
    end

    it 'should properly read the commands as content of the file' do
      unit_robot = UnitRobot.new('spec/support/input.txt')

      expect(unit_robot.commands).to eq(['PLACE 0,0,NORTH', 'LEFT', 'REPORT'])
    end
  end

  context 'the PLACE command' do
    it 'should not set the coordinates of the robot if it is invalid' do
      unit_robot = UnitRobot.new('spec/support/invalid_place.txt')

      unit_robot.start

      expect(unit_robot.commands).to eq(['PLACE 3,3'])
      expect(unit_robot.x).to be_nil
      expect(unit_robot.y).to be_nil
      expect(unit_robot.direction).to be_nil
    end

    it 'should ignore all commands before a proper PLACE command is issued' do
      unit_robot = UnitRobot.new('spec/support/no_place.txt')

      unit_robot.start

      expect(unit_robot.commands).to eq(['MOVE', 'LEFT', 'MOVE', 'RIGHT'])
      expect(unit_robot.x).to be_nil
      expect(unit_robot.y).to be_nil
      expect(unit_robot.direction).to be_nil
    end

    it 'should properly set the initial position of the robot' do
      unit_robot = UnitRobot.new('spec/support/valid_place.txt')

      unit_robot.start

      expect(unit_robot.commands).to eq(['MOVE', 'LEFT', 'PLACE 2,2,WEST'])
      expect(unit_robot.x).to eq(2)
      expect(unit_robot.y).to eq(2)
      expect(unit_robot.direction).to eq('WEST')
    end

    it 'should move the robot to the specified coordinate based on the last valid PLACE command' do
      unit_robot = UnitRobot.new('spec/support/multiple_place.txt')

      unit_robot.start

      expect(unit_robot.commands).to eq(['PLACE 0,0,NORTH', 'PLACE 1,1,EAST', 'MOVE', 'PLACE 4,4,NORTH', 'PLACE 5,5,EAST'])
      expect(unit_robot.x).to eq(4)
      expect(unit_robot.y).to eq(4)
      expect(unit_robot.direction).to eq('NORTH')
    end
  end

  context 'the MOVE command' do
    it 'should properly move the robot one unit down when facing SOUTH' do
      unit_robot = UnitRobot.new('spec/support/facing_south.txt')

      unit_robot.start

      expect(unit_robot.commands).to eq(['PLACE 2,2,SOUTH', 'MOVE'])
      expect(unit_robot.x).to eq(2)
      expect(unit_robot.y).to eq(1)
      expect(unit_robot.direction).to eq('SOUTH')
    end

    it 'should propertly move the robot one unit up when facing NORTH' do
      unit_robot = UnitRobot.new('spec/support/facing_north.txt')

      unit_robot.start

      expect(unit_robot.commands).to eq(['PLACE 2,2,NORTH', 'MOVE'])
      expect(unit_robot.x).to eq(2)
      expect(unit_robot.y).to eq(3)
      expect(unit_robot.direction).to eq('NORTH')
    end

    it 'should properly move the robot one unit to the left when facing WEST' do
      unit_robot = UnitRobot.new('spec/support/facing_west.txt')

      unit_robot.start

      expect(unit_robot.commands).to eq(['PLACE 2,2,WEST', 'MOVE'])
      expect(unit_robot.x).to eq(1)
      expect(unit_robot.y).to eq(2)
      expect(unit_robot.direction).to eq('WEST')
    end

    it 'should properly move the robot one unit to the right when facing EAST' do
      unit_robot = UnitRobot.new('spec/support/facing_east.txt')

      unit_robot.start

      expect(unit_robot.commands).to eq(['PLACE 2,2,EAST', 'MOVE'])
      expect(unit_robot.x).to eq(3)
      expect(unit_robot.y).to eq(2)
      expect(unit_robot.direction).to eq('EAST')
    end

    %w[0,4,NORTH 0,4,WEST 0,0,WEST 0,0,SOUTH 4,0,SOUTH 4,0,EAST 4,4,EAST 4,4,NORTH].each do |position|
      let(:robot) { UnitRobot.new('spec/support/input.txt') }

      it "should prevent robot from moving if at #{position} and asked to MOVE" do
        robot.instance_variable_set('@commands', ["PLACE #{position}", 'MOVE'])

        robot.start

        x, y, direction = position.split(',')

        expect(robot.x).to eq(x.to_i)
        expect(robot.y).to eq(y.to_i)
        expect(robot.direction).to eq(direction)
      end
    end
  end

  context 'the LEFT command' do
    let(:robot) { UnitRobot.new('spec/support/input.txt') }

    [%w[NORTH WEST], %w[WEST SOUTH], %w[SOUTH EAST], %w[EAST NORTH]].each do |before_direction, after_direction|
      it "should face the robot to #{after_direction} from #{before_direction}" do
        robot.instance_variable_set('@commands', ["PLACE 0,0,#{before_direction}", 'LEFT'])

        robot.start

        expect(robot.x).to eq(0)
        expect(robot.y).to eq(0)
        expect(robot.direction).to eq(after_direction)
      end
    end
  end
end
