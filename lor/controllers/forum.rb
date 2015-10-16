FbotWeb::Lor.controllers :forum do

  get :index do
    LogHelper.log_req(request)
    @title = "Linux.org.ru::forums"
    @forums = Forums.filter(siteid:3).order(:fid).all
    render 'list'
  end



  get :index, :with => :id do

    LogHelper.log_req(request)
    @forums = Forums.filter(siteid:3).order(:fid).all
    forum = Forums.first(siteid:3, fid: params[:id])
    @title = forum.name
    @topics = Threads.filter(siteid:3, fid:params[:id]).reverse_order(:updated).all

    render 'index'
  end

end
