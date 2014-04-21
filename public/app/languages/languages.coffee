'use strict'

angular.module 'neoglotApp'
  .config ($routeProvider) ->
    $routeProvider
      .when '/languages',
        templateUrl: 'app/languages/languages.html'
        controller: 'LanguagesCtrl'
      .when '/languages/:creator',
        templateUrl: 'app/languages/languages.html'
        controller: 'LanguagesCtrl'
      .when '/languages/:creator/:language',
        templateUrl: 'app/languages/languages-detail.html'
        controller: 'LanguagesDetailCtrl'
  .controller 'LanguagesCtrl', ($scope, $routeParams, Languages) ->
    $scope.loaded = false
    if $routeParams.creator?
      $scope.languages = Languages.query creator: $routeParams.creator, -> $scope.loaded = true
    else
      $scope.languages = Languages.query -> $scope.loaded = true
  .controller 'LanguagesDetailCtrl', ($scope) ->
    $scope.loaded = false
    #$http.get '/api/languages/'
