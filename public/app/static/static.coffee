'use strict'

angular.module 'neoglotApp'
  .config ($routeProvider) ->
    $routeProvider
      .when '/about',
        templateUrl: 'app/static/about.html'
        controller: 'StaticCtrl'
      .when '/help/wordgen',
        templateUrl: 'app/static/help.html'
        controller: 'StaticCtrl'
  .controller 'StaticCtrl', ($scope, $routeParams) ->
