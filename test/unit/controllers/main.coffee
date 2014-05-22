'use strict'

describe 'Controller: Main', ->

  scope = {}

  # load the controller's module
  beforeEach module 'neoglotApp'

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MainCtrl = $controller 'MainCtrl',
      $scope: scope

  it 'should attach a list of awesomeThings to the scope', ->
    scope.awesomeThings.length.should.equal 4
