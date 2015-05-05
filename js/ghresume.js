(function() {
  $ = jQuery;
  $.support.cors = true;

  // Limit
  var limit = 12;

  // API
  var api = 'https://api.github.com/users/';

  // Get github username from url
  var name = url('?').replace(/^\/|\/$/g, '')
  // Default username
  if (name.length === 0)
    name = 'hit9';
  // Github url
  var guri = 'https://github.com/' + name;

  $(document).ready(function() {
    loadUser();
    loadRepos();
  });

  function loadUser() {
    $.getJSON(api + name + '?callback=?', function(res) {
      var user = res.data;
      // Title
      $(document).attr('title', user.login + '\'s ' + document.title);
      // Avatar
      $('#avatar').attr('src', user.avatar_url);
      // Name
      $('#name').html(sprintf('<a href="{0}">{1}</a>', guri,
                              user.name.length > 0? user.name : name));
      // Info
      if (user.location && user.location.length > 0)
        $('ul#user-info').append(sprintf('<li><i class="icon-map-marker icon-white"></i>{0}</li>', user.location));
      if (user.email && user.email.length > 0)
        $('ul#user-info').append(sprintf('<li><i class="icon-envelope icon-white"></i>{0}</li>', user.email));
      if (user.company && user.company.length > 0)
        $('ul#user-info').append(sprintf('<li><i class="icon-user icon-white"></i>{0}</li>', user.company));
      if (user.blog && user.blog.length > 0)
        $('ul#user-info').append(sprintf('<li><i class="icon-home icon-white"></i>{0}</li>', user.blog));

      // Followers
      var followers = user.followers;;
      if (user.followers >= 1000)
        followers = (user.followers / 1000).toFixed(1) + 'k';
      $('#follower-number').text(followers);

      // Repos
      $('#repos-count').text(user.public_repos);

      // Hireable
      if (user.hireable) {
        $('#hireable').css('background-color', '#199c4b');
        $('#hireable').text('YES')
      } else {
        $('#hireable').css('background-color', '#555');
        $('#hireable').text('NO')
      }
    });
  }

  function loadRepos() {
    var repos = [];
    // Get all repos
    function loadPage(page) {
      var uri = sprintf('{0}/repos?page={1}&callback=?',
                        api + name, page);
      $.getJSON(uri, function(res) {
        var list = res.data;
        if (list.length === 0)
          return renderRepos();
        Array.prototype.push.apply(repos, list);
        return loadPage(page + 1);
      });
    }

    function renderRepos() {
      repos = repos.filter(function(repo) {
        return !repo.fork;
      });
      // Sort by starts + forks
      repos.sort(function(a, b) {
        return (b.stargazers_count + b.forks_count) - (a.stargazers_count + a.forks_count);
      });

      // Top repos
      var topRepos = repos.slice(0, limit);
      for (var i = 0; i < topRepos.length; i++) {
        var repo = topRepos[i];
        // Homepage
        var home = '';
        if (repo.homepage && repo.homepage.length > 0)
          home = sprintf('<a href="{0}"><i class="icon-home icon-white"></i></a>', repo.homepage);
        // Language
        var lang = '';
        if (repo.language && repo.language.length > 0)
          lang = sprintf('<span id="language"> ({0})</span>', repo.language);

        $('#repolist').append(sprintf(
          '<li style="display: list-item;" class="singlerepo"><ul class="repo-stats">' +
          '<li class="stars"><i class="icon-star icon-white"></i>{0}</li>' +
          '<li class="forks"><i class="icon-share-alt icon-white"></i>{1}</li>' +
          '<li class="created_time"><i class="icon-time icon-white"></i>{2}</li>' + '</ul>' +
          '<h3><a href="{3}">{4}{5}</a></h3>' +
          '<p id="description">{6}&nbsp;{7}</p></li>', repo.stargazers_count, repo.forks_count,
          repo.created_at.substring(0, 10), repo.html_url, repo.name, lang, home, repo.description
        ));
      }

      // Skills
      var langs = {};
      for (var i = 0; i < repos.length; i++) {
        var repo = repos[i];
        if (repo.language && repo.language.length > 0) {
          if (!(repo.language in langs))
            langs[repo.language] = 0;
          langs[repo.language] += 1;
        }
      }
      console.log(langs)
      var langStats = [];
      for (var langName in langs) {
        langStats.push([langName, langs[langName]]);
      }
      langStats.sort(function(a, b) {
        return b[1] - a[1];
      });

      console.log(repos.length);

      // Main Skill of User
      $('h1#name').append(sprintf('&nbsp; <span>({0})</span>', langStats[0][0]));

      // Load colored lang.
      $.getJSON('vendors/github-language-colors/colors.json', function(colors) {
        var topLangStats = langStats.slice(0, 6);
        for (var i = 0; i < topLangStats.length; i++) {
          var item = topLangStats[i];
          $('#skills ul#lang-container').append(sprintf(
            '<li><div style="background-color:{0};">{1}%</div><span>{2}</span></li>',
            colors[item[0]], parseInt(item[1] / repos.length * 100), item[0]
          ));
        }
      });
    }

    loadPage(1);
  }
})(this);


// Help to sprintf a string
function sprintf() {
  var fmt = [].slice.apply(arguments, [0, 1])[0];
  var args = [].slice.apply(arguments, [1]);
  return fmt.replace(/{(\d+)}/g, function(match, idx) {
    return typeof args[idx] != 'undefined'? args[idx] : match;

  });

}
