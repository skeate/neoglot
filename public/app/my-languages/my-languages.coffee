'use strict'

angular.module 'neoglotApp'
  .config ($routeProvider) ->
    $routeProvider
      .when '/my/languages',
        templateUrl: 'app/my-languages/my-languages.html'
        controller: 'MyLanguageCtrl'
        resolve:
          loggedIn: ["AuthService", (AuthService) -> AuthService.checkLoggedIn()]
      .when '/my/languages/new',
        templateUrl: 'app/my-languages/my-new-language.html'
        controller: 'MyNewLanguageCtrl'
        resolve:
          loggedIn: ["AuthService", (AuthService) -> AuthService.checkLoggedIn()]
      .when '/my/languages/:language',
        templateUrl: 'app/my-languages/my-language.html'
        controller: 'MyLanguageDetailCtrl'
        resolve:
          loggedIn: ["AuthService", (AuthService) -> AuthService.checkLoggedIn()]

  .controller 'MyLanguageCtrl', ($scope, $location, $rootScope, MyLanguages) ->
    $scope.languages = MyLanguages.query()
    $scope.createLanguage = ->
      $location.url '/my/languages/new'

  .controller 'MyLanguageDetailCtrl', ($scope, $location, $routeParams, MyLanguages, Words, Pages, WordGenerator) ->
    language = $routeParams.language
    languageID = null
    # set up tabs
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

    # Details tab
    $scope.alpha = /^[A-Za-z ]*$/
    $scope.detailsLoaded = false
    $scope.language = MyLanguages.get language:language, (data)->
      $scope.loaded = true
      languageID = data._id
    $scope.saveDetails = ->
      MyLanguages.update language: language, $scope.language, ->
        if language != $scope.language.url
          $location.url '/my/languages/'+$scope.language.url

    # Lexicon tab
    $scope.currentPage = 0
    $scope.firstPage = true
    $scope.lastPage = true
    wordsPerPage = 10
    $scope.loadWordPage = (page) ->
      query =
        language: language
        start: page * wordsPerPage
        count: wordsPerPage
      Words.list query, (data) ->
        $scope.currentPage = page
        $scope.wordCount = data.count
        $scope.firstPage = $scope.currentPage == 0
        $scope.lastPage = $scope.currentPage == Math.floor($scope.wordCount / wordsPerPage)
        $scope.lexicon = data.words
    $scope.loadWordPage 0
    $scope.search = ->
      if $scope.searchText
        $scope.lexicon = Words.search language: language, word: $scope.searchText
      else
        $scope.loadWordPage 0
    $scope.addNewWord = ->
      $scope.newWord = true
      $scope.selectedWord =
        language: languageID
        word: ""
        definitions: []
    $scope.loadWord = ->
      $scope.newWord = false
    $scope.saveWord = (word) ->
      if word
        temp = new Words word: word, language: languageID
        temp.$save ->
          $scope.loadWordPage $scope.currentPage
          $scope.newWord = false
          $scope.selectedWord = ""
      else if $scope.newWord
        temp = new Words $scope.selectedWord
        temp.$save ->
          $scope.loadWordPage $scope.currentPage
          $scope.newWord = false
          $scope.selectedWord = ""
      else
        Words.update word: $scope.selectedWord._id, $scope.selectedWord
    $scope.deleteWord = ->
      if $scope.newWord
        $scope.selectedWord = null
      else
        Words.delete word: $scope.selectedWord._id, ->
          $scope.selectedWord = null
          $scope.loadWordPage $scope.currentPage
    $scope.deleteDefinition = (def) ->
      $scope.selectedWord.definitions.splice def, 1
    $scope.addDefinition = ->
      $scope.selectedWord.definitions.push
        pos: ""
        definition: ""

    $scope.generateWords = ->
      try
        $scope.generatorOutput = WordGenerator $scope.generatorRules
        $scope.generatorError = null
      catch e
        $scope.generatorOutput = []
        $scope.generatorError = e.message

    # Pages tab
    $scope.pages = Pages.query language: language
    $scope.loadPage = ->
      if $scope.selectedPage
        Pages.get language: language, page: $scope.selectedPage.name, (data) ->
          $scope.pagecontent = data.data
      else
        $scope.pagecontent = ""
    $scope.addNewPage = ->
      name = prompt "Name of new page?"
      if $scope.pages.some((page) -> page.name.toLowerCase() == name.toLowerCase())
        alert "Page already exists"
      else
        Pages.save language: language, page: name, {}
        $scope.pages = Pages.query language: language
    $scope.savePage = ($event) ->
      $event.currentTarget.disabled = true
      query =
        language: language
        page: $scope.selectedPage.name
      Pages.update query, markdown: $scope.pagecontent, ->
        $scope.selectedPage = ""
        $event.currentTarget.disabled = false
        $scope.pagecontent = ""
    $scope.deletePage = ->
      if confirm "Do you really want to delete '#{$scope.selectedPage.name}'?"
        Pages.delete language: language, page: $scope.selectedPage.name, ->
        $scope.selectedPage = ""
        $scope.pagecontent = ""
        $scope.pages = Pages.query language: language


  .controller 'MyNewLanguageCtrl', ($scope, $http, $location) ->
    $scope.alpha = /^[A-Za-z ]*$/
    $scope.create = ->
      if $scope.newLang.$valid
        $http.post '/api/languages', $scope.language
          .success ->
            $location.url '/my/languages'
  .directive 'simplify', ->
    restrict: 'A'
    require: '?ngModel'
    link: (scope, element, attrs, ngModel) ->
      if !ngModel? then return
      target = attrs.simplify
      replacements =
        'a': 'áàâäãå'
        'A': 'ÁÀÂÄÃÅ'
        'e': 'éèêë'
        'E': 'ÉÈÊË'
        'i': 'íìîï'
        'I': 'ÍÌÎÏ'
        'o': 'óòôöõø'
        'O': 'ÓÒÔÖÕØ'
        'u': 'úùûüů'
        'U': 'ÚÙÛÜŮ'
        'ae': 'æ'
        'AE': 'Æ'
        'oe': 'œ'
        'OE': 'Œ'
        'dh': 'ð'
        'Dh': 'Ð'
        'th': 'þ'
        'Th': 'Þ'
        'ss': 'ß'
        'n': 'ñ'
        'N': 'Ñ'
        'c': 'ç'
        'C': 'Ç'
      scope.$watch attrs.simplify, (value, oldVal) ->
        if oldVal?
          if value
            for rep, orig of replacements
              search = new RegExp '['+orig+']', 'g'
              value = value.replace search, rep
          else
            value = ''
          nonAlpha = new RegExp '[^A-Za-z ]', 'g'
          value = value.replace nonAlpha, ''
          ngModel.$setViewValue value
          ngModel.$render()
