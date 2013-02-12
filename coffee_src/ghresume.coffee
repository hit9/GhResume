user = new Gh3.User("hit9")

# get user's name

user.fetch(
  (err, respUser) ->
    alert respUser.name
  )
