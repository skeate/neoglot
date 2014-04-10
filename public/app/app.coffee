'use strict'

checkLoggedin = ($q, $timeout, $http, $location, $rootScope, $route) ->
  deferred = $q.defer()
  $rootScope.redirectTo = $route.current.originalPath
  $http.get '/loggedin'
    .success (user) ->
      if user != 'false'
        $timeout deferred.resolve, 0
      else
        $rootScope.message = 'You need to log in.'
        $timeout \
          -> deferred.reject(),
          0
        $location.url '/login'

logout = ($q, $timeout) ->
  deferred = $q.defer()
  $http.post '/logout'
    .success ->
      $timeout deferred.resolve, 0

app = angular.module 'neoglotApp', ['ngRoute']
  .config ($routeProvider, $locationProvider, $httpProvider) ->
    $httpProvider.interceptors.push ($q, $location) ->
      response: (res) -> res
      responseError: (res) ->
        if res.status == 401
          $location.url '/login'
        $q.reject res
    $routeProvider
      .when '/',
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'
      .when '/my/languages',
        templateUrl: 'app/my-languages/my-languages.html'
        controller: 'MyLanguageCtrl'
        resolve:
          loggedIn: checkLoggedin
      .when '/my/profile',
        templateUrl: 'app/profile/my-profile.html'
        controller: 'ProfileCtrl'
        resolve:
          loggedIn: checkLoggedin
      .when '/languages',
        templateUrl: 'app/languages/languages.html'
        controller: 'MainCtrl'
      .when '/people',
        templateUrl: 'app/people/people.html'
        controller: 'PeopleCtrl'
      .when '/login',
        templateUrl: 'app/login/login.html'
        controller: 'LoginCtrl'
      .when 'logout',
        resolve:
          logout: logout
      .otherwise
        redirectTo: '/'

    #$locationProvider.html5Mode true
