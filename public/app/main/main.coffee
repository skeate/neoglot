'use strict'

angular.module 'neoglotApp'
  .controller 'MainCtrl', ($scope, $location) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
      'test'
    ]
    $scope.isActive = (route) ->
      route == $location.path()
