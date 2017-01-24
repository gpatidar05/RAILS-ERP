var App = angular.module('App'); 

//Factory
App.factory('SalesOrders', ['$resource',function($resource){
  return $resource('/sales_orders.json', {},{
    query: { method: 'GET', isArray: true },
    create: { method: 'POST' }
  })
}]);

App.factory('SalesOrder', ['$resource', function($resource){
  return $resource('/sales_orders/:id.json', {}, {
    show: { method: 'GET' },
    update: { method: 'PUT', params: {id: '@id'} },
    delete: { method: 'DELETE', params: {id: '@id'} }
  });
}]);

//Controller
App.controller("SalesOrderListCtr", ['$scope', '$http', '$resource', 'SalesOrders', 'SalesOrder', '$location', function($scope, $http, $resource, SalesOrders, SalesOrder, $location) {

  $scope.sales_orders = SalesOrders.query();

  $scope.deleteSalesOrder = function (salesOrderId) {
    if (confirm("Are you sure you want to delete this sales_order?")){
      SalesOrder.delete({ id: salesOrderId }, function(){
        $scope.sales_orders = SalesOrders.query();
        $location.path('/');
      });
    }
  };
}]);

App.controller("SalesOrderUpdateCtr", ['$scope', '$resource', 'SalesOrder', '$location', '$routeParams', function($scope, $resource, SalesOrder, $location, $routeParams) {
  $scope.sales_order = SalesOrder.get({id: $routeParams.id})
  $scope.update = function(){
    if ($scope.salesOrderForm.$valid){
      SalesOrder.update({id: $scope.sales_order.id},{sales_order: $scope.sales_order},function(){
        $location.path('/');
      }, function(error) {
        console.log(error)
      });
    }
  };
  
  $scope.addAddress = function(){
    $scope.sales_order.addresses.push({street1: '', street2: '', city: '', state: '', country: '', zipcode: '' })
  }

  $scope.removeAddress = function(index, sales_order){
    var address = sales_order.addresses[index];
    if(address.id){
      address._destroy = true;
    }else{
      sales_order.addresses.splice(index, 1);
    }
  };

}]);

App.controller("SalesOrderAddCtr", ['$scope', '$resource', 'SalesOrders', '$location', function($scope, $resource, SalesOrders, $location) {
  $scope.sales_order = {}
  $scope.save = function () {
    if ($scope.salesOrderForm.$valid){
      SalesOrders.create({sales_order: $scope.sales_order}, function(){
        $location.path('/');
      }, function(error){
        console.log(error)
      });
    }
  }

  $scope.addAddress = function(){
    $scope.sales_order.addresses.push({street1: '', street2: '', city: '', state: '', country: '', zipcode: '' })
  }

  $scope.removeAddress = function(index, sales_order){
    var address = sales_order.addresses[index];
    if(address.id){
      address._destroy = true;
    }else{
      sales_order.addresses.splice(index, 1);
    }
  };

}]);

