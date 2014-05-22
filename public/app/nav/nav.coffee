'use strict'

angular.module 'neoglotApp'
  .controller 'NavCtrl', ($scope, $location) ->
    $scope.menuShowing = false
    $scope.isActive = (route) ->
      route == $location.path().substr 0, route.length
    $scope.toggleMenu = ->
      $scope.menuShowing = !$scope.menuShowing
    $scope.showMenu = -> $scope.menuShowing
