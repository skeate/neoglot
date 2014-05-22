'use strict'

describe 'Controller: Nav', ->

  scope = $location = $browser = null

  # load the controller's module
  beforeEach module 'neoglotApp'

  # Initialize the controller and a mock scope
  beforeEach inject (_$location_, _$browser_, $controller, $rootScope) ->
    scope = $rootScope.$new()
    $location = _$location_
    $browser = _$browser_
    NavCtrl = $controller 'NavCtrl',
      $scope: scope

  it 'should allow menu toggling', ->
    scope.menuShowing.should.equal false
    scope.toggleMenu()
    scope.menuShowing.should.equal true
    scope.toggleMenu()
    scope.menuShowing.should.equal false

  it 'should set active routes', ->
    $location.url '/'
    scope.isActive '/'
      .should.equal true
    scope.isActive '/languages'
      .should.equal false
    $location.url '/languages'
    scope.isActive '/'
      .should.equal false
    scope.isActive '/languages'
      .should.equal true
