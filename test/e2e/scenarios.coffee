'use strict'

describe 'Neoglot', ->
  describe 'Nav view', ->
    beforeEach ->
      browser().navigateTo '/'
    it 'should have the title as active at first', ->
      expect(element("nav h1").attr('class')).toMatch 'active'
