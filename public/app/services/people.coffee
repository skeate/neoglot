'use strict'

angular.module 'neoglotApp'
  .factory 'People', ($resource) ->
    $resource 'api/people/:user/:search/:start/:count', {},
      update:
        method: 'PUT'
      list:
        method: 'GET'
      search:
        method: 'GET'
