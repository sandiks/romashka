FbotWeb::Sqlru.controllers :forum do


  get :index do
    #LogHelper.log_req(request)
    @title = "sql.ru::forums"
    @forums = Forums.filter(siteid:6,check:1).all

    render 'list'
  end

  get :index, :with => :id do
    #LogHelper.log_req(request)
    @fid = params[:id]
    @forums = Forums.filter(siteid:6).all
    forum = Forums.first(siteid:6, fid: @fid)
    @title = forum.name
    @updated = forum.bot_updated

    @topics = Threads.filter(fid:@fid, siteid:6).reverse_order(:updated).extension(:pagination).paginate(1, 30).all

    render 'index'
  end



  post :post_msg, :map => "/:fid/post_msg" do
    fid = params[:fid]
    tid = params[:tid].to_i
    mid = params[:mid].to_i

    thread = Threads.first('siteid=? and tid = ?',6, tid)
    title = "Re: #{thread.title}" rescue "Re: not found"
    text = params[:text]

    #p "#{fid} #{tid} #{mid} #{text}"
    SqlRuForumHelper.post(fid,tid,mid,title,text)

    #redirect "/sqlru/#{fid}/auto"
  end

end
