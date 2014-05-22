'use strict'

angular.module 'neoglotApp'
  .factory 'Words', ($resource) ->
    $resource 'api/words/:language/:word/:start/:count', {},
      list:
        method: 'GET'
        params:
          start: 0
          count: 20
      search:
        method: 'GET'
        isArray: true
      update:
        method: 'PUT'
