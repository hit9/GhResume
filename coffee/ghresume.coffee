# objects work with gh3.js
$ = jQuery
username = "hit9"
api_url = "https://api.github.com/users/"

# get wallpaper from desktoppr.co
desktoppr_api = "https://api.desktoppr.co/1/wallpapers/random"
$.getJSON(desktoppr_api, 
  (res)->
    $("body").css("background-image","url("+res.response.image.url+")")
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
            "+repo.name+language+"
            </a>
          </h3>
          <p id=\"description\">"+homepage+"&nbsp;"+repo.description+"</p>
        </li>
      ")
    # caculate total size and percentage of codes
    lang = []
    size = 0

    for repo in res
      if repo.language
        if !lang[repo.language]
          lang[repo.language] = 0
        lang[repo.language] += 1
      size += 1

    for l,s of lang
      per = parseInt(s/size * 100)
      $("#gh-data").append("
      <div class=\"chart\">
        <div class=\"percentage\" data-percent=\""+per+"\"><span>"+per+"</span>%</div>
          <div class=\"label\">"+l+"</div>
      </div>
      ")
    $(".chart").easyPieChart({
      barColor: "#000", 
      animate: 6000
    })
)
