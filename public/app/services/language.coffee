'use strict'

angular.module 'neoglotApp'
  .factory 'Languages', ($resource) ->
    $resource 'api/languages/:language/:searchkey/:search/:start/:count', {},
      list:
        method: 'GET'
      read:
        method: 'GET'
      search:
        method: 'GET'
        params:
          searchkey: 'search'
  .factory 'MyLanguages', ($resource) ->
    $resource 'api/mylanguages/:language', {},
      query:
        method: 'GET'
        isArray: true
      update:
        method: 'PUT'
