class GoalIntegrationsController < ApplicationController
  before_action :set_goal_integration, except: [:create, :new]
  
  def edit
  end

  def create
    @goal_integration = GoalIntegration.new(goal_integration_params)
    @goal_integration.user_id = current_user.id 
    if @goal_integration.save
      BeeminderIntegration.new({goal_integration: @goal_integration}).update_activity_for_goal_integration
      redirect_to edit_user_url(current_user), notice: 'Goal integration created.'
    else
      render :new
    end
  end
    
  def update
    respond_to do |format|
      if @goal_integration.update(goal_integration_params)
        format.html { redirect_to edit_user_url(current_user), notice: 'Goal integration created.' }
      else
        format.html { render edit_user_url(current_user) }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @goal_integration.destroy
    respond_to do |format|
      format.html { redirect_to edit_user_url(current_user) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goal_integration
      @goal_integration = GoalIntegration.find(params[:id])
    end

    def goal_integration_params
      params.require(:goal_integration).permit(:goal_title, :activity_type, :matching_activities, :unit)
    end
end
