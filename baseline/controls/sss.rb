control 'sss' do
  title "SSSD is configured and running"

  # `sssctl` requires root access
  only_if { command('id').stdout.match(/root/) }

  describe service('sssd') do
    it { should be_running }
    it { should be_enabled }
  end

  describe command('/sbin/sssctl config-check') do
    its(:exit_status) { should eq 0 }
  end

  describe command('/sbin/sssctl domain-status -o LSST.CLOUD') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/Online status: Online/) }
    its(:stderr) { should be_empty }
  end

  describe command('/sbin/sssctl domain-status -a LSST.CLOUD') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/ipa\d.#{sys_info.domain}/) }
    its(:stderr) { should be_empty }
  end
end
