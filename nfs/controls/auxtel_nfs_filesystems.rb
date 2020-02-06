control "auxtel_nfs_filesystems" do
  title "nfs1 NFS filesystems"

  only_if { sys_info.fqdn == 'nfs1.cp.lsst.org' }

  TERABYTE = 1000 * 1000 * 1000
  describe filesystem("/data/project") do
    its(:size_kb) { should be >= 3 * TERABYTE }
    its(:percent_free) { should be >= 80.0 }
  end

  describe filesystem("/data/lsstdata") do
    its(:size_kb) { should be >= 1.5 * TERABYTE }
    its(:percent_free) { should be >= 80.0 }
  end

  describe filesystem("/data/scratch") do
    its(:size_kb) { should be >= 0.75 * TERABYTE }
    its(:percent_free) { should be >= 80.0 }
  end

  describe filesystem("/data/home") do
    its(:size_kb) { should be >= 0.75 * TERABYTE }
    its(:percent_free) { should be >= 80.0 }
  end
end
