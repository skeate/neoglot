'use strict'

angular.module 'neoglotApp'
  .controller 'LoginCtrl', ($scope, $http, $location, $rootScope) ->
    $scope.redirectTo = $rootScope.redirectTo
    $scope.login = ->
      $http.post '/login', $scope.user
        .success (data, status, headers, config) ->
          if not $scope.redirectTo?
            $scope.redirectTo = '/'
          $location.url $scope.redirectTo
        .error ->
          debugger
    $scope.register = ->
      if $scope.newuser.password == $scope.newuser.passwordConfirm
        $http.post '/register', $scope.newuser
          .success ->
            if not $scope.redirectTo?
              $scope.redirectTo = '/'
            $location.url $scope.redirectTo
          .error ->
            debugger
      else
        $scope.regError = "Passwords do not match."

