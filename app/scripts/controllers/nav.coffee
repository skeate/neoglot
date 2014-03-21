'use strict'

angular.module 'neoglotApp'
  .controller 'NavCtrl', ($scope, $location) ->
    $scope.showMenu = false
    $scope.isActive = (route) ->
      route == $location.path()
    $scope.toggleMenu = ->
      $scope.showMenu = !$scope.showMenu
