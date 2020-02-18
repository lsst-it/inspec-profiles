control 'puppet_agent' do

  describe package('puppet-agent') do
    it { should be_installed }
  end

  describe package('puppet6-release') do
    it { should be_installed }
  end

  describe package('puppet5-release') do
    it { should_not be_installed }
  end

  describe service('puppet') do
    it { should be_running }
    it { should be_enabled }
  end

  describe ini('/etc/puppetlabs/puppet/puppet.conf') do
    its('agent.server') { should eq "foreman.#{sys_info.domain}" }
  end

  describe command('puppet config print --section agent noop') do
    its(:stdout) { should_not match(/true/) }
  end
end
