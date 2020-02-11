control 'local_users' do
  title "Local unix users"

  usernames = users.where { uid >= 1000 && uid < (2**16 - 2) }.usernames
  usernames -= %w[jhoblitt_b athebo_b]

  usernames.each do |u|
    describe user(u) do
      it { should_not exist }
    end
  end
end

control 'local_groups' do
  title 'Local unix groups'

  groupnames = groups.where { gid >= 1000 && gid < (2**16 - 2) }.names
  groupnames -= %w[athebo_b jhoblitt_b wheel_b]

  groupnames.each do |groupname|
    describe group(groupname) do
      it { should_not exist }
    end
  end
end

control 'local_docker' do
  title "docker user and group are defined in IPA"

  describe user('docker'), "overlapping with the IPA user" do
    it { should_not exist }
  end

  describe group('docker'), "overlapping with the IPA group" do
    it { should_not exist }
  end
end
