'use strict'

angular.module 'neoglotApp'
  .config ($routeProvider) ->
    $routeProvider
      .when '/languages',
        templateUrl: 'app/languages/languages.html'
        controller: 'LanguagesCtrl'
      .when '/languages/:language',
        templateUrl: 'app/languages/languages-detail.html'
        controller: 'LanguagesDetailCtrl'
      .when '/languages/:language/:page',
        templateUrl: 'app/languages/languages-detail.html'
        controller: 'LanguagesDetailCtrl'
  .controller 'LanguagesCtrl', ($scope, $routeParams, Languages) ->
    $scope.page = 1
    langsPerPage = 10
    $scope.loaded = false
    $scope.totalPages = "..."
    $scope.loadPage = ->
      if $scope.page < 1 then return
      query =
        start: ($scope.page-1) * langsPerPage
        count: langsPerPage
      if $scope.searchText
        query.search = $scope.searchText
        method = Languages.search
      else
        method = Languages.list
      method query, (data) ->
        $scope.loaded = true
        $scope.totalPages = Math.ceil(data.count / langsPerPage)
        $scope.firstPage = parseInt($scope.page) == 1
        $scope.lastPage = parseInt($scope.page) == $scope.totalPages
        $scope.languages = data.languages
    $scope.loadPage()
    $scope.back = ->
      $scope.page--
      $scope.loadPage()
    $scope.forward = ->
      $scope.page++
      $scope.loadPage()
    $scope.search = ->
      $scope.page = 1
      $scope.loadPage()

  .controller 'LanguagesDetailCtrl', ($scope, $location, $routeParams, Languages, Pages, Words) ->
    $scope.loaded = false
    $scope.language = Languages.read language: $routeParams.language, ->
      $scope.loaded = true
    $scope.pages = Pages.query language:$routeParams.language, ->
      if $routeParams.page?
        temp = $scope.pages.filter((page) -> page.name == $routeParams.page)
        if temp.length > 0
          $scope.selectedPage = temp[0]
        else
          $scope.selectedPage = ""
      else
        $scope.selectedPage = $scope.pages[0]
      $scope.loadPage()
    $scope.loadPage = ->
      if $scope.selectedPage
        if $scope.selectedPage.name == "Overview"
          $location.url '/languages/'+$routeParams.language
        else
          $location.url '/languages/'+$routeParams.language+'/'+$scope.selectedPage.name
        Pages.get language: $routeParams.language, page: $scope.selectedPage.name, (page) ->
          $scope.page = page.data
      else #lexicon
        $location.url '/languages/'+$routeParams.language+'/Lexicon'
        $scope.loadLexiconPage 0
    $scope.lexiconPage = 1
    $scope.loadLexiconPage = ->
      wordsPerPage = 25
      query =
        language: $routeParams.language
        start: ($scope.lexiconPage-1) * wordsPerPage
        count: wordsPerPage
      Words.list query, (data) ->
        $scope.wordCount = data.count
        $scope.totalPages = Math.ceil($scope.wordCount / wordsPerPage)
        $scope.firstPage = $scope.lexiconPage == 1
        $scope.lastPage = $scope.lexiconPage == $scope.totalPages
        $scope.lexicon = data.words
    $scope.back = ->
      $scope.lexiconPage--
      $scope.loadLexiconPage()
    $scope.forward = ->
      $scope.lexiconPage++
      $scope.loadLexiconPage()
