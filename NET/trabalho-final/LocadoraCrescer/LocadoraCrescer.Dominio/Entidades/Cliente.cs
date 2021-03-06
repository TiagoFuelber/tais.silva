﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using LocadoraCrescer.Dominio.Entidades;

namespace LocadoraCrescer.Dominio
{
    public class Cliente : EntidadeBasica
    {
        public int Id { get; private set; }
        public string Nome { get; private set; }
        public string Endereco { get; private set; }
        public string Cpf { get; private set; }
        public Genero Genero { get; private set; }
        public DateTime  DataNascimento { get; private set; }

        protected Cliente() { }

        public Cliente(string nome, string endereco, string cpf, Genero genero, DateTime dataNascimento)
        {
            Nome = nome;
            Endereco = endereco;
            Cpf = cpf;
            Genero = genero;
            DataNascimento = dataNascimento;
        }

        public void Alterar(string nome, string endereco, string cpf, Genero genero, DateTime dataNascimento)
        {
            Nome = nome;
            Endereco = endereco;
            Cpf = cpf;
            Genero = genero;
            DataNascimento = dataNascimento;
        }

        public override bool Validar()
        {
            Mensagens.Clear();

            if (string.IsNullOrWhiteSpace(Nome))
                Mensagens.Add("Nome é inválido.");

            if (string.IsNullOrWhiteSpace(Endereco))
                Mensagens.Add("Endereço é inválido.");

            if (string.IsNullOrWhiteSpace(Cpf))
                Mensagens.Add("Cpf é inválido.");

            return Mensagens.Count == 0;
        }
    }
}
