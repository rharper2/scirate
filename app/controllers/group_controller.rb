class GroupController < ApplicationController
  before_action :signed_in_user  
  def mow
        return index_nouser unless signed_in?
  	if @groupmessage.nil? 
  		@groupmessage = Groupmessage.new
  	end
  	@gmessages = Groupmessage.order("meeting ASC").where("meeting >= :start",{start: Time.zone.now.beginning_of_day})
  	render 'group/mow'
  end

  def create
  	logger.debug("Params are #{params.inspect}")
  	logger.debug("Current user is #{current_user}")
  	groupmessage_params =  params.require(:groupmessage).permit([:content,:image,:meeting]).merge(user_id: current_user.id)
  	logger.info("Group message is #{groupmessage_params.inspect}")
  	@groupmessage=Groupmessage.new(groupmessage_params)
  	logger.debug(@groupmessage.errors.inspect)
  	if (@groupmessage.content.nil? || @groupmessage.content.empty?) 
  		 flash[:groupmessage] = { status: :error, content: "You need to post something non nilhistic" }
   		 redirect_to request.referer
   	elsif (@groupmessage.meeting.nil?)
   		flash[:groupmessage] = { status: :error, content: "Time is relative, but here necessary"}
   		redirect_to request.referer
   	else
   		@groupmessage.save!
  		flash[:groupmessage] = { status: :success, content: "Posted" }
   		logger.info(@groupmessage.inspect)
  		redirect_to '/group/mow'
  	end
  end
  
  def edit
    logger.info("Params to edit #{params.inspect}")
    @groupmessage= Groupmessage.find(params[:group_id])
    logger.info("Params are #{params[:content]} and #{current_user.id}")
    unless @groupmessage.content == params[:content] # Don't record edit if same
      @groupmessage.edit!(params[:content], current_user.id)
    end
    redirect_to '/group/mow' 
  end

  def delete
    logger.info("It wants us to delete #{params.inspect}")
    @groupmessage= Groupmessage.find(params[:group_id])
    if @groupmessage.nil?
      flash[:message] = { status: 'Error', raw: "Couldnt find messge to delete." }
      redirect_to '/group/mow'
    else 
      @groupmessage.destroy()
      flash[:message] = { status: 'success', raw: "message deleted. " }
       redirect_to '/group/mow'
    end

  end

end
