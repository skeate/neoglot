'use strict';
(function(){
  var app = angular.module('neoglotApp', []);
  app.config(function ($routeProvider, $locationProvider) {
    $routeProvider
      .when('/', {
        templateUrl: 'views/main.html',
        controller: 'MainCtrl'
      })
      .when('/my/languages', {
        templateUrl: 'views/my-languages.html',
        controller: 'MainCtrl'
      })
      .when('/my/profile', {
        templateUrl: 'views/my-profile.html',
        controller: 'MainCtrl'
      })
      .when('/all/languages', {
        templateUrl: 'views/all-languages.html',
        controller: 'MainCtrl'
      })
      .when('/all/people', {
        templateUrl: 'views/all-people.html',
        controller: 'MainCtrl'
      })
      .otherwise({
        redirectTo: '/'
      });

    $locationProvider.html5Mode(true);
  });

}.call());
