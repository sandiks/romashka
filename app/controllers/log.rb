FbotWeb::Rsn.controllers :log do

  get :index do
    LogHelper.log_req(request)

    date0 = DateTime.now.new_offset(3/24.0).to_date
    date1 = date0-1
    date2 = date0-2
    @dates = [date0,date1,date2]
    render 'index'
  end

  get :show, :with => [:date] do
    #LogHelper.log_req(request)

    from = DateTime.parse(params[:date])
    date0 = DateTime.now.new_offset(3/24.0).to_date
    date1 = date0-1
    date2 = date0-2

    @logs = Logs.filter('date > ? and date < ?', from, from +1).order(:date).all

    @dates = [date0,date1,date2]

    render 'log'
  end

  get :del_date, :with => [:date] do
    #LogHelper.log_req(request)

    dd = DateTime.parse(params[:date])
    Logs.filter('date > ? and date < ?', dd, dd +1).delete
    
    #redirect(url(:log, :index))
  end

  get :del_ip, :with => [:ip] do
    ip = params[:ip]
    Logs.filter(:ip=>ip).delete
    #redirect(url(:log, :index))
  end
end
