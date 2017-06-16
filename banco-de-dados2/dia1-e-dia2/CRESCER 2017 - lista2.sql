-- Exerc�cio 1
-- Atualmente a tabela de Cidade tem registros duplicados (nome e UF).
-- Fa�a um c�digo (PL/SQL) que liste quais s�o as cidades duplicadas. 
-- Ap�s isso liste todos os clientes que est�o relacionados com estas cidades
declare
  cursor c_cidades is
       select Nome, UF
       from   Cidade
       group  by Nome, UF
       having count(1) >1;
  ----
  cursor c_clientes (pNome in varchar2,
                     pUF   in varchar2) is
     select cli.IDCliente,
            cli.Nome as Nome_Cliente,
            cid.Nome as Nome_Cidade,
            cid.UF
     from   Cliente cli
      inner join Cidade cid on cid.IDCidade = cli.IDCidade
     where  cid.Nome = pNome
     and    cid.UF   = pUF;
begin

  FOR c in c_cidades LOOP     
      dbms_output.put_line('Cidade: '|| c.Nome );
      FOR i in c_clientes (c.Nome, c.UF) LOOP
           dbms_output.put_line('Cliente: '|| i.Nome_Cliente );
      END LOOP;
  END LOOP;

end;

create index IX_Cidade_NomeUF   on Cidade (Nome,UF);
create index IX_Cliente_Cidade  on Cliente (IDCidade);
-- Exerc�cio 2
-- Fa�a uma rotina que permita atualizar o valor do pedido a partir dos seus itens.
--Esta rotina deve receber por parametro o IDPedido e ent�o verificar o valor total de seus itens (quantidade x valor unit�rio).
DECLARE
 CURSOR C_ListaPed (pIDPedido in number) IS
     Select SUM(Quantidade * PrecoUnitario) as ValorTotal
     From   PedidoItem
     Where  IDPedido = pIDPedido;
  vPedido  Pedido.IDPedido%TYPE;
BEGIN
   vPedido := 5;
   for reg in C_ListaPed(vPedido)loop
      update PEDIDO
      set VALORPEDIDO = reg.ValorTotal
      where IDPedido = vPedido;
    end loop;   
END;
-- Vers�o do Nunes
CREATE OR REPLACE
PROCEDURE Atualiza_Valor_Pedido (pIDPedido IN INTEGER) AS
  vValorPedido  Pedido.ValorPedido%type;
BEGIN

   Select SUM(Quantidade * PrecoUnitario)
   into   vValorPedido
   From   PedidoItem
   Where  IDPedido = pIDPedido;
   
   Update Pedido
   Set    ValorPedido = vValorPedido
   Where  IDPedido    = pIDPedido;

END;
  
-- Exerc�cio 3
-- Crie uma rotina que atualize todos os clientes que n�o realizaram nenhum 
-- pedido nos �ltimos 6 meses (considere apenas o m�s, dia 01 do 6� m�s anterior). 
-- Definir o atributo Situacao para I.
DECLARE
  CURSOR C_ListaCli IS
    SELECT c.IDCliente, c.Nome, c.Situacao 
    FROM Cliente c
    INNER JOIN Pedido p ON c.IDCliente = p.IDCliente
    WHERE IDPedido NOT IN  (SELECT IDPedido 
                             FROM PedidoItem item
                             WHERE p.DataPedido >= ADD_MONTHS(TRUNC(SYSDATE),-6));
BEGIN
   for reg in C_ListaCli loop
      update CLIENTE
      set SITUACAO = 'I'
      where IDCliente = reg.IDCliente;
    end loop;   
END;


-- Exerc�cio 4
-- Fa�a uma rotina que receba dois par�metros: IDProduto & M�s e Ano
-- E ent�o fa�a uma rotina que verifique no ANO/M�S para o produto informado qual
-- a lista de materiais (incluindo a quantidade) � necess�rio para atender todos 
-- os Pedidos desde per�odo. Deve imprimir o nome do material e quantidade total.
DECLARE
 CURSOR C_ListaPro (pIDProduto in number, vData in date) IS
     Select SUM(pi.Quantidade) as QuantidadePedido, pi.IdProduto as IdProduto
     From   PedidoItem pi
     INNER JOIN Pedido ped ON pi.IDPedido = ped.IDPedido
     Where  EXTRACT(Month FROM ped.DataPedido) = EXTRACT(Month FROM vData) 
            AND EXTRACT(Year FROM ped.DataPedido) = EXTRACT(Year FROM vData) AND ped.IdProduto = pIdProduto
     Group By pi.IdProduto;
     ------------------
 CURSOR C_ListaMate (pIDProduto in number) IS
     Select SUM(pm.Quantidade) as QuantidadeTotal, pr.Nome as NomeMaterial
     From   ProdutoMaterial  pm
     INNER JOIN Produto pr ON pm.IDProduto = pr.IDProduto
     Where  pm.IdProduto = pIDProduto
     Group By pr.Nome;
     -------------------     
  vProduto  Produto.IDProduto%TYPE;
  vData     Pedido.DataPedido%TYPE;
BEGIN
   vProduto := 5;
   vData := to_date('02/2014', 'mm/yyyy');
   for mate in C_ListaMate(vProduto) loop
      for pro in C_ListaPro(vProduto, vData) loop
        DBMS_OUTPUT.PUT_LINE('Material: ' || mate.NomeMaterial, 'Quantidade:' || (pro.QuantidadePedido * mate.QuantidadeTotal));
      end loop;
    end loop;   
END;

select* from pedido;
