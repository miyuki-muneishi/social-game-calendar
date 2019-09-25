class GamesController < ApplicationController
  # index show search以外、非ログイン時はindexに飛ばす
  before_action :move_to_index, except: [:index, :show, :search]

  def index
    @games = Game.all
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.tag_list.add(@game.name) # タグリストに、名前を追加する
    @game.save
    redirect_to :root
  end

  def edit
    @game = Game.find(params[:id])
  end

  def update
    game = Game.find(params[:id])
    game.update(game_params)
    redirect_to :root
  end

  def show
    @game   = Game.find(params[:id])
    @events = @game.events
    respond_to do |format|
      format.html
      format.json
    end
  end

  def search
    # 入力された検索ワードをタグに持つゲームを検索
    @games = Game.tagged_with(params[:keyword], wild: true, any: true) | Game.where('name LIKE(?)', "%#{params[:keyword]}%")

    respond_to do |format|
      format.html
      format.json
    end
  end

  private
  def game_params
    params.require(:game).permit(:name, :color, :textColor, :tag_list)
  end

  def move_to_index
    # idがあればゲームの個別ページへ
    # idがなければ(new)ルートパスへ
    if params[:id]
      redirect_to action: :show, id: params[:id] unless user_signed_in?
    else
      redirect_to root_path
    end
  end
end