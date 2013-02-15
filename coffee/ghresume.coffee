# objects work with gh3.js
user = new Gh3.User("hit9")

$(document).ready ->
  user.fetch(
    (err, res) ->
      document.title = res.login + "'s Resume"
      avatar_url = "https://secure.gravatar.com/avatar/" + res.gravatar_id + "?size=170"
      $("#avatar").attr("src", avatar_url)
      $("#name").text(res.name)
      $("#user-info #location").text(res.location)
      $("#user-info #email").text(res.email)
      $("#user-info #company").text(res.company)
      $("#user-info #blog").text(res.blog)
      $("#followers #follower-number").text(res.followers)
  )
