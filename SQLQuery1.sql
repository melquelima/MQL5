create table Integrantes(
	NOME varchar(255) primary key
)

select * from Integrantes

drop table Integrantes

insert into Integrantes Values
('Melque'),('Rilck'),('Danilo'),('Murilo')


create table Entrada(
	DATA DATE,
	NOME varchar(255),
	VALOR float
)

ALTER TABLE [dbo].[Entrada]  WITH CHECK ADD FOREIGN KEY([Nome])
REFERENCES [dbo].[Integrantes] ([Nome])


insert into Entrada Values
('2019-01-10','Melque',200),('2019-01-11','Rilck',100),('2019-01-11','Danilo',100),('2019-01-11','Murilo',100)

truncate table Entrada


create table Saida(
	DATA DATE,
	NOME varchar(255),
	VALOR float
)

ALTER TABLE [dbo].[Saida]  WITH CHECK ADD FOREIGN KEY([Nome])
REFERENCES [dbo].[Integrantes] ([Nome])

create table Log_Diario(
	DATA DATE,
	SALDO_INICIAL float,
	SALDO_FINAL float,
	PIP_INICIAL float,
	PIP_FINAL float,
	LUCRO float
)

insert into Log_Diario Values
('2019-11-01',296.54,1000,0.29654,1,703.46)

select * from Log_Diario

with SaldoDia as(
	select Nome,SUM(Valor) as Total from Entrada 
	Where DATA <= format(getdate(),'yyyy-MM-dd')
	group by NOME,VALOR
	),
Debito as (
	select Nome,SUM(Valor) as Total from Saida 
	Where DATA <= format(getdate(),'yyyy-MM-dd')
	group by NOME,VALOR
)

	select
	SaldoDia.*,
	ISNULL(Debito.Total,0) as Debito, 
	(SaldoDia.Total - ISNULL(Debito.Total,0))/(Select Sum(Valor) from Entrada) - (Select ISNULL(Sum(Valor),0) from Saida) as Taxa_Lucro 
	from SaldoDia 
	Left Join Debito
	on SaldoDia.Nome = Debito.Nome

