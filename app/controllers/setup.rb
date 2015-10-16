FbotWeb::App.controllers :setup do

  get :index do
    @title = "setup::index"
    render 'index'
  end

  get :forums do
    redirect '/setup/forums/0'
  end

  get :forums, :with => [:id] do
    @title = "setup::forums"
    sid = params[:id]

    @forums = Forums.where(siteid:sid).order(:fid).all
    render 'forums'
  end
  
  get :grouped_forums, :with => [:id] do
    @title = "setup::grouped forums"
    mfid = params[:id]

    @site_forums = Site_Forums.where(mfid: mfid).all
    @forums = FbotWeb::App.cache['fbot_forums']

    #@forum_names = Hash[Forums.where().collect { |ff| [ff.fid,ff.name] }]

    render 'grouped_forums'
  end

  post :grouped_forums do
    @title = "setup::grouped forums"
    mfid = params[:mfid]
    
    sid = params[:sid]
    fid = params[:fid]

    Site_Forums.insert(mfid:mfid, siteid:sid, fid:fid)

    redirect url(:setup, :index)
  end


  get :addforum do
    @title = "setup::add forums"
    render 'addforum'
  end

  post :addforum do
    sid = params[:sid]
    fid = params[:fid]
    pfid = params[:pfid]
    fname = params[:fname]

    Forums.insert(siteid:sid, name:fname, fid: fid, parent_fid: pfid, level:1)

    redirect(url(:setup, :forums))
  end

  get :checkforum, :with => [:sid, :fid, :val] do

    Forums.where(siteid:params[:sid], fid: params[:fid]).update(:check => params[:val])

    redirect "/setup/forums/#{params[:sid]}"
  end

end
