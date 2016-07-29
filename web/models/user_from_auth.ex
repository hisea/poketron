defmodule Poketron.UserFromAuth do

  import Ecto.Query, only: [from: 1, from: 2]
  alias Ueberauth.Auth
  alias Poketron.User
  alias Poketron.Repo

  def find_or_create(%Auth{} = auth) do
    user_param = user_from_auth(auth.info)

    user = find_or_create_by_email(user_param)
    {:ok, user}
  end

  def find_or_create_by_email(user) do
    query = from u in User, where: u.email == ^user.email

    if !Repo.one(query)  do
      Repo.insert(user)
    end
    Repo.one(query)
  end


  def user_from_auth(info) do
    %User{
      name: info.name,
      email: info.email,
      first_name: info.first_name,
      last_name: info.last_name,
      image: info.image
    }
  end
end
