'use strict'

angular.module 'neoglotApp'
  .config ($routeProvider) ->
    $routeProvider
      .when '/my/profile',
        templateUrl: 'app/profile/my-profile.html'
        controller: 'ProfileCtrl'
        resolve:
          loggedIn: (AuthService) -> AuthService.checkLoggedIn()
  .controller 'ProfileCtrl', ($scope, $routeParams, $http, $location, People) ->
    $scope.user = People.get user:0
    $scope.logout = ->
      $http
        .post '/logout'
        .success (data, status, headers, config) ->
          $location.url '/'
    $scope.save = ->
      People.update $scope.user

