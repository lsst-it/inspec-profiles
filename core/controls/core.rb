control 'summit-core-network' do
  title "Summit core network"

  domain = 'cp.lsst.org'.freeze

  %w[core1 core2].map { |shortname| "#{shortname}.#{domain}" }.each do |fqdn|
    describe host(fqdn) do
      it { should be_resolvable }
      it { should be_reachable }
    end
  end
end

control 'bdc-core-network' do
  title "BDC core network"

  domain = 'ls.lsst.org'.freeze

  %w[core1 core2 core3].map { |shortname| "#{shortname}.#{domain}" }.each do |fqdn|
    describe host(fqdn) do
      it { should be_resolvable }
      it { should be_reachable }
    end
  end
end

control 'hypervisor_fs' do
  title "Hypervisor filesystem"

  describe service('libvirtd') do
    it { should be_running }
    it { should be_enabled }
  end

  describe service('iptables') do
    it { should_not be_running }
    it { should_not be_enabled }
  end

  describe filesystem("/") do
    gigabyte = 1000 * 1000
    its(:percent_free) { should be >= 50.0 }
    its(:size_kb) { should be >= 48 * gigabyte }
  end

  describe filesystem("/vm") do
    gigabyte = 1000 * 1000
    its(:percent_free) { should be >= 50.0 }
    its(:size_kb) { should be >= 450 * gigabyte }
  end

  describe mount("/vm") do
    it { should be_mounted }
    its(:device) { should eq "/dev/mapper/data-vms" }
    its(:type) { should eq 'xfs' }
  end

  describe file("/vm") do
    its(:type) { should eq :directory }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'root' }
    its(:mode) { should eq 0o1777 }
  end
end

control 'hypervisor_foreman_access' do
  title "Allow Foreman to manage VMs on the core nodes"
  only_if { command('id').stdout.match(/root/) }

  describe file('/etc/polkit-1/rules.d/80-libvirt.rules') do
    it { should exist }
    its(:content) { should match(/libvirt/) }
  end

  describe file('/etc/libvirt/libvirtd.conf') do
    its(:content) { should match(/^access_drivers = \[ "polkit" \]/) }
  end

  describe user('foreman') do
    it { should exist }
    its(:groups) { should include('libvirt') }
  end

  describe file('/root/.ssh/authorized_keys') do
    its(:mode) { should eq 0o0600 }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'root' }
    # TODO: We're installing an SSH pubkey for foreman, but the key comment is
    # misconfigured for the summit. We should fix this up when we deploy the base
    # and eventually push a fix for the summit.
    # its(:content) { should match(/foreman/) }
  end
end

control 'hypervisor_virsh' do
  only_if { command('id').stdout.match(/root/) }

  describe command('virsh pool-dumpxml default') do
    its(:stdout) { should match(%r{<path>/vm</path>}) }
    its(:stderr) { should be_empty }
  end

  describe command('virsh pool-list --type dir --details --autostart') do
    its(:stdout) { should match(/default\s+running\s+yes/) }
    its(:stderr) { should be_empty }
  end
end

include_controls 'baseline' do
  skip_control 'sss'
end
