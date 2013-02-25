$ = jQuery

$.support.cors = true

api_url = "https://api.github.com/users/"

# get github username from url, default:hit9
username = url("?").replace(/^\/|\/$/g, '')

if !username
  username = "hit9"

# get wallpaper from desktoppr.co
desktoppr_api = "https://api.desktoppr.co/1/wallpapers/random"
$.getJSON(desktoppr_api, 
  (res)->
    #$("body").css("background-image","url("+res.response.image.url+")")
)

$.ajax({
  url: api_url+username, 
  type: "get", 
  datatype: "json", 
  cache: false, 
  error: (x, s, e)->
    alert e
  success: (res)->
    $(document).attr("title", res.login+"'s "+ document.title)
    # avatar size: 170
    avatar_url = "https://secure.gravatar.com/avatar/" + res.gravatar_id + "?size=170"
    $("#avatar").attr("src", avatar_url)
    if res.name
      name = res.name
    else
      name = username
    $("#name").html("<a href=\"https://github.com/"+username+"\">"+name+"</a>")
    if res.location
      $("ul#user-info").append("
      <li>
        <i class=\"icon-map-marker icon-white\"></i>
        "+res.location+"
      </li>
        ")
    if res.email
      $("ul#user-info").append("
      <li>
        <i class=\"icon-envelope icon-white\"></i>
        "+res.email+"
      </li>
        ")
    if res.company
      $("ul#user-info").append("
      <li>
        <i class=\"icon-user icon-white\"></i>
        "+res.company+"
      </li>
        ")
    if res.blog
      $("ul#user-info").append("
      <li>
        <i class=\"icon-home icon-white\"></i>
        <a href=\""+res.blog+"\" >"+res.blog+"</a>
      </li>")
    if res.followers >= 1000
      followers = (res.followers / 1000).toFixed(1) + "k"
    else
      followers = res.followers
    $("#follower-number").text(followers)
    if res.hireable
      hireable = "YES"
      $("#hireable").css("background-color", "#199c4b")
    else
      hireable = "NO"
      $("#hireable").css("background-color", "#555")
    $("#hireable").text(hireable)
})

# get repos and display the first 5 repos

$.getJSON(api_url+username+"/repos",
  (res)->
    # sort repo by its watchers_count
    res.sort(
      (a, b)->
        ap = a.watchers_count+a.forks_count
        bp = b.watchers_count+b.forks_count
        bp-ap
    )
    # append repos to repolist
    for repo in res[0...5]
      # home page
      homepage = ""
      if repo.homepage
        homepage = "<a href=\"" + repo.homepage + "\" ><i class=\"icon-home icon-white\" ></i></a>"

      language = ""
      if repo.language
        language = "<span id=\"language\"> ("+repo.language+")</span>"
      $("#repolist").append("
        <li style=\"display: list-item;\" class=\"singlerepo\">
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
            "+repo.name+language+"
            </a>
              </h3>
          <p id=\"description\">"+homepage+"&nbsp;"+repo.description+"</p>
        </li>
      ")

    # skills
    lang = []
    size = 0

    for repo in res
      if repo.language
        if !lang[repo.language]
          lang[repo.language] = 0
        lang[repo.language] += 1
      size += 1

    tuple_arr = []

    for key, value of lang
      tuple_arr.push([key, value])
    tuple_arr.sort(
      (a, b)->
        b[1]-a[1]
    )

    # count of repository
    $("#repos-count").text(size)

    $("h1#name").append("&nbsp; <span>("+tuple_arr[0][0]+")</span>")

    $.getJSON("vendors/github-language-colors/colors.json", 
      (clr)->
        # use the first 6
        for item in tuple_arr[0...6]
          l = item[0]
          n = item[1]
          $("#skills ul#lang-container").append(
            "<li> <div style=\"background-color:"+clr[l]+"; \"> "+ parseInt(n/size * 100) + "% </div><span>"+l+"</span></li>"
          )
    )
)
