class QuoVadis::SessionsController < ApplicationController
  layout :quo_vadis_layout

  # GET sign_in_path
  def new
    render 'sessions/new'
  end

  # POST sign_in_path
  def create
    if user = User.authenticate(params[:username], params[:password])
      flash[:notice] = t('quo_vadis.flash.sign_in.after') unless t('quo_vadis.flash.sign_in.after').blank?
      sign_in user
    else
      QuoVadis.failed_sign_in_hook self
      flash.now[:alert] = t('quo_vadis.flash.sign_in.failed') unless t('quo_vadis.flash.sign_in.failed').blank?
      render 'sessions/new'
    end
  end

  # GET sign_out_path
  def destroy
    QuoVadis.signed_out_hook current_user, self
    self.current_user = nil
    flash[:notice] = t('quo_vadis.flash.sign_out') unless t('quo_vadis.flash.sign_out').blank?
    redirect_to QuoVadis.signed_out_url
  end

  # GET forgotten_sign_in_path
  # POST forgotten_sign_in_path
  def forgotten
    if request.get?
      render 'sessions/forgotten'
    elsif request.post?
      if (user = User.where(:username => params[:username]).first)
        if user.email.present?
          user.generate_token
          QuoVadis::Notifier.change_password(user).deliver
          flash[:notice] = t('quo_vadis.flash.forgotten.sent_email') unless t('quo_vadis.flash.forgotten.sent_email').blank?
          redirect_to :root
        else
          flash.now[:alert] = t('quo_vadis.flash.forgotten.no_email') unless t('quo_vadis.flash.forgotten.no_email').blank?
          render 'sessions/forgotten'
        end
      else
        flash.now[:alert] = t('quo_vadis.flash.forgotten.unknown') unless t('quo_vadis.flash.forgotten.unknown').blank?
        render 'sessions/forgotten'
      end
    end
  end

  # GET change_password_path /sign-in/change-password/:token
  def edit
    if User.valid_token(params[:token]).first
      render 'sessions/edit'
    else
      invalid_token
    end
  end

  # PUT change_password_path /sign-in/change-password/:token
  def update
    if (user = User.valid_token(params[:token]).first)
      user.password = params[:password]
      if user.save
        user.clear_token
        flash[:notice] = t('quo_vadis.flash.forgotten.password_changed') unless t('quo_vadis.flash.forgotten.password_changed').blank?
        sign_in user
      else
        render 'sessions/edit'
      end
    else
      invalid_token
    end
  end

  private

  def sign_in(user)
    self.current_user = user
    QuoVadis.signed_in_hook user, self
    redirect_to QuoVadis.signed_in_url(user, original_url)
  end

  def original_url
    url = session[:quo_vadis_original_url]
    session[:quo_vadis_original_url] = nil
    url
  end

  def invalid_token
    flash[:alert] = t('quo_vadis.flash.forgotten.invalid_token') unless t('quo_vadis.flash.forgotten.invalid_token').blank?
    redirect_to forgotten_sign_in_url
  end

  def quo_vadis_layout
    QuoVadis.layout
  end

end
