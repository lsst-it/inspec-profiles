control 'partitions' do
  title "System partitions"

  GIGABYTE = 1000 * 1000
  describe filesystem('/') do
    its(:size_kb) { should be >= 50 * GIGABYTE }
    its(:percent_free) { should be >= 20.0 }
  end

  describe filesystem('/home') do
    its(:size_kb) { should be >= 50 * GIGABYTE }
    its(:percent_free) { should be >= 20.0 }
  end
end
