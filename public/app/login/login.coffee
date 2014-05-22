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
        .error (data, status, headers, config) ->
          $scope.loginError = data.error
    $scope.register = ->
      if !$scope.newuser
        $scope.regErrors = ["No information entered."]
      else if $scope.newuser.password != $scope.newuser.passwordConfirm
        $scope.regErrors = ["Passwords do not match."]
      else
        $http.post '/register', $scope.newuser
          .success ->
            if not $scope.redirectTo?
              $scope.redirectTo = '/'
            $location.url $scope.redirectTo
          .error (data) ->
            $scope.regErrors = []
            for field, error of data.error.errors
              $scope.regErrors.push error.message
