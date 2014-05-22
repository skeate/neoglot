'use strict'

angular.module 'neoglotApp'
  .config ($routeProvider) ->
    $routeProvider
      .when '/people',
        templateUrl: 'app/people/people.html'
        controller: 'PeopleCtrl'
      .when '/people/:user',
        templateUrl: 'app/people/people-detail.html'
        controller: 'PeopleDetailCtrl'
  .controller 'PeopleCtrl', ($scope, $routeParams, People) ->
    $scope.page = 1
    usersPerPage = 10
    $scope.loaded = false
    $scope.totalPages = "..."
    $scope.loadPage = ->
      if $scope.page < 1 then return
      query =
        start: ($scope.page-1) * usersPerPage
        count: usersPerPage
      if $scope.searchText
        query.search = $scope.searchText
        method = People.search
      else
        method = People.list
      method query, (data) ->
        $scope.loaded = true
        $scope.totalPages = Math.ceil(data.count / usersPerPage)
        $scope.firstPage = parseInt($scope.page) == 1
        $scope.lastPage = parseInt($scope.page) == $scope.totalPages
        $scope.users = data.users
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

  .controller 'PeopleDetailCtrl', ($scope, $routeParams, People) ->
    $scope.loaded = false
    $scope.user = People.get user: $routeParams.user, ->
      $scope.loaded = true
