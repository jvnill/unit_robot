require 'unit_robot'

describe UnitRobot do
  context 'reading file input' do
    it 'should raise an error if file does not exist' do
      expect { UnitRobot.new('foo.txt') }.to raise_error
    end

    it 'should properly read the commands as content of the file' do
      unit_robot = UnitRobot.new('spec/support/input.txt')

      expect(unit_robot.commands).to eq(['PLACE 0,0,NORTH', 'LEFT', 'REPORT'])
    end
  end
end
