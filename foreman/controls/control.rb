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

control 'foreman_virsh' do
  only_if { command('id').stdout.match(/root/) }

  (1..2).each do |offset|
    hostname = "core#{offset}"
    url = "qemu+ssh://foreman@#{hostname}.#{sys_info.domain}/system"
    describe command("sudo -u foreman virsh --connect #{url} list --all") do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match(/ipa#{offset}.#{sys_info.domain}/) }
      its(:stdout) { should match(/dns#{offset}.#{sys_info.domain}/) }
    end
  end
end
