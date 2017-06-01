﻿using EditoraCrescer.Infraestrutura;
using EditoraCrescer.Infraestrutura.Entidades;
using EditoraCrescer.Infraestrutura.Repositorios;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace EditoraCrescer.Api.Controllers
{
    [RoutePrefix("api/Revisores")]
    public class RevisoresController : ApiController
    {
        private Contexto contexto = new Contexto();

        private RevisorRepositorio repositorio = new RevisorRepositorio();

        [HttpGet]
        public IHttpActionResult Obter()
        {
            var revisores = repositorio.Obter();
            return Ok(new { dados = revisores });
        }

        [Route("{id:int}")]
        [HttpGet]
        public IHttpActionResult ObterRevisorPorId(int id)
        {
            var revisor = repositorio.Obter(id);
            return Ok(new { dados = revisor });
        }

        [HttpPost]
        public IHttpActionResult CriarRevisor(Revisor revisor)
        {
            repositorio.Criar(revisor);
            return Ok();
        }

        [Route("{id:int}")]
        [HttpDelete]
        public HttpResponseMessage Delete(int id)
        {
            var revisor = repositorio.Obter(id);
            if (revisor == null)
                return Request.CreateResponse(HttpStatusCode.NotFound,
                    new { mensagens = new string[] { "Revisor não encontrado" } });

            repositorio.Deletar(id);
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        [Route("{id:int}")]
        [HttpPut]
        public HttpResponseMessage AtualizarRevisor(int id, Revisor revisor)
        {
            if (id != revisor.Id)
                return Request.CreateResponse(HttpStatusCode.BadRequest,
                    new { mensagens = new string[] { "Ids não conferem" } });

            if (!repositorio.VerificarSeRevisorExiste(id))
                return Request.CreateResponse(HttpStatusCode.NotFound,
                    new { mensagens = new string[] { "Revisor não encontrado" } });

            repositorio.Atualizar(id, revisor);
            return Request.CreateResponse(HttpStatusCode.OK);           
        }        

        protected override void Dispose(bool disposing)
        {
            repositorio.Dispose();
            base.Dispose(disposing);
        }
    }


}