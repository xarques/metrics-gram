class MediumPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index_by_tag?
    true
  end

  def index_by_tags?
    true
  end

  def search_by_tag?
    true
  end
end
