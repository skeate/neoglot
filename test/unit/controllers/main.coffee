'use strict'

describe 'Controller: MainCtrl', ->

  scope = {}

  # load the controller's module
  beforeEach module 'neoglotApp'

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MainCtrl = $controller 'MainCtrl',
      $scope: scope

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe(4)
