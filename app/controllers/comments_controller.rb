class CommentsController < ApplicationController
	before_action :authenticate_user!
	def create
		@article = Article.find(params[:article_id])
		comment_params_hash = comment_params
		comment_params_hash[:user_id] = current_user.id
		if params[:comment][:parent_id].to_i > 0
			@article = Article.find_by_id(params[:comment][:article_id])
			comment_params_hash[:article_id] = @article.id if !@article.blank?
		    parent = Comment.find_by_id(params[:comment].delete(:parent_id))
		    @comment = parent.children.build(comment_params_hash)
		else
		    @comment = @article.comments.create(comment_params_hash)
		end

		if @comment.save
			flash[:success] = 'Your comment was successfully added!'
			redirect_to article_path(@article)
		else
			render 'new'
		end
	end

	def destroy
		@article = Article.find(params[:article_id])
		@comment = @article.comments.find(params[:id])
		@comment.destroy
		redirect_to article_path(@article)
	end

	def index
		@comments = Comment.hash_tree
	end

	def new
		@article = Article.find(params[:article_id])
		@comment = Comment.new(parent_id: params[:parent_id])
	end

	private
		def comment_params
		  params.require(:comment).permit(:title, :author, :body)
		end
end
