FbotWeb::Fpda.controllers :forum do
  SID=10

  get :list do
    #LogHelper.log_req(request)
    @title = "4PDA.ru::forums"
    @forums = Forums.filter(siteid:SID,check:1).all

    render 'list'
  end

  get '/manage/:fid' do |fid=nil|
    #LogHelper.log_req(request)
    @title = "4PDA.ru::forums"
    
    fid = params[:fid]

    if fid
      @forums = Forums.filter(siteid:SID,parent_fid:fid).all
    else
      @forums = Forums.filter(siteid:SID,level:0).all
    end
    render 'manage'
  end
  
  get '/check/:fid' do 
    #LogHelper.log_req(request)
    fid = params[:fid]
    system "cd '#{ForumHelper::CRAWLER_DIR}'; ruby 4pda.rb df #{fid}"
  end
  
  get :show, :with => :id do
    #LogHelper.log_req(request)
    @fid = params[:id]
    @forums = Forums.filter(siteid:SID).all
    forum = Forums.first(siteid:SID, fid: @fid)
    @title = forum.title
    @updated = forum.bot_updated
    from = DateTime.now.new_offset(3/24.0)-4

    @topics = Threads.filter(fid:@fid, siteid:SID).filter('updated > ?',from).reverse_order(:updated).all

    render 'show'
  end
  get :tracking_threads do
    #LogHelper.log_req(request)

    @title = "4PDA.ru::tracking"
    @topics = Threads.filter(siteid:SID,bot_tracked: 1).order(:title).all
    render 'show'
  end
  
  get '/check_forums' do 
    #LogHelper.log_req(request)
    system "cd '#{ForumHelper::CRAWLER_DIR}'; ruby 4pda.rb check_forums"
  end

  get '/check_tracking_threads' do 
    #LogHelper.log_req(request)
    system "cd '#{ForumHelper::CRAWLER_DIR}'; ruby 4pda.rb all"
  end
  get '/track_f/:id' do
    #LogHelper.log_req(request)
    Forums.where(siteid:SID, fid: params[:id]).update(check: 1)
    redirect "#{request.referrer}"
  end

  get '/untrack_f/:id' do
    #LogHelper.log_req(request)
    Forums.where(siteid:SID, fid: params[:id]).update(check: 0)
    redirect "#{request.referrer}"
  end
end
