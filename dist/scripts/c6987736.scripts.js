(function(){"use strict";var a,b;b=function(a,b,c,d,e){var f;return f=a.defer(),c.get("/loggedin").success(function(a){return"false"!==a?b(f.resolve,0):(e.message="You need to log in.",b(function(){return f.reject()},0),d.url("/login"))})},a=angular.module("neoglotApp",["ngRoute"]).config(["$routeProvider","$locationProvider","$httpProvider",function(a,c,d){return d.responseInterceptors.push(function(a,b){return function(c){return c.then(function(a){return a},function(c){return 401===c.status&&b.url("/login"),a.reject(c)})}}),a.when("/",{templateUrl:"app/main/main.html",controller:"MainCtrl"}).when("/my/languages",{templateUrl:"app/my-languages/my-languages.html",controller:"MyLanguageCtrl",resolve:{loggedIn:b}}).when("/my/profile",{templateUrl:"app/profile/my-profile.html",controller:"ProfileCtrl"}).when("/languages",{templateUrl:"app/languages/languages.html",controller:"MainCtrl"}).when("/people",{templateUrl:"app/people/people.html",controller:"PeopleCtrl"}).when("/login",{templateUrl:"app/login/login.html",controller:"LoginCtrl"}).otherwise({redirectTo:"/"})}])}).call(this),function(){"use strict";angular.module("neoglotApp").controller("MainCtrl",["$scope","$location",function(a,b){return a.awesomeThings=["HTML5 Boilerplate","AngularJS","Karma","test"],a.isActive=function(a){return a===b.path()}}])}.call(this),function(){"use strict";angular.module("neoglotApp").controller("NavCtrl",["$scope","$location",function(a,b){return a.menuShowing=!1,a.showMenu=function(){return a.menuShowing},a.isActive=function(a){return a===b.path()},a.toggleMenu=function(){return a.menuShowing=!a.menuShowing}}])}.call(this);