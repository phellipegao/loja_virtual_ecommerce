class Backoffice::AdminsController < BackofficeControle
before_action :set_admin	, only: [:edit, :update, :destroy]
after_action :verify_authorized, only: :new
after_action :verify_policy_scoped, only: :index
  def index
  	#@admins = Admin.all
    #@admins = Admin.with_restricted_access
    @admins = policy_scope(Admin)


  end

  def new
    @admin = Admin.new
    authorize @admin
  end

  def create 
    @admin = Admin.new(params_admin)
    if @admin.save 
      redirect_to backoffice_admins_path, notice: "O Administrador (#{@admin.email}) foi cadastro com sucesso!"
    else
      render :new 
    end
  end

  def edit      
  end

  def update
  	
    if @admin.update(params_admin)
       redirect_to backoffice_admins_path, notice: "O Administrador (#{@admin.email}) foi atualizado com sucesso!"
    else
      render :edit 
    end
  end

  def destroy
    admin_email = @admin.email
    if @admin.destroy
      redirect_to backoffice_admins_path, notice: "O Administrador (#{admin_email}) foi excluido com sucesso!"
    else
      render :index
    end   
  end

private
  def params_admin
    passwd = params[:admin][:password]
    passwd_confirmation = params[:admin][:password_confirmation]

    if passwd.blank? && passwd_confirmation.blank?
      params[:admin].delete(:password)
      params[:admin].delete(:password_confirmation)
    end

    params.require(:admin).permit(:name, :email, :password, :password_confirmation)
  end

  def set_admin
    @admin = Admin.find(params[:id])
  end

end

