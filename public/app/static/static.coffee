'use strict'

angular.module 'neoglotApp'
  .config ($routeProvider) ->
    $routeProvider
      .when '/about',
        templateUrl: 'app/static/about.html'
        controller: 'StaticCtrl'
      .when '/changes',
        templateUrl: 'app/static/changelog.html'
        controller: 'StaticCtrl'
      .when '/help/generator',
        templateUrl: 'app/static/help.html'
        controller: 'StaticCtrl'
  .controller 'StaticCtrl', ($scope, $routeParams) ->
