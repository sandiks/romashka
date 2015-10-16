FbotWeb::Rsn.controllers :setup do
  
  get :index do
    @title = "setup::index"
   render 'index'
  end

  get :forums do
    @title = "setup::forums"
    render 'forums'
  end

  get :addforum do
    @title = "setup::add forums"
    render 'addforum'
  end  

  post :addforum do
  	fid = params[:fid]
	fname = params[:fname]

    Forums.insert(:fid => fid, :name=>fname)

    redirect(url(:setup, :forums))
  end

  get :checkforum, :with => [:id, :val] do
    #ff = Forums.first(:fid => params[:id])    
    Forums.where(:fid => params[:id]).update(:check => params[:val])

    render 'forums'
  end

end
