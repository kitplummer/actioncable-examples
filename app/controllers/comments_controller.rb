class CommentsController < ApplicationController
  before_action :set_message

  def create
    @comment = Comment.create! content: params[:comment][:content], message: @message, user: @current_user

    puts "BINNACLING!!!  #{ENV['BINNACLE_COMMENT_CTX']}"
    client = Binnacle::Client.new(ENV['BINNACLE_API_KEY'], ENV['BINNACLE_API_SECRET'])
    client.signal_asynch(ENV['BINNACLE_COMMENT_CTX'], 'COMMENTS', @current_user.id, '', 'INFO', [], @comment.to_json)
  end

  private
    def set_message
      @message = Message.find(params[:message_id])
    end
end
