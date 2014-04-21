'use strict'

angular.module 'neoglotApp'
  .config ($routeProvider) ->
    $routeProvider
      .when '/my/languages',
        templateUrl: 'app/my-languages/my-languages.html'
        controller: 'MyLanguageCtrl'
        resolve:
          loggedIn: (AuthService) -> AuthService.checkLoggedIn()
      .when '/my/languages/new',
        templateUrl: 'app/my-languages/my-new-language.html'
        controller: 'MyNewLanguageCtrl'
        resolve:
          loggedIn: (AuthService) -> AuthService.checkLoggedIn()
      .when '/my/languages/:language',
        templateUrl: 'app/my-languages/my-language.html'
        controller: 'MyLanguageDetailCtrl'
        resolve:
          loggedIn: (AuthService) -> AuthService.checkLoggedIn()

  .controller 'MyLanguageCtrl', ($scope, $location, $rootScope, MyLanguages) ->
    $scope.languages = MyLanguages.query()
    $scope.createLanguage = ->
      $location.url '/my/languages/new'

  .controller 'MyLanguageDetailCtrl', ($scope, $routeParams, MyLanguages) ->
    $scope.language = MyLanguages.get language:$routeParams.language
    $ "#language-editor-tabs a"
      .on 'click', (e) ->
        e.preventDefault()
        $ "#language-editor-tabs ~ div"
          .hide()
        $ e.target.hash
          .show()
        $ e.target
          .parent()
          .addClass 'selected'
          .siblings()
          .removeClass 'selected'
    $scope.save = ->
      $scope.language.$update language:$scope.language.url

  .controller 'MyNewLanguageCtrl', ($scope, $http, $location) ->
    $scope.uriComponent = /^([-A-Za-z0-9_!~'*()]|%[0-9A-Fa-f]{2})*$/
    $scope.generateUrl = ->
      $scope.language.url = encodeURIComponent $scope.language.name || ""
    $scope.create = ->
      if $scope.newLang.$valid
        $http.post '/api/languages', $scope.language
          .success ->
            $location.url '/my/languages'
