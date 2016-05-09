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
end
