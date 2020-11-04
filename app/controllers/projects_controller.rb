class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :complete, :restore, :unfinished]
  before_action :project_owner?, except: [:index, :new, :create]

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.where(user_id: current_user.id, completed: nil)
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = current_user.projects.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  # PATCH /projects/:id/complete
  def complete
    if @project.update_attributes!(completed: true)
      redirect_to @project, notice: "Congratulations, this project is complete!"
    else
      redirect_to @project, alert:  "Unable to complete project."
    end
  end
  
  # GET /projects/:id/restore
  def restore
    @projects = Project.where(user_id: current_user.id, completed: true)
  end
  
  # patch /projects/:id/unfinished
  def unfinished
    if @project.update_attributes!(completed: nil)
      redirect_to projects_path(current_user), notice: "Congratulations, this project is restore!"
    else
      render unfinished_project_path(current_user), notice: "Unable to complete restore."
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:name, :description, :due_on)
    end
end
