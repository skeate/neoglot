'use strict'
app = angular.module 'neoglotApp', []
  .config ($routeProvider, $locationProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'app/main/main.html'
        controller: 'MainCtrl'
      .when '/my/languages',
        templateUrl: 'app/my-languages/my-languages.html'
        controller: 'MyLanguageCtrl'
      .when '/my/profile',
        templateUrl: 'app/profile/my-profile.html'
        controller: 'ProfileCtrl'
      .when '/languages',
        templateUrl: 'app/languages/languages.html'
        controller: 'LanguageCtrl'
      .when '/people',
        templateUrl: 'app/people/people.html'
        controller: 'PeopleCtrl'
      .otherwise
        redirectTo: '/'

    #$locationProvider.html5Mode true
