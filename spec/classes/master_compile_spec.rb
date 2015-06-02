require 'spec_helper'
describe 'pw_puppet::master::compile' do

  context 'with defaults for all parameters' do
    it { should contain_class('pw_puppet::master::compile') }
  end
end
