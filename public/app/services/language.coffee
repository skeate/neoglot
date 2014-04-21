'use strict'

angular.module 'neoglotApp'
  .factory 'Languages', ($resource) ->
    $resource 'api/languages/:creator/:language', {},
      query:
        method: 'GET'
        isArray: true
  .factory 'MyLanguages', ($resource) ->
    $resource 'api/mylanguages/:language', {},
      query:
        method: 'GET'
        isArray: true
      update:
        method: 'PUT'
