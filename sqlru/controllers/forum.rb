FbotWeb::Sqlru.controllers :forum do


  get :index do
    LogHelper.log_req(request)
    @title = "Gamed.ru::forums"
    @forums = Forums.filter(siteid:6,check:1).all

    render 'list'
  end

  get :index, :with => :id do
    LogHelper.log_req(request)
    @fid = params[:id]
    @forums = Forums.filter(siteid:6).all
    forum = Forums.first(siteid:6, fid: @fid)
    @title = forum.name
    from = DateTime.now.new_offset(3/24.0).to_date

    @topics = Threads.filter('updated > ?',from).filter(fid:@fid, siteid:6).reverse_order(:updated).all

    render 'index'
  end

end
