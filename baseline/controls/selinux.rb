control 'selinux' do
  title "SELinux is disabled"

  describe command('/usr/sbin/sestatus') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/disabled/) }
    its(:stderr) { should be_empty }
  end
end
