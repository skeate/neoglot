'use strict'

describe 'Neoglot', ->
  httpBackend = null
  #beforeEach inject ($rootScope, $controller, $httpBackend, $http) ->
    #loggedIn = false
    #scope = $rootScope.$new()
    #httpBackend = $httpBackend
    #httpBackend.when 'GET', '/loggedin'
      #.respond loggedIn
    #httpBackend.when 'POST', '/login'
      #.respond
  describe 'Nav view', ->
    beforeEach inject ($rootScope, $controller, $httpBackend, $http) ->
      browser().navigateTo '/'
    it 'should have the title as active at first', ->
      expect(element("nav h1").attr('class')).toMatch 'active'
    it 'should change the active nav element on click', ->
      element("nav li:nth-child(3) a").click()
      expect(element("nav li:nth-child(3)").attr('class')).toMatch 'active'
      expect(element("nav h1").attr('class')).not().toMatch 'active'
    it 'should go to login when going to My Languages without logging in', ->
      element("nav li:nth-child(1) a").click()
      expect(browser().location().path()).toBe '/login'
