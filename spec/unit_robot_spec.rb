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
  end
end
