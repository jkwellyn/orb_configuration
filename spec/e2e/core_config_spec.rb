require 'English'

module OrbConfiguration
  describe Configuration do
    it 'should load correct config when required in a different gem' do
      Dir.chdir(File.join('spec', 'e2e', 'core')) do
        `ber spec:unit`
      end
      expect($CHILD_STATUS.success?)
    end
  end
end
