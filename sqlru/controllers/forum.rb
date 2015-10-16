FbotWeb::Sqlru.controllers :forum do


  get :index do
    LogHelper.log_req(request)
    @title = "Gamed.ru::forums"
    @forums = Forums.filter(siteid:6,check:1).all

    render 'list'
  end

  get :index, :with => :id do
    LogHelper.log_req(request)
    @forums = Forums.filter(siteid:6).all
    forum = Forums.first(siteid:6, fid: params[:id])
    @title = forum.name
    @topics = Threads.filter(fid:params[:id], siteid:6).reverse_order(:updated).all

    render 'index'
  end

end
