require 'facter'
require_relative '../../../lib/facter/network_config'

describe 'network_config fact' do
  it 'returns network configurations' do
    expect(Facter.fact(:network_config)).not_to be_nil
  end
end
