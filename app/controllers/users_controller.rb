class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def edit
    @goal_integration = GoalIntegration.new
  end
    
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root_url(@user), notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render root_url }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    def user_params
      params.require(:user).permit(:beeminder_token)
    end
end
