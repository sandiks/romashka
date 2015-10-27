FbotWeb::Rsn.controllers :forum do


  get :index do
    LogHelper.log_req(request)
    @title = "rsn::forums:list"
    @forums = Forums.filter(siteid:2, level: 1).order(:bot_updated).all
    render 'list'
  end

  get :dl do
    #LogHelper.log_req(request)

    p "start updating"

    Process.detach( fork{ exec "cd '/home/fbot'; ruby run.rb rsn "} )

    #system "cd '/home/rsn'; ruby run.rb "

    #redirect(url(:forum, :list))

  end

  get :index, :with => :id do
    LogHelper.log_req(request)
    forum = Forums.first(siteid:2, fid: params[:id])
    @title = forum.name
    @topics = Threads.filter(siteid:2, fid: params[:id]).reverse_order(:updated).all

    render 'index'
  end


end
