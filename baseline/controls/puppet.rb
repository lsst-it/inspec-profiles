control 'puppet_agent' do
  describe service('puppet') do
    it { should be_running }
    it { should be_enabled }
  end

  describe ini('/etc/puppetlabs/puppet/puppet.conf') do
    its('agent.server') { should eq "foreman.#{sys_info.domain}" }
  end
end
