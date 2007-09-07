class UsersController < ApplicationController
    # GET /users
    # GET /users.xml
    def index
        @users = User.paginate :all, :page=>params[:page]||1
        respond_to do |format|
            format.html do
                unless params[:page].nil?
                    render :update do |page|
                        page.replace_html :page, :partial=>'list'
                    end
                end
            end
            format.xml  do
                render :xml => @users.to_xml
            end
        end
    end
end
