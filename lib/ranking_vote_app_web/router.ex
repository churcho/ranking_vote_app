defmodule RankingVoteAppWeb.Router do
  use RankingVoteAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug, origin: ["*"]
    plug :accepts, ["json"]
  end

  scope "/", RankingVoteAppWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", RankingVoteAppWeb do
    pipe_through :api

    options "/vote"  , VoteController  , :options
    post    "/vote"  , VoteController  , :create
    options "/result", ResultController, :options
    get     "/result", ResultController, :index
  end
end
