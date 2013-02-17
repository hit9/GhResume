# objects work with gh3.js
$ = jQuery
username = "hit9"
api_url = "https://api.github.com/users/"

# get wallpaper from alphacoders.com

alphacoders_api_auth_key = "30cdde245ca734f3a637b1ad22419b90"
alphacoders_api = "http://wall.alphacoders.com/api1.0/get.php?auth="+alphacoders_api_auth_key+"&sort=newest"
$.getJSON(alphacoders_api, 
  (res)->
    alert res.url
  )


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
    for repo in res[0...5]
      # home page
      homepage = ""
      if repo.homepage
        homepage = "<a href=\"" + repo.homepage + "\" ><i class=\"icon-home icon-white\" ></i></a>"
      $("#repolist").append("
        <li style=\"display: list-item;\">
          <ul class=\"repo-stats\">
            <li class=\"stars\">
              <i class=\"icon-star icon-white\"></i>"+repo.watchers_count+"
            </li>
            <li class=\"forks\">
              <i class=\"icon-share-alt icon-white\"></i>
              "+repo.forks_count+"
            </li>
            <li class=\"created_time\">
              <i class=\"icon-time icon-white\"></i>"+repo.created_at.substring(0, 10)+"
            </li>
          </ul>
          <h3>
            <a href=\"https://github.com/"+username+"/"+repo.name+"\">
            "+repo.name+"
            </a>
          </h3>
          <p id=\"description\">"+homepage+"&nbsp; "+repo.description+"</p>
        </li>
      ")
)
