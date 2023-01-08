/*
	EQUIPO 3. 
		PROCEDIMIENTOS ALMACENADOS PARA LAS CONSULTAS Y TRANSACCIONES DISTRIBUIDAS

		1. ABARCA ROMERO JOSE ANGEL
		2. MONTIEL CRUZ ANGEL LEONARDO	
		3. ORTIZ ALVARADO LUIS FERNANDO

	PARA LA CREACION DE LOS SERVIDORES VINCULADOS:
		SERVIDOR1 CORRESPONDE A LA TABLA "PERSON"
		SERVIDOR2 CORRESPONDE A LA TABLA "PRODUCTION"
		SERVIDOR3 CORRESPONDE A LA TABLA "SALES"

	LOS CUALES ESTAN ALOJADOS EN UN SERVIDOR ESCLAVO DE FORMA LOCAL EN SQL-SERVER

*/



--LISTA
/*a. Determinar el total de las ventas de los productos con la categor�a que se provea
de argumento de entrada en la consulta, para cada uno de los territorios registrados en la base de datos.*/

create or alter procedure consultaA @idCategoria int as
select soh.TerritoryID, sum(t.LineTotal) as Total_Ventas
from [SERVIDOR3].AW_Sales.Sales.SalesOrderHeader soh
inner join
(select salesorderid, productid, orderqty, linetotal
from [SERVIDOR3].AW_Sales.Sales.SalesOrderDetail sod
where ProductID in (
	select ProductID
	from [SERVIDOR2].AW_Production.Production.Product
	where ProductSubcategoryID in (
		select ProductSubcategoryID
		from [SERVIDOR2].AW_Production.Production.ProductSubcategory
		where ProductCategoryID in(
			select ProductCategoryID
			from [SERVIDOR2].AW_Production.Production.ProductCategory	
			where ProductCategoryID = @idCategoria
		)
	)
)) as T
on soh.SalesOrderID = t.SalesOrderID
group by soh.TerritoryID
order by soh.TerritoryID

exec consultaA 1



--LISTA
/*b. Determinar el producto m�s solicitado para la regi�n (atributo group de salesterritory) "North America"                 
y en que territorio de la regi�n tiene mayor demanda.*/

create or alter procedure consultaB as
	select top 1 D.[Name] as Producto, count(*) as Solicitudes, B.[Group] as Region from
	(select * from [SERVIDOR3].AW_Sales.Sales.SalesOrderHeader) as A
	inner join
	(select *  from [SERVIDOR3].AW_Sales.Sales.SalesTerritory where TerritoryID between '1' and '6') as B
	on A.TerritoryID = B.TerritoryID
	inner join
	(select * from [SERVIDOR3].AW_Sales.Sales.SalesOrderDetail) as C
	on A.SalesOrderID = C.SalesOrderID
	inner join
	(select * from [SERVIDOR2].AW_Production.Production.Product) as D
	on C.ProductID = D.ProductID
	group by B.[Group], D.[Name]
	order by Solicitudes desc
go

select * from Sales.SalesTerritory
exec consultaB



--LISTA
/*c. Incrementar el stock disponible en un 5% de los productos de la categor�a que se provea como argumento de entrada,
en una localidad que se provea como entrada en la instrucci�n de actualizaci�n.*/
create or alter procedure consultaC @idCategoria int, @idLocation int as
begin
set XACT_ABORT on
	if not exists(select B.ProductID, C.[Name], A.[Name] as Localidad, B.Quantity as Stock from (
	(select * from [SERVIDOR2].AW_Production.Production.[Location] where LocationID = @idLocation) as A
	inner join
	(select * from [SERVIDOR2].AW_Production.Production.ProductInventory) as B
	on B.LocationID = A.LocationID
	inner join
	(select * from [SERVIDOR2].AW_Production.Production.Product) as C
	on B.ProductID = C.ProductID
	inner join
	(select * from [SERVIDOR2].AW_Production.Production.ProductSubcategory where ProductCategoryID = @idCategoria) as D
	on D.ProductSubcategoryID = C.ProductSubcategoryID))
		begin
			print 'Error: No se encontró la categoria ingresada en esa localidad'
		end
	else
	begin
		begin tran Transaccion1
			begin try 
				update [SERVIDOR2].AW_Production.Production.ProductInventory
				set Quantity = floor(Quantity*1.05)
				where LocationID = @idLocation and ProductID in (
				select B.ProductID from (
					(select * from [SERVIDOR2].AW_Production.Production.Product) as B
					inner join
					(select * from [SERVIDOR2].AW_Production.Production.ProductSubcategory) as C
					on B.ProductSubcategoryID = C.ProductSubcategoryID))
					select * from [SERVIDOR2].AW_Production.Production.ProductSubcategory where ProductSubcategoryID = 1
				commit tran Transaccion1
			end try
			begin catch
				rollback tran Transaccion1
			end catch
		end
end


select * from [SERVIDOR2].AW_Production.Production.ProductInventory
exec consultaC 2,60



--LISTA
/*d. Determinar si hay clientes que realizan ordenes en territorios diferentes al que se encuentran.*/                     
create or alter procedure consultaD as
begin
	if not exists(
	select A.CustomerID as Cliente, A.TerritoryID as Direccion_Cliente, C.TerritoryID as Direccion_Pedido from (
	(select * from [SERVIDOR3].AW_Sales.Sales.Customer) as A
	inner join
	(select * from [SERVIDOR3].AW_Sales.Sales.SalesTerritory) as B
	on A.TerritoryID = B.TerritoryID
	inner join
	(select * from [SERVIDOR3].AW_Sales.Sales.SalesOrderHeader) as C
	on B.TerritoryID = C.TerritoryID)
	where A.TerritoryID != C.TerritoryID)

		print 'No existen clientes que hayan realizado pedidos en territorios distintos'
	else
		print 'Si existen'
		select * from [SERVIDOR3].AW_Sales.Sales.Customer
end

exec consultaD



--LISTO
/*e. Actualizar la cantidad de productos de una orden que se provea como argumento en la instrucci�n de actualizaci�n.*/
create or alter procedure consultaE @idProducto int, @idOrden int , @cantidad int as
begin 
set XACT_ABORT on
	if not exists (select * from [SERVIDOR3].AW_Sales.Sales.SalesOrderDetail where ProductId = @idProducto)
		print 'Error: Este producto no existe'
	else 
		begin
			if not exists (select * from [SERVIDOR3].AW_Sales.Sales.SalesOrderDetail where SalesOrderID = @idOrden and ProductID = @idProducto)
				print 'Error: Verifica el numero de orden'
			else
				begin
					begin tran Transaccion2
						begin try
							update [SERVIDOR3].AW_Sales.Sales.SalesOrderDetail
							set OrderQty = @cantidad
							where SalesOrderID = @idOrden and ProductID = @idProducto
							select * from [SERVIDOR3].AW_Sales.Sales.SalesOrderDetail where SalesOrderDetailID = 43659
							commit tran Transaccion2
						end try
						begin catch
							rollback tran Transaccion2
						end catch
				end
		end
end

select * from [SERVIDOR3].AW_Sales.Sales.SalesOrderDetail 

exec consultaE 776, 43659, 300



--LISTA
/*f. Actualizar el metodo de envio de una orden que se reciba como argumento en la instruccion de actualizacion.*/
create or alter procedure consultaF @metodoEnvio int, @idOrden int as
begin
set XACT_ABORT on

	if not exists(select * from [SERVIDOR3].AW_Sales.Sales.SalesOrderHeader where SalesOrderID = @idOrden)
		print 'Error: No existe dicha orden '
	else
	begin
		begin tran Transaccion3
			begin try
				update [SERVIDOR3].AW_Sales.Sales.SalesOrderHeader
				set ShipMethodID = @metodoEnvio
				where SalesOrderID = @idOrden
				print 'El metodo de envio se actualizo correctamente'
				select ShipMethodID from [SERVIDOR3].AW_Sales.Sales.SalesOrderHeader where SalesOrderID = 43695
				commit tran Transaccion3
			end try
			begin catch
				rollback tran Transaccion3
			end catch
	end
end

select * from [SERVIDOR3].AW_Sales.Sales.SalesOrderHeader
exec consultaF 3, 43659



/*g. Actualizar el correo electr�nico de una cliente que se reciba como argumento en la instrucci�n de actualizaci�n.*/
go
create or alter procedure consultaG @nombre nvarchar(100), @apellido nvarchar(100), @correo nvarchar(100) as
begin
set XACT_ABORT on
	if exists (
		select * from [SERVIDOR1].AW_Person.Person.EmailAddress 
		where BusinessEntityID in(
				select BusinessEntityID 
				from [SERVIDOR1].AW_Person.Person.Person as A
				where A.FirstName=@nombre and A.LastName=@apellido))
	begin
		begin tran Transaccion4
			begin try
				update [SERVIDOR1].AW_Person.Person.EmailAddress set EmailAddress = @correo
					where BusinessEntityID in(
							select BusinessEntityID from [INSTANCIA_PERSON].AW_Person.Person.Person as B
							where B.FirstName=@nombre and B.LastName=@apellido)
			--select EmailAddress from [INSTANCIA_PERSON].AW_Person.Person.EmailAddress 
				commit tran Transaccion4
			end try
			begin catch
				rollback tran Transaccion4
			end catch
	end
	else
	begin
		print('Error: No se encontro a la persona ingresada')
	end
end

exec consultaG 'Ken4', 'Sánchez', '1dasdada2' 


/*
CONCLUSIONES: 
Para implementar las transacciones en los procedimientos almacenados que ya teníamos configurados para la primera etapa del proyecto evaluamos diversas alternativas.
Aunque en las sesiones de clases se nos proporcionaron alternativas para implementar transacciones explícitas, nos decantamos por utilizar un método que encontramos por internet
el cuál es similar al try - catch de Java. De esta forma  logramos tener un código, a nuestro parecer, un poco más limpio y ordenada que si usaramos el @@error
para definir cuando sí y cuando no hacer un rollback.

*/