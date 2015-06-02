require 'spec_helper'
describe 'pw_puppet::master::ca' do

  context 'with defaults for all parameters' do
    it { should contain_class('pw_puppet::master::ca') }
  end
end
