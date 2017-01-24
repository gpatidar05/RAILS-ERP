angular.module('App', ['ngRoute', 'templates', 'ngResource'])
    .config(function ($routeProvider, $locationProvider, $httpProvider) {
        $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
        $routeProvider.when('/home/user', {
            templateUrl: 'home.html',
            controller: 'HomeCtrl'
        });
        $routeProvider.when('/OM/sales_orders',{
            templateUrl: 'sales_orders/index.html',
            controller: 'SalesOrderListCtr'
        });
        $routeProvider.when('/OM/sales_orders/new', {
            templateUrl: 'sales_orders/new.html',
            controller: 'SalesOrderAddCtr'
        });
        $routeProvider.when('/OM/sales_orders/:id/edit', {
            templateUrl: 'sales_orders/edit.html',
            controller: "SalesOrderUpdateCtr"
        });
        $locationProvider.html5Mode(true);
    });