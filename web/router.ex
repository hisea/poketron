defmodule Poketron.Router do
  use Poketron.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :browser_auth do  
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Poketron do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/games/:id/stop", GameController, :stop
    resources "/games", GameController, except: [:edit, :update]
  end

  scope "/auth", Poketron do
    pipe_through :browser

    get "/logout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", Poketron do
  #   pipe_through :api
  # end
end
