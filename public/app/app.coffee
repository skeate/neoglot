'use strict'

checkLoggedin = ($q, $timeout, $http, $location, $rootScope) ->
  deferred = $q.defer()

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

app = angular.module 'neoglotApp', ['ngRoute']
  .config ($routeProvider, $locationProvider, $httpProvider) ->
    $httpProvider.responseInterceptors.push ($q, $location) ->
      (promise) ->
        promise.then \
          (res) -> res, # success
          (res) ->      # failure
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
      .when '/languages',
        templateUrl: 'app/languages/languages.html'
        controller: 'MainCtrl'
      .when '/people',
        templateUrl: 'app/people/people.html'
        controller: 'PeopleCtrl'
      .when '/login',
        templateUrl: 'app/login/login.html'
        controller: 'LoginCtrl'
      .otherwise
        redirectTo: '/'

    #$locationProvider.html5Mode true
