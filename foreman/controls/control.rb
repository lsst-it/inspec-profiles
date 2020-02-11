control 'foreman_proxy' do
  describe service('foreman-proxy') do
    it { should be_running }
    it { should be_enabled }
  end

  describe service('httpd') do
    it { should be_running }
    it { should be_enabled }
  end

  describe service('puppetserver') do
    it { should be_running }
    it { should be_enabled }
  end
end
