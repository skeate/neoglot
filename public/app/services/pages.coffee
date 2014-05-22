'use strict'

angular.module 'neoglotApp'
  .factory 'Pages', ($resource) ->
    $resource 'api/pages/:language/:page', {},
      update:
        method: 'PUT'
