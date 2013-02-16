# objects work with gh3.js
$ = jQuery
username = "hit9"
api_url = "https://api.github.com/users/"

# get user information
$.getJSON(api_url+username,
  (res)->
    document.title = res.login + "'s Resume"
    # avatar size 170
    avatar_url = "https://secure.gravatar.com/avatar/" + res.gravatar_id + "?size=170"
    $("#avatar").attr("src", avatar_url)
    $("#name").text(res.name)
    $("#user-info #location").append(res.location)
    $("#user-info #email").append(res.email)
    $("#user-info #company").append(res.company)
    $("#user-info #blog").append("<a href=\""+res.blog+"\" >"+res.blog+"</a>")
    $("#followers #follower-number").text(res.followers)
)

# get repos and display the first 5 repos

$.getJSON(api_url+username+"/repos?type=owner",
  (res)->
    # sort repo by its watchers_count
    res.sort(
      (a, b)->
        b.watchers_count-a.watchers_count
    )
    # append repos to repolist
    for repo in res[0...4]
      $("#repolist").append("
        <li style=\"display: list-item;\">
          <h3>
            <a href=\"https://github.com/"+username+"/"+repo.name+"\">
            "+repo.name+"
            </a>
          </h3>
          <p id=\"description\">"+repo.description+"</p>
        </li>
      ")
)
