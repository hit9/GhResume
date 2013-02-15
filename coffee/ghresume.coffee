# objects work with gh3.js
user = new Gh3.User("hit9")

$(document).ready ->
  user.fetch(
    (err, res) ->
      document.title = res.login + "'s Resume"
      avatar_url = "https://secure.gravatar.com/avatar/" + res.gravatar_id + "?size=170"
      $("#avatar").attr("src", avatar_url)
  )
