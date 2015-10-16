FbotWeb::Lor.controllers :thread do

  get :index, :with => [:id, :page] do
    LogHelper.log_req(request)

    tid = params[:id]
    tp = Threads.first(:tid => tid )
    @title = tp.title

    @page = params[:page].to_i
    @posts = Posts.filter(siteid:3, tid:tid, first:0).order(:addeddate).extension(:pagination).paginate(@page, 50).all

    if @posts.size ==0
      p "lor load thread #{tid} #{@page}"
      Process.detach( fork{ exec "cd '/home/fbot'; ruby lor.rb dt #{tid} #{@page}"} )
      return
    end

    @first = Posts.first(siteid:3, tid:tid, first:1)

    @responses = tp.responses.to_i
    @url = "/lor/thread/#{params[:id]}"
    render 'index'
  end

end
