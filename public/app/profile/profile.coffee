'use strict'

angular.module 'neoglotApp'
  .controller 'ProfileCtrl', ($scope, $http, $location) ->
    $scope.logout = ->
      $http
        .post '/logout'
        .success (data, status, headers, config) ->
          $location.url '/'
