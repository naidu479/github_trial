class PostPolicy < ApplicationPolicy

  # Autobot: Read Scope

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      raise Pundit::NotAuthorizedError, "" unless user 
      @user  = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        scope.none
      end
    end
  end

  # Autobot: Permitted Attributes
def permitted_attributes
                  #add_here
if user.admin?
              [:title, :body, :user_id]
              else
                []
               end
                end



  # Autobot: Permitted Actions
def destroy?
                #return true if record.user_id == user.id
                user.admin?
              end
def update?
                #return true if record.user_id == user.id
                user.admin?
              end
 def show?
                  user.admin?
                end
def create?
                #return true if record.user_id == user.id
                user.admin?
              end


end
