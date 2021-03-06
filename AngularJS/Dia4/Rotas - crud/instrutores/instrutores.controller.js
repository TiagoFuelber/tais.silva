angular
    .module('app')
    .controller('InstrutoresController', function ($scope, instrutoresService, aulasService) {
    	$scope.controller = 'InstrutoresController';
		$scope.instrutores = [];
		$scope.aulas = [];
		carregar();

		function carregar() {
			instrutoresService.listar().then(function (response) {				
				setTimeout(function() {
				   $('[data-toggle="tooltip"]').tooltip()
				}, 0); 
				$scope.instrutores = response.data;
			});
			aulasService.listar().then(function (response) {
				setTimeout(function() {
				   $('[data-toggle="tooltip"]').tooltip()
				}, 0); 
				$scope.aulas = response.data;
			});
    	}
    	
	    $scope.sucesso = function() {
	    	return swal("Pronto!", "Ação realizada com Sucesso!", "success");		
	    }

	    function gerarProximoId(lista){
	    	return lista.length !== 0 ? lista[lista.length-1].id + 1 : 0;
		};

		function procuraPorId(id){
			return $scope.instrutores.find(i => i.id === id);
		};

		$scope.carregaInformacoes = function (id){
			$scope.edit = angular.copy(procuraPorId(id));
		};

		function carregarInstrutores() {
			instrutoresService
			.listar()
			.then(function (response) {				
				$scope.instrutores = response.data;
		    })
		};

		// Incluir novo instrutor.
	    $scope.incluirInstrutor = function (novoInstrutor) {
	    	if ($scope.formInstrutores.$valid) {
	    		if (!novoInstrutor.urlFoto) {
	    		    novoInstrutor.urlFoto = "imagens/foto-padrao.jpg";
	    		}if(!novoInstrutor.dandoAula) {
	    			novoInstrutor.dandoAula = false;
	    		}

    			novoInstrutor.id = gerarProximoId($scope.instrutores);

    			instrutoresService
	    			.incluir(novoInstrutor)
	    			.then(function(response) {
	    				$scope.novoInstrutor = {};
	    				carregarInstrutores();	
	    				return $scope.sucesso();
	    			})	    		
	     	}
	     };

	    // Editar instrutor.
    	$scope.editarInstrutor = function(instrutor) {
    		
    		if ($scope.form.$valid) {
                var aux = procuraPorId(instrutor.id);
                var index = $scope.instrutores.indexOf(aux);
    			$scope.instrutores[index] = instrutor;

    			instrutoresService
	    			.alterar(instrutor)
	    			.then(function(response) {
	    				carregarInstrutores();
	    				return $scope.sucesso();
	    			})    								
    	 	}else {
    	 		swal("Preencha todos os campos em vermelho corretamente.");
    	 	}
        };

        // Remover instrutor.
    	$scope.removerInstrutor = function(instrutor) {

			instrutoresService
				.excluir(instrutor)
				.then(function() {
					carregarInstrutores();
					return $scope.sucesso();
				})		
		};

		swal.setDefaults({
		  confirmButtonColor: '#3399FF'
		});		

		// setTimeout(function() {
		//    $('[data-toggle="tooltip"]').tooltip()
		// }, 0);    
});