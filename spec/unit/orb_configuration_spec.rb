# http://betterspecs.org/

# For examples of mocks, see https://github.com/rspec/rspec-mocks

module OrbConfiguration
  describe OrbConfiguration do

    # TODO: Global set up goes here
    before(:all) do
      LOG.info("called in: #{self.class.name}, #{File.basename(__FILE__)}")
    end

    # TODO: Local set up goes here
    before(:each) do
      # this is called before each test
    end

    # use let to declare your variables
    let(:dude_wheres_my_var?) { nil }

    context 'example single expectation test' do
      it { expect(true).to eq(true) }
    end

    context 'example failing test' do
      # State explicitly what is being tested
      it 'TC0 boolean comparison' do
        expect(true).to eq(false)
      end

      it 'blargh' do
        [].should be_empty
      end
    end

    context 'rspec pending examples' do
      # BUG: ID-123 and ref
      it 'pending TC1 will keep running' do
        pending('Defect ID-123 P1 Functional Area X') do
          expect(true).to eq(false)
        end
      end

      # BUG: ID-123 and ref
      it 'pending TC2 will keep running and throw an exception once it is passing' do
        pending('Defect ID-123 P1:Functional Area X') do
          expect(true).to eq(true)
        end
      end

      # TODO: Complete this test case
      it 'TC3 rspec can also use pending for tests that still need to be written' do
        pending 'these tests require to be run'
      end

      # TODO: complete this test case
      it 'TC4 this test case still needs to be completed' do
        # example It statement, with no do and no pending statements
      end
    end
  end
end
