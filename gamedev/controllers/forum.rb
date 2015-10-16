FbotWeb::Gamedev.controllers :forum do


  get :index do
    LogHelper.log_req(request)
    @title = "Gamed.ru::forums"
    @forums = Forums.filter(siteid:4).all

    render 'list'
  end

  get :list do
    LogHelper.log_req(request)
    @title = "Gamed.ru::forums"
    @forums = Forums.filter(siteid:4).all

    render 'list'
  end



  get :index, :with => :id do
    LogHelper.log_req(request)
    @forums = Forums.filter(siteid:4).all
    forum = Forums.first(siteid:4, fid: params[:id])
    @title = forum.name
    @topics = Threads.filter(fid:params[:id], siteid:4).reverse_order(:updated).all

    render 'index'
  end

end
