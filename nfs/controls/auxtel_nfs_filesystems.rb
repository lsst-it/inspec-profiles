control "auxtel_nfs_filesystems" do
  title "nfs1 NFS filesystems"

  only_if { sys_info.fqdn == 'nfs1.cp.lsst.org' }

  TERABYTE = 1000 * 1000 * 1000
  describe filesystem("/data/project") do
    its(:size_kb) { should be >= 3 * TERABYTE }
    its(:percent_free) { should be >= 80.0 }
  end

  describe file("/data/project") do
    it { should exist }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'nfs-project-admin' }
  end

  describe filesystem("/data/lsstdata") do
    its(:size_kb) { should be >= 1.5 * TERABYTE }
    its(:percent_free) { should be >= 80.0 }
  end

  describe file("/data/lsstdata") do
    it { should exist }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'nfs-lsstdata-admin' }
  end

  describe filesystem("/data/scratch") do
    its(:size_kb) { should be >= 0.75 * TERABYTE }
    its(:percent_free) { should be >= 80.0 }
  end

  describe filesystem("/data/home") do
    its(:size_kb) { should be >= 0.75 * TERABYTE }
    its(:percent_free) { should be >= 80.0 }
  end

  describe file("/data/scratch") do
    it { should exist }
    its(:owner) { should eq 'root' }
    its(:group) { should eq 'nfs-scratch-admin' }
    it { should be_setgid }
  end
end
