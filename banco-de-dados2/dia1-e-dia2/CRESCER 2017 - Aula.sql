CREATE TABLE Pessoa (
  IDPessoa   integer not null,
  Nome       varchar2(30) not null,
     constraint PK_Pessoa primary key (IDPessoa)
);

Create sequence SQPessoa;

Insert Into Pessoa (IDPessoa, Nome)
 Values (SQPessoa.nextval, 'Andre'); 
 
 COMMIT;

-- Produtos inativos
-- Liste os produtos (id e nome) que n�o tiveram nenhuma compra nos �ltimos quatro meses.
select IDPRODUTO, NOME
from PRODUTO 
where IDPRODUTO NOT IN
(select IDPRODUTO 
from PEDIDOITEM pi
Inner Join PEDIDO pd
          on pi.IDPEDIDO = pd.IDPEDIDO 
          where DATAPEDIDO >= ADD_MONTHS(SYSDATE,-4));

-- Abaixo, solu��o do Andr�:          
SELECT IDProduto, Nome, Situacao 
FROM Produto
WHERE IDProduto NOT IN  (SELECT IDProduto 
                         FROM PedidoItem item
                         INNER JOIN Pedido ped ON item.IDPedido = ped.IDPedido
                         WHERE ped.DataPedido >= ADD_MONTHS(TRUNC(SYSDATE),-4));


-- Alterando status
-- Altere o status dos produtos (campo situacao) que n�o tiveram nenhum pedido nos �ltimos quatro meses.
update PRODUTO 
set SITUACAO = 'I'
WHERE IDProduto NOT IN  (SELECT IDProduto 
                         FROM PedidoItem item
                         INNER JOIN Pedido ped ON item.IDPedido = ped.IDPedido
                         WHERE ped.DataPedido >= ADD_MONTHS(TRUNC(SYSDATE),-4));

COMMIT;
-- Parametro
-- Fa�a uma consulta que receba um par�metro sendo o IDProduto e liste a quantidade 
-- de itens na tabela PedidoItem com este IDProduto foram vendidos
-- no �ltimo ano (desde janeiro/2017).  
select pr.IDPRODUTO, COUNT(pi.QUANTIDADE) 
from PRODUTO pr
join PEDIDOITEM pi
on pr.IDPRODUTO = pi.IDPRODUTO
and pi.IDPRODUTO = :IdProduto
join PEDIDO pd 
on pi.IDPEDIDO = pd.IDPEDIDO
where pd.DATAPEDIDO >= TO_DATE(201701, 'YYYYMM')
group by pr.IDPRODUTO; 

select * from user_tables;

EXEC dbms_stats.gather_schema_stats( USER);


      