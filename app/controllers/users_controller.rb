class UsersController < ApplicationController

  def show
    @user = User.find_by(id: current_user.id)
    # current_userがリストアップされている member_id 取得して、room_id取得して、brochureを呼び出す。
    # 下は暫定対応
    @members = Member.where(user_id: current_user.id)
    @brochures = []
    @members.each do |member|
      @brochures.push(Brochure.find_by(id: member.brochure_id))
    end
  end

end
