alias Ectoing.Repo
alias Ectoing.{User, Message, Friend}

import Ecto.Query
import Ecto.Changeset

defmodule Playground do
  def play do
    ###############################################
    #
    # PUT YOUR TEST CODE HERE
    #
    ##############################################

    query = User 
    
    query = from u in User, select: [u.firstname, u.surname]
    query = from u in User, select: {u.firstname, u.surname}
    query = from u in User, select: %{firstname: u.firstname,lastName: u.surname}

    surname = "doe"

    query = from u in User, where: u.surname == ^surname

    query = where(User, [u], u.surname == ^ surname)

    query = from u in User,
            distinct: true,  
            select: u.surname,
            limit: 3,
            order_by: u.surname

    query = User 
            |> distinct(true)
            |> order_by([u], u.surname)
            |> limit(3)
            |> select([u], u.surname)

    query = from f in Friend,
            select: %{friend_id: f.friend_id, avg_rating: avg(f.friend_rating)},
            group_by: f.friend_id,
            having: avg(f.friend_rating) >= 4,
            order_by: [desc: avg(f.friend_rating)]

    query = Friend
            |> group_by([f], f.friend_id)
            |> having([f], avg(f.friend_rating) >= 4)
            |> order_by([f], [desc: avg(f.friend_rating)])
            |> select([f], %{friend_id: f.friend_id, avg_rating: avg(f.friend_rating)})

    Repo.all(query)
  end

end

IO.inspect(Playground.play())
