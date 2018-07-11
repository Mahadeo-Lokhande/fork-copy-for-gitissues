require 'spec_helper'

describe ProtectedRefAccess do
  subject(:protected_ref_access) do
    create(:protected_branch, :maintainers_can_push).push_access_levels.first
  end

  let(:project) { protected_ref_access.project }

  describe '#check_access' do
    it 'is always true for admins' do
      admin = create(:admin)

      expect(protected_ref_access.check_access(admin)).to be_truthy
    end

    it 'is true for maintainers' do
      maintainer = create(:user)
      project.add_maintainer(maintainer)

      expect(protected_ref_access.check_access(maintainer)).to be_truthy
    end

    it 'is for developers of the project' do
      developer = create(:user)
      project.add_developer(developer)

      expect(protected_ref_access.check_access(developer)).to be_falsy
    end
  end
end
