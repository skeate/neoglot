'use strict'

describe 'Neoglot', ->
  describe 'Nav view', ->
    beforeEach ->
      browser().navigateTo '/'
    it 'should have the title as active at first', ->
      expect(element("nav h1").attr('class')).toMatch 'active'
    it 'should change the active nav element on click', ->
      element("nav li:nth-child(3) a").click()
      expect(element("nav li:nth-child(3)").attr('class')).toMatch 'active'
      expect(element("nav h1").attr('class')).not().toMatch 'active'
