create or replace package body pck_megasena is

  /* Busca valores percentuais conforme regra definida na tabela 'Regra_Rateio_Premio' */
  function buscaPercentual(pIdentificador in varchar2) return number as
        -- 
        v_percentual  regra_rateio_premio.percentual%type; -- herdar� as propriedades do campo percentual
      begin
        
        -- busca percentual conforme parametro de entrada
        select percentual
        into   v_percentual   -- atribu� valor para a variavel
        from   regra_rateio_premio
        where  identificador = lower(pIdentificador);
        
        return v_percentual;
      exception
        when no_data_found then
          dbms_output.put_line('Erro: '||pIdentificador);
          raise_application_error(-20002, sqlerrm);
      end buscaPercentual;
  ---------------------------------------------------------------------------------------------------------------------------------------
  /* Executa o rateio dos premios conforme defin��o das regras */
  procedure defineRateioPremio (pPremio in number) as
    begin
    
       gPremio_sena          := buscaPercentual('premio_sena') * pPremio;
       gPremio_quina         := buscaPercentual('premio_quina') * pPremio;
       gPremio_quadra        := buscaPercentual('premio_quadra') * pPremio;
       gAcumulado_proximo_05 := buscaPercentual('acumulado_05') * pPremio;
       gAcumulado_final_ano  := buscaPercentual('acumulado_final_ano') * pPremio;
  
    end defineRateioPremio;

  ---------------------------------------------------------------------------------------------------------------------------------------
  /* Salva o registro referente ao concurso */
  procedure salvaConcurso (pConcurso in integer,
                           pData     in date,
                           pPremio   in number) as
    begin

       defineRateioPremio(pPremio);
       
       --insereConcurso( pConcurso, pData, gPremio_Sena, gPremio_Quina, gPremio_Quadra, gAcumulado_proximo_05, gAcumulado_final_ano );
       
       Insert into Concurso 
           (Idconcurso, Data_Sorteio, Premio_Sena, Premio_Quina, Premio_Quadra, Acumulado_Proximo_05, Acumulado_Final_Ano)
       Values 
           (pConcurso, pData, gPremio_Sena, gPremio_Quina, gPremio_Quadra, gAcumulado_proximo_05, gAcumulado_final_ano);
    end salvaConcurso;
  ---------------------------------------------------------------------------------------------------------------------------------------
    /* Busca o id do �ltimo concurso (maior ID)*/
  function buscaMaiorId return number as
        -- 
        v_id  concurso.IdConcurso%type; 
      begin        
        -- busca id na tabela de concurso
        select IdConcurso
        into   v_id   -- atribu� valor para a variavel
        from   concurso
        where  rownum = 1
        Order By IdConcurso DESC;
        
        return v_id;
      exception
        when no_data_found then
          dbms_output.put_line('Erro ao encontrar maior IdConcurso de concurso');
          raise_application_error(-20002, sqlerrm);
      end buscaMaiorId;
  ---------------------------------------------------------------------------------------------------------------------------------------
    /* Verifica se h� valor acumulado no �ltimo concurso*/
  function verificaSeAcumulou(pIdConcurso in number) return number as
        v_acumulou concurso.acumulou%type;
        begin
            select acumulou into v_acumulou 
            from concurso 
            where idconcurso = pIdConcurso;
            return v_acumulou;
        end verificaSeAcumulou;
  ---------------------------------------------------------------------------------------------------------------------------------------  
      /* Busca valor acumulado no �ltimo concurso*/
  function buscaValorAcumulado(pIdConcurso in number) return number as
        v_acumulou concurso.acumulado_proximo_05%type;
        begin
            select acumulado_proximo_05 into v_acumulou 
            from concurso 
            where idconcurso = pIdConcurso;
            return v_acumulou;
        end buscaValorAcumulado;
  --------------------------------------------------------------------------------------------------------------------------------------- 
    /* Busca valor arrecadado no �ltimo concurso*/
  function buscaValorArrecadado(pIdConcurso in number)return number as 
        v_valorArrecadado number;
        begin
            select sum(valor) into v_valorArrecadado
            from aposta
            where IdConcurso = pIdConcurso;
            
            v_valorArrecadado := v_valorArrecadado * 0.435;
            
            if(verificaSeAcumulou(pIdConcurso) != 0) then
                 v_valorArrecadado := v_valorArrecadado + buscaValorAcumulado(pIdConcurso);
            end if;
            
            return v_valorArrecadado;
        end buscaValorArrecadado;  
  ---------------------------------------------------------------------------------------------------------------------------------------
    /*
     Quest�o "A" - implementar rotina que ir� inserir um novo concurso
    */
  procedure geraProximoConcurso as
   begin
      -- Chama procedure que inclui nas tabelas o novo concurso.
      salvaConcurso(buscaMaiorId+1, sysdate, buscaValorArrecadado(buscaMaiorId)); 
      
   end geraProximoConcurso;
  ---------------------------------------------------------------------------------------------------------------------------------------
      /* Busca apostas de um concurso */
  function comparaDezena(pIdConcurso in number)return number as 
        v_valorArrecadado number;
        begin
            select IdAposta
            from aposta
            where IdConcurso = pIdConcurso;            
            
            return v_valorArrecadado;
        end buscaApostasPorConcurso;  
  ---------------------------------------------------------------------------------------------------------------------------------------
    /*
     Quest�o "B" - implementar rotina que ir� inserir todos os acertadores de um determinado concurso
    */
  procedure atualizaAcertadores (pIdConcurso in integer) as
        cursor c_apostasConcurso is
            select IdAposta
            from aposta
            where IdConcurso = pIdConcurso;
        ---------------------------------------------------------
        cursor c_numeroAposta (pIdAposta in number) is
            select IdNumero_Aposta, numero
            from numero_aposta
            where IdAposta = pIdAposta;
        ----------------------------------------------------------
        cursor c_comparaDezena (pIdNumero_Aposta in number) is
            select IdNumero_Aposta, numero
            from numero_aposta
            inner join concurso con on 
            where IdAposta = pIdAposta;
        ----------------------------------------------------------
      begin
      
        FOR apo in c_apostasConcurso LOOP            
            FOR num in c_numeroAposta (apo.IdAposta) LOOP
                FOR numap in c_numeroAposta (num.IdNumero_Aposta) LOOP
                    
                END LOOP;
            END LOOP;
        END LOOP;              
            
      buscaApostasPorConcurso(pIdConcurso);
      
   end atualizaAcertadores;
   
begin
  -- Initialization
  null; --<Statement>;
end pck_megasena;