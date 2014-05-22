'use strict'

angular.module 'neoglotApp'
  .factory 'WordGenerator', -> (input) ->
    class Rules
      constructor: (rules) ->
        @selectors = []
        @mergers = []
        @substitutions = []
        @mimics = []
        @out = {}
        @names = {}
        @error = false
        # categorize, parse out names
        for rule in rules
          # output rule
          if rule[0] == '>'
            outputRule = rule.substr 1
            outputCheck = /// ^
                (\d+)?          # base probability
                ([^0-9{]        # any non-number or {
                (\d+            # single probability
                |{(\d+, ?)+     # list of probabilities
                (\d+|\.\.\.)}   # - ending in either '...' or a number
                )?              # don't need probability at all
                )+$///          # can have multiple element/prob pairs
            if !outputCheck.test outputRule
              @error = "Invalid output rule format."
              return
            @out = new Merger '', rule.substr 1
          # selector rule
          else if ( temp = rule.indexOf('=') ) >= 0
            sel = new Selector rule.substr(0,temp), rule.substr temp+1
            @names[rule.substr 0,temp] = sel
            @selectors.push sel
          # merger rule
          else if ( temp = rule.indexOf(':') ) >= 0
            merger = new Merger rule.substr(0,temp), rule.substr temp+1
            @names[rule.substr 0,temp] = merger
            @mergers.push merger
          # substitution rule
          else if ( temp = rule.indexOf('~') ) >= 0
            substitution = {}
            @substitutions[rule.substr 0,temp] = rule.substr temp+1
          else if ( temp = rule.indexOf('<') ) >= 0
            mimic = new Mimic rule.substr(0,temp), rule.substr temp+1
            @names[rule.substr 0,temp] = mimic
            @mimics.push mimic
        # sort names by length, then parse names in selectors/mergers/output
        sortedNames = Object.keys(@names).sort (a,b) -> b.length - a.length
        try
          for sel in @selectors
            sel.parse sortedNames, @names
          for merger in @mergers
            merger.parse sortedNames, @names
          for mimic in @mimics
            mimic.parse()
          if @out.parse?
            @out.parse sortedNames, @names
          else
            @error = "No output rule."
        catch e
          console.log e.stack
          @error = e.message
      output: (num) ->
        try
          if @error then throw new Error @error
          out = "";
          for i in [1..num]
            out += @out.output() + ' '
          for str, rep of @substitutions
            regex = new RegExp str, 'g'
            out = out.replace regex, rep
          out = out.split ' '
          out.splice(out.length-1, 1)
          out
        catch e
          console.log e.stack
          '<span class="error">'+e.message+'</span>'

    class Base
      constructor: (@name, elements) ->
        @elements = [elements]
        @prob = 100
        ###
        "split" splits remaining probability amongst unspecified
        elements (for selection)
        "full" sets probability of any unspecified to 100% (for merging)
        ###
        @defMode = 'split'

      findProb: ->
        # see if there's a base prob
        if prob = @elements[0].match /^\d+/
          @elements[0] = @elements[0].substr prob[0].length
          @prob = parseInt prob[0]

      parse: (sortedNames, allNames) ->
        totalProb = 0
        unassignedProb = []
        @findProb()
        for name in sortedNames
          j = 0
          while j < @elements.length
            choice = @elements[j]
            if typeof choice == "string" and
                    ( idx = choice.indexOf name ) >= 0
                # make a space for the found name, and split it up
                if idx != 0
                  @elements.splice(j+1,0,undefined)
                  @elements[j++] = choice.substr 0, idx
                @elements[j] = field: allNames[name]
                # see if there's a probability after the found name
                rest = choice.substr idx+name.length
                probLength = 0
                if /^\d+/.test rest
                  prob = rest.match(/^\d+/)[0]
                  @elements[j].prob = parseInt(prob) / @prob
                  probLength = prob.length
                  totalProb += @elements[j].prob
                else if /^{(\d+, ?)*(\d+|\.\.\.)}/.test rest
                  prob = rest.match(/^{(\d+, ?)*(\d+|\.\.\.)}/)[0]
                  probLength = prob.length
                  prob = prob.substring 1, prob.length-1
                  probs = prob.split ','
                  probs = (p.trim() for p in probs)
                  @elements[j].prob = probs
                  totalProb += @elements[j].prob[0]
                else
                  @elements[j].prob = 0
                  unassignedProb.push @elements[j]
                # if there is stuff after the name, add a new element
                after = idx + name.length + probLength
                if after < choice.length
                  @elements.splice j+1, 0, choice.substr(after)
            else
              j++

        # parse out regular characters
        for i in [0..@elements.length] by 1
          if typeof @elements[i] != "string"
            continue
          split = @elements[i].split /([^0-9]{.*?}|[^0-9]\d+|[^0-9])/
          @elements.splice i, 1
          for el in split
            if el == ''
              continue
            prob = 0
            if el.length > 1
              if el.match /^[^0-9]\d+$/
                prob = parseInt(el.substr 1) / @prob
              else
                probs = el.substring(2,el.length-1).split(',')
                prob = ( ( if p=='...' then p else parseInt(p) ) \
                        for p in probs)
            basicChar =
              field:
                str: el[0],
                output: -> @str
              prob: prob
            if typeof basicChar.prob == 'number' and basicChar.prob > 0
              totalProb += basicChar.prob
            else if basicChar.prob.length?
              totalProb += basicChar.prob[0]
            else
              unassignedProb.push basicChar
            @elements.splice i++, 0, basicChar

        # assign any missing probabilities
        leftoverprob = (1 - totalProb) / unassignedProb.length
        for i in [0..unassignedProb.length-1] by 1
          unassignedProb[i].prob = if @defMode == "split" then leftoverprob else 1

    class Merger extends Base
      constructor: (name, elements) ->
          super name, elements
          @defMode = 'full'
      output: ->
          out = ''
          for element in @elements
            if typeof element.prob.length != "undefined"
              for j in [0..element.prob.length-1]
                p = element.prob[j]
                if p is '...'
                  p = element.prob[--_j]
                prob = Math.random()
                break if prob > ( p / @prob )
                out += element.field.output()
            else
              prob = Math.random()
              out += element.field.output() if prob < element.prob
          out

    class Mimic extends Base
      constructor: (@name, elements) ->
        if not elements.match /^\[([^0-9]+ )*[^0-9]+\]$/
          throw new Error "Invalid mimic list format."
        @elements = elements.substring(1,elements.length-1).split ' '
      parse: ->
        @initials = []
        @trees = {}
        for word in @elements
          @initials.push word[0]
          for i in [0..word.length-1]
            if not @trees.hasOwnProperty word[i]
              @trees[word[i]] = []
            if i == word.length-1
              @trees[word[i]].push null
            else
              @trees[word[i]].push word[i+1]

    class Selector extends Base
      output: ->
        prob = Math.random()
        i = -1
        while prob > 0 and @elements[++i]?
            prob -= @elements[i].prob
        if i == @elements.length then '' else @elements[i].field.output()


    if input?
      rulesArray = input.trim().split '\n'
      gen = new Rules rulesArray
      gen.output 50
    else
      throw new Error "No input specified."
