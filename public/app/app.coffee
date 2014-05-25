'use strict'

angular.module 'neoglotApp', [
    'ngResource'
    'ngRoute'
    'chieffancypants.loadingBar'
    'hc.marked'
  ]
  .service 'AuthService', ($q, $timeout, $http, $location, $rootScope) ->
    checkLoggedIn: ->
      deferred = $q.defer()
      $rootScope.redirectTo = $location.path()
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
    logout: ->
      deferred = $q.defer()
      $http.post '/logout'
        .success ->
          $timeout deferred.resolve, 0

  .config ($routeProvider, $locationProvider, $httpProvider, markedProvider) ->
    $httpProvider.interceptors.push ["$q","$location", ($q, $location) ->
      response: (res) -> res
      responseError: (res) ->
        if res.status == 401
          $location.url '/login'
        $q.reject res
    ]
    $routeProvider
      .when '/',
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'
      .when '/login',
        templateUrl: 'app/login/login.html'
        controller: 'LoginCtrl'
      .when 'logout',
        resolve:
          logout: (AuthService) -> AuthService.logout()
      .otherwise
        templateUrl: 'app/404/404.html'
    markedProvider.setOptions
      sanitize: true
