class MediumPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def search?
    true
  end

  def search_by_tag?
    true
  end
end
