module.exports = (grunt) ->
  grunt.initConfig
    emblem:
      compile:
        files:
          'app/test.html': 'app/templates/**/*.emblem'
        options:
          root: 'app/templates/'
          dependencies:
            jquery: 'app/js/vendor/jquery/dist/jquery.min.js'
            ember: 'app/js/vendor/ember/ember.prod.js'
            emblem: 'app/js/vendor/emblem/dist/emblem.min.js'
            handlebars: 'app/js/vendor/handlebars/handlebars.min.js'

  grunt.loadNpmTasks 'grunt-emblem'

  grunt.registerTask 'default', ['emblem']
