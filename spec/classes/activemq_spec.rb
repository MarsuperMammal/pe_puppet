require 'spec_helper'
describe "pw_puppet::activemq" do

  context 'with defaults for all parameters' do
    it { should contain_class("pw_puppet::activemq") }
  end
end
