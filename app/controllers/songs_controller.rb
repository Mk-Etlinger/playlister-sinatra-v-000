require 'rack-flash'

class SongsController < ApplicationController
  use Rack::Flash

  get '/songs' do 
    @songs = Song.all
    erb :'songs/index'
  end

  get '/songs/new' do
    
    erb :'songs/new'
  end

  post '/songs' do 
    @artist = Artist.find_by(name: params["Artist Name"])  
    @artist ||= Artist.create(name: params["Artist Name"])  
    @song = Song.create(name: params["Name"], artist_id: @artist.id)
    @song.genre_ids = params[:genres]

    flash[:message] = "Successfully created song."
    redirect("/songs/#{@song.slug}")
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/show'
  end

  get '/songs/:slug/edit' do 
    @song = Song.find_by_slug(params[:slug])

    erb :'songs/edit'
  end

  patch '/songs/:slug' do 
    @song = Song.find_by_slug(params[:slug])
    @song.update(params[:song])
    @song.artist = Artist.find_or_create_by(name: params[:artist][:name]) 
    @song.save
    
    flash[:message] = "Successfully updated song."

    redirect("/songs/#{@song.slug}")
  end

end

   



  # @artist = Artist.find(@song.artist_id)
  #   join = SongGenre.find(@song.id)
  #   @genre = Genre.find(join.genre_id)