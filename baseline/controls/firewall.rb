control 'firewall' do
  describe service('iptables') do
    it { should_not be_enabled }
    it { should_not be_running }
  end

  describe service('firewalld') do
    it { should_not be_enabled }
    it { should_not be_running }
  end
end
