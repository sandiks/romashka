FbotWeb::Fpda.controllers :thread do

  get '/track/:tid' do
    #LogHelper.log_req(request)
    Threads.where(siteid:10, tid: params[:tid]).update(bot_tracked: 1)
    redirect "#{request.referrer}"
  end

  get '/untrack/:tid' do
    #LogHelper.log_req(request)
    Threads.where(siteid:10, tid: params[:tid]).update(bot_tracked: 0)
    redirect "#{request.referrer}"
  end
  
  get :index, :map => "/thread/:id/p/:page" do
    #LogHelper.log_req(request)

    @tid=tid = params[:id]
    @page = params[:page].to_i

    tp = Threads.first(siteid:10, tid: tid)
    @title = tp.title
    @last_viewed = tp.last_viewed
    #binding.pry

    @pages_count =Tpages.filter(siteid:10, tid:tid).map([:page,:postcount])

    @posts = Posts.where(siteid:10, :tid => tid).reverse_order(:addeddate).extension(:pagination).paginate(@page, 20).all

    @thread_users = @posts.map{ |pp| {addeduid: pp.addeduid, addedby: pp.addedby}}
    .group_by{ |p| p[:addeduid] }.sort_by{|k,v| -v.size}.map { |k,v| [k,v.first[:addedby],v.size]  }

    @responses = tp.responses.to_i
    @url = "/fpda/thread/#{tid}"

    #set last viewed time
     current_time = DateTime.now.new_offset(3/24.0)
     Threads.where(siteid:10, tid:tid).update(last_viewed: current_time)
    render 'index'
  end

end
