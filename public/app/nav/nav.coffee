'use strict'

angular.module 'neoglotApp'
  .controller 'NavCtrl', ($scope, $location) ->
    $scope.menuShowing = false
    $scope.isActive = (route) ->
      route == $location.path()
    $scope.toggleMenu = ->
      $scope.menuShowing = !$scope.menuShowing
