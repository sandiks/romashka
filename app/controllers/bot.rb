FbotWeb::App.controllers :bot do

  get :index do
    render 'index'
  end


  get "/site/:id" do
    sid = params[:id].to_i
    bot_script_name = ForumHelper.get_bot_script_name(sid)
    

    #Process.detach( fork{ exec "cd /home/fbot; ruby #{sites[sid]}.rb all"} )
    system "cd /home/fbot; ruby #{bot_script_name}.rb all"
    
  end

  get "/site/:id/dt/:tid" do
    sid = params[:id].to_i
    tid = params[:tid].to_i
    bot_script_name = ForumHelper.get_bot_script_name(sid)

    #p "exec ruby #{sites[sid]}.rb dft #{tid}"

    system "cd /home/fbot; ruby #{bot_script_name}.rb dft #{tid}"

  end


  get "/rsn/:id" do
    fid = params[:id].to_i

    #Process.detach( fork{ exec "cd /home/fbot; ruby #{sites[sid]}.rb all"} )
    system "cd /home/fbot; ruby rsn.rb df #{fid}"
  end

  get "/lor/:id" do
    fid = params[:id].to_i

    system "cd /home/fbot; ruby lor.rb df #{fid}"
  end

  get "/gd/:id" do
    fid = params[:id].to_i

    system "cd /home/fbot; ruby gamed.rb df #{fid}"
  end

  get "/sqlr/:id" do
    fid = params[:id].to_i

    system "cd /home/fbot; ruby sqlr.rb df #{fid}"
  end

end
