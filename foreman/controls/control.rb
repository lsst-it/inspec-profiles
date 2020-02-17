control 'foreman_services' do
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

  describe service('dhcpd') do
    it { should be_running }
    it { should be_enabled }
  end

  describe service('named') do
    it { should_not be_running }
    it { should_not be_enabled }
  end
end

control 'foreman_virsh' do
  only_if { command('id').stdout.match(/root/) }

  (1..2).each do |offset|
    hostname = "core#{offset}"
    url = "qemu+ssh://foreman@#{hostname}.#{sys_info.domain}/system"
    describe command("sudo -u foreman virsh --connect #{url} list --all") do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match(/ipa#{offset}.#{sys_info.domain}/) }
      its(:stdout) { should match(/dns#{offset}.#{sys_info.domain}/) }
      its(:stderr) { should be_empty }
    end
  end
end

control 'foreman_r10k' do
  only_if { command('id').stdout.match(/root/) }

  describe file('/usr/bin/r10k') do
    it { should be_symlink }
    its(:link_path) { should eq '/opt/puppetlabs/puppet/bin/r10k' }
  end

  describe file('/root/.ssh/id_rsa.pub') do
    its(:content) { should match(/foreman.#{sys_info.domain}/) }
  end

  # TODO: test for smee configuration
end
