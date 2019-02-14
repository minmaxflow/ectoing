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

    offset = 0
    username = "%tp%"
    get_users_overview = from u in User, 
                         select: [u.id, u.username]
    search_by_username = from u in get_users_overview,
                         where: like(u.username, ^username)
    query = from search_by_username,
                     limit: 10,
                    offset: ^offset

    # select only username
    get_users_overview = User |> select([u], u.username)
    search_by_username = get_users_overview |> where([u], like(u.username, ^username))
    query = search_by_username |> limit(10) |> offset(^offset)

    # association
    query = from u in User, 
            join: m in Message, 
            on: u.id == m.user_id, 
            where: u.id == 4

    query = User 
            |> join(:inner, [u], m in Message, u.id == m.user_id)
            |> where([u], u.id == 4)

    # 方法1 from the result set of a query
    # 方法一会得到两个重复的User，而且会有两次sql请求
    # result = Repo.all(query)
    # Repo.preload(result, :messages)
    # Repo.preload(result, [:messages])

    # 方法2 from within the query itself， 只有一条sql
    # using a combination of the assoc and preload functions
    query = from u in User, 
            join: m in assoc(u, :messages),
            where: u.id == 4, 
            preload: [messages: m]

    query = User 
            |> join(:inner, [u], m in assoc(u, :messages))
            |> where([u], u.id == 4)
            |> preload([u, m], [messages: m])

    # 没有join，请求单个user，然后在load messages， 有两条sql
    query = from u in User,
            where: u.id == 4,
            preload: [:messages]

    Repo.all(query)
  end

end

IO.inspect(Playground.play())
