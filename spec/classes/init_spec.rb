require 'spec_helper'
describe 'oraclexe' do

  context 'with defaults for all parameters' do
    it { should contain_class('oraclexe') }
  end
end
