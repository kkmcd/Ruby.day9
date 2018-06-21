class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :user_signed_in?
  # 현재 로그인 된 상태니?
  def user_signed_in?
    #session[:current_user].nil?  #아래는 nil과 반대
    session[:user_id].present?  
  #else
    #redirect_to '/sign_in'
    #end
  #session[:current_user].present?
  end
  
  #로그인 되어있지 않으면 로그인하는 페이지로 이동시켜라
  def authenticate_user!
    unless user_signed_in?
      redirect_to '/sign_in'
    end
  end
  
  # 현재 로그인 된 사람이 누구니?
  # 로그인 되어 있지 않으면 로그인하는 페이지로 이동 시켜줘
  def current_user
    # 현재 로그인됐니?
    if user_signed_in?
        # 됐다면 로그인 한 사람은 누구니?
        @current_user = User.find(session[:user_id])
    end
    
  end
  
end
