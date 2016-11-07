FbotWeb::App.controllers :bot do

  get :index do
    render 'index'
  end


  get "/site/:id" do
    sid = params[:id].to_i
    bot_script_name = ForumHelper.get_bot_script_name(sid)

    #Process.detach( fork{ exec "cd /home/fbot; ruby #{sites[sid]}.rb all"} )
    system "cd '#{ForumHelper::CRAWLER_DIR}'; ruby #{bot_script_name}.rb all"
    
  end

  get "/site/:id/dt/:tid" do
    sid = params[:id].to_i
    tid = params[:tid].to_i
    bot_script_name = ForumHelper.get_bot_script_name(sid)

    #p "exec ruby #{sites[sid]}.rb dft #{tid}"

    system "cd '#{ForumHelper::CRAWLER_DIR}'; ruby #{bot_script_name}.rb dft #{tid}"

  end


  get "/rsn/:id" do
    fid = params[:id].to_i

    #Process.detach( fork{ exec "cd /home/fbot; ruby #{sites[sid]}.rb all"} )
    system "cd '#{ForumHelper::CRAWLER_DIR}'; ruby rsn.rb df #{fid}"
    redirect "/rsn/forum" 

  end

  get "/lor/:id" do
    fid = params[:id].to_i

    system "cd '#{ForumHelper::CRAWLER_DIR}'; ruby lor.rb df #{fid}"
  end

  get "/gd/:id" do
    fid = params[:id].to_i

    system "cd '#{ForumHelper::CRAWLER_DIR}'; ruby gamed.rb df #{fid}"
  end

  get "/sqlr/:id" do
    fid = params[:id].to_i

    system "cd '#{ForumHelper::CRAWLER_DIR}'; ruby sqlr.rb df #{fid}"

    #redirect "/sqlru/forum/#{fid}" 
  end

end
