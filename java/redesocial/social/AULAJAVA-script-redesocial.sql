CREATE TABLE usuario (
	id integer not null,
	email varchar2(100) not null,
	nome varchar2(100) not null,
	sexo char(1) not null,
	data_nascimento DATE not null,
	senha varchar2(100) not null,
	constraint USUARIO_PK PRIMARY KEY (id));
    
CREATE sequence SEQ_USUARIO
/
CREATE trigger BI_USUARIO
  before insert on USUARIO
  for each row
begin
  select SEQ_USUARIO.nextval into :NEW.id from dual;
end;
/


/
CREATE TABLE post (
	id integer not null,
	data DATE_ATUAL not null,
	usuario integer not null,
	texto varchar2(2000) not null,
	imagem varchar2(500),
	constraint POST_PK PRIMARY KEY (id));

CREATE sequence SEQ_POST
/
CREATE trigger BI_POST
  before insert on POST
  for each row
begin
  select SEQ_POST.nextval into :NEW.id from dual;
end;
/


/
CREATE TABLE amizade (
	id integer not null,
	data DATE_ATUAL not null,
	solicitante integer not null,
	solicitado integer not null,
	situacao char(1) not null,
	constraint AMIZADE_PK PRIMARY KEY (id));

CREATE sequence SEQ_AMIZADE
/
CREATE trigger BI_AMIZADE
  before insert on AMIZADE
  for each row
begin
  select SEQ_AMIZADE.nextval into :NEW.id from dual;
end;
/


/
CREATE TABLE comentario (
	id integer not null,
	data DATE_ATUAL not null,
	post integer not null,
	usuario integer not null,
	texto varchar2(150) not null,
	constraint COMENTARIO_PK PRIMARY KEY (id));

CREATE sequence SEQ_COMENTARIO
/
CREATE trigger BI_COMENTARIO
  before insert on COMENTARIO
  for each row
begin
  select SEQ_COMENTARIO.nextval into :NEW.id from dual;
end;
/


/
CREATE TABLE reacao (
	id integer not null,
	data DATE_ATUAL not null,
	post integer not null,
	usuario integer not null,
	constraint REACAO_PK PRIMARY KEY (id));

CREATE sequence SEQ_REACAO
/
CREATE trigger BI_REACAO
  before insert on REACAO
  for each row
begin
  select SEQ_REACAO.nextval into :NEW.id from dual;
end;
/


/

ALTER TABLE post ADD CONSTRAINT post_fk0 FOREIGN KEY (usuario) REFERENCES usuario(id);

ALTER TABLE amizade ADD CONSTRAINT amizade_fk0 FOREIGN KEY (solicitante) REFERENCES usuario(id);
ALTER TABLE amizade ADD CONSTRAINT amizade_fk1 FOREIGN KEY (solicitado) REFERENCES usuario(id);

ALTER TABLE comentario ADD CONSTRAINT comentario_fk0 FOREIGN KEY (post) REFERENCES post(id);
ALTER TABLE comentario ADD CONSTRAINT comentario_fk1 FOREIGN KEY (usuario) REFERENCES usuario(id);

ALTER TABLE reacao ADD CONSTRAINT reacao_fk0 FOREIGN KEY (post) REFERENCES post(id);
ALTER TABLE reacao ADD CONSTRAINT reacao_fk1 FOREIGN KEY (usuario) REFERENCES usuario(id);


drop table comentario;
drop table reacao;
drop table post;
drop table amizade;
drop table usuario;


CREATE TABLE usuario (
	id integer not null,
	email varchar2(100) not null,
	nome varchar2(100) not null,
	sexo char(1) not null,
	data_nascimento DATE not null,
	senha varchar2(100) not null,
	constraint USUARIO_PK PRIMARY KEY (id));
    
CREATE TABLE post (
	id integer not null,
	data_atual DATE not null,
	usuario integer not null,
	texto varchar2(2000) not null,
	imagem varchar2(500),
	constraint POST_PK PRIMARY KEY (id));

CREATE TABLE amizade (
	id integer not null,
	data_atual DATE not null,
	solicitante integer not null,
	solicitado integer not null,
	situacao char(1) not null,
	constraint AMIZADE_PK PRIMARY KEY (id));

CREATE TABLE comentario (
	id integer not null,
	data_atual DATE not null,
	post integer not null,
	usuario integer not null,
	texto varchar2(150) not null,
	constraint COMENTARIO_PK PRIMARY KEY (id));

CREATE TABLE reacao (
	id integer not null,
	data_atual DATE not null,
	post integer not null,
	usuario integer not null,
	constraint REACAO_PK PRIMARY KEY (id));


ALTER TABLE post ADD CONSTRAINT post_fk0 FOREIGN KEY (usuario) REFERENCES usuario(id);

ALTER TABLE amizade ADD CONSTRAINT amizade_fk0 FOREIGN KEY (solicitante) REFERENCES usuario(id);
ALTER TABLE amizade ADD CONSTRAINT amizade_fk1 FOREIGN KEY (solicitado) REFERENCES usuario(id);

ALTER TABLE comentario ADD CONSTRAINT comentario_fk0 FOREIGN KEY (post) REFERENCES post(id);
ALTER TABLE comentario ADD CONSTRAINT comentario_fk1 FOREIGN KEY (usuario) REFERENCES usuario(id);

ALTER TABLE reacao ADD CONSTRAINT reacao_fk0 FOREIGN KEY (post) REFERENCES post(id);
ALTER TABLE reacao ADD CONSTRAINT reacao_fk1 FOREIGN KEY (usuario) REFERENCES usuario(id);


CREATE sequence SEQ_USUARIO;
CREATE sequence SEQ_POST;
CREATE sequence SEQ_AMIZADE;
CREATE sequence SEQ_COMENTARIO;
CREATE sequence SEQ_REACAO;