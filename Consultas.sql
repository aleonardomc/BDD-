
/*b. Determinar el producto m�s solicitado para la regi�n (atributo group de salesterritory) "North America"
y en que territorio de la regi�n tiene mayor demanda.*/

create or alter procedure consultaB as
	select top 1 D.[Name] as Producto, count(*) as Solicitudes, B.[Group] as Region from
	(select * from Sales.SalesOrderHeader) as A
	inner join
	(select *  from Sales.SalesTerritory where TerritoryID between '1' and '6') as B
	on A.TerritoryID = B.TerritoryID
	inner join
	(select * from Sales.SalesOrderDetail) as C
	on A.SalesOrderID = C.SalesOrderID
	inner join
	(select * from Production.Product) as D
	on C.ProductID = D.ProductID
	group by B.[Group], D.[Name]
	order by Solicitudes desc
go

/-- e. Actualizar la cantidad de productos de una orden que se provea como argumento en la instrucci�n de actualizaci�n.
go
create or alter procedure consultaE @idProducto int, @idOrden int , @cantidad int as
begin 
	if not exists (select * from Sales.SalesOrderDetail where ProductId = @idProducto)
		print 'Error: Este producto no existe'
	else 
		begin
			if not exists (select * from Sales.SalesOrderDetail where SalesOrderID = @idOrden and ProductID = @idProducto)
				print 'Error: Verifica el numero de orden'
			else
				begin
					update Sales.SalesOrderDetail
					set OrderQty = @cantidad
					where SalesOrderID = @idOrden and ProductID = @idProducto

				end
		end
end
go


--f. Actualizar el metodo de envio de una orden que se reciba como argumento en la instruccion de actualizacion.

create or alter procedure consultaF @metodoEnvio int, @idOrden int as
begin
	if not exists(select * from Sales.SalesOrderHeader where SalesOrderID = @idOrden)
		print 'Error: No existe dicha orden '
	else
	begin
		update Sales.SalesOrderHeader
		set ShipMethodID = @metodoEnvio
		where SalesOrderID = @idOrden
		print 'El metodo de envio se actualizo correctamente'
	end
end
go

--g. Actualizar el correo electr�nico de una cliente que se reciba como argumento en la instrucci�n de actualizaci�n.

create or alter procedure consultaG @email nvarchar(50), @idCliente int as
begin 
			if not exists(select * from Sales.Customer where CustomerID = @idCliente) 
				print 'Error: El ID del cliente no existe'
			else
				begin
					update Person.EmailAddress
					set EmailAddress = @email
					where BusinessEntityID = (select B.BusinessEntityID from 
						(select * from Sales.Customer where CustomerID = @idCliente) as A
						inner join
						(select * from Person.Person) as B
						on A.PersonID = B.BusinessEntityID
						inner join
						(select * from Person.EmailAddress where EmailAddress = @email) as C
						on B.BusinessEntityID = C.BusinessEntityID)
						--print 'El correo ha sido actualizado correctamente'
				end
end

  
