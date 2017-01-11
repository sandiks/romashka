FbotWeb::Fpda.controllers :forum do
  @@sid=10

  get :list do
    #LogHelper.log_req(request)
    @title = "4PDA.ru::forums"
    @forums = Forums.filter(siteid:@@sid,check:1).all

    render 'list'
  end

  get '/manage/:fid' do |fid=nil|
    #LogHelper.log_req(request)
    @title = "4PDA.ru::forums"
    
    fid = params[:fid]

    if fid
      @forums = Forums.filter(siteid:@@sid,parent_fid:fid).order(:fid).all
    else
      @forums = Forums.filter(siteid:@@sid,level:0).order(:fid).all
    end
    render 'manage'
  end
    
  get :show, :with => :id do
    #LogHelper.log_req(request)
    @fid = params[:id]
    forum = Forums.first(siteid:@@sid, fid: @fid)
    @title = forum.title
    from = DateTime.now.new_offset(3/24.0)-13
    @topics = Threads.filter(fid:@fid, siteid:@@sid).reverse_order(:updated).extension(:pagination).paginate(1, 50).all

    render 'show'
  end

  get '/tracking_threads' do
    #LogHelper.log_req(request)

    @title = "4PDA.ru::tracking"
    @topics = Threads.filter(siteid:@@sid,bot_tracked: 1).exclude(fid:287).order(:title).all
    render 'show'
  end

  get '/tracking_threads/buy' do
    #LogHelper.log_req(request)
    @title = "4PDA.ru::tracking"
    @topics = Threads.filter(siteid:@@sid,bot_tracked: 1, fid:287).order(:title).all
    render 'show'
  end

  get '/track_f/:id' do
    #LogHelper.log_req(request)
    Forums.where(siteid:@@sid, fid: params[:id]).update(check: 1)
    redirect "#{request.referrer}"
  end

  get '/untrack_f/:id' do
    #LogHelper.log_req(request)
    Forums.where(siteid:@@sid, fid: params[:id]).update(check: 0)
    redirect "#{request.referrer}"
  end
end
