'use strict'

angular.module 'neoglotApp'
  .factory 'People', ($resource) ->
    $resource 'api/people/:user/:search/:start/:count', {},
      update: 'PUT'
      list: 'GET'
      search: 'GET'
