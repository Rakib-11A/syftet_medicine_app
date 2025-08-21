class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # if user.admin? || user.moderator?
    if user.admin?
      can :manage, :all
      can :admin, :all
    else
      can :read, :all
    end
  end
end
