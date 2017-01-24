//Factory
angular.module('App')
.factory('Users', ['$resource',function($resource){
  return $resource('/notes.json', {},{
    query: { method: 'GET', isArray: true },
    create: { method: 'POST' }
  })
}]);

angular.module('App')
    .controller('HomeCtrl', ['$scope', '$http', '$resource', 'Users', '$location', function ($scope, $http, $resource, Users, $location) {
    	$scope.users = Users.query();
        $scope.things = ['Angular', 'Rails 4.1', 'Working', 'Together!!'];
}]);