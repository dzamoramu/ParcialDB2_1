-- Database: ParcialDB2

-- DROP DATABASE "ParcialDB2";

// Tabla Country
CREATE TABLE Country(
	countryId int NOT NULL,
	nombre varchar(40) NOT NULL,
	primary key (countryId)
);

INSERT INTO Country(countryId,nombre) 
VALUES ('2110','Colombia'),
('3989','Argentina'),
('1352','Chile'),
('1091','Mexico'),
('1021','Uruguay'),
('5870','Brasil');


//Tabla City
CREATE TABLE City(
	cityId int NOT NULL,
	nombre varchar(40) NOT NULL,
	countryId int NOT NULL,
	primary key (cityId),
	FOREIGN KEY(countryId) REFERENCES Country(countryId)
);

INSERT INTO City(cityID,nombre,countryId) 
VALUES ('123','Bogota','2110'),
('234','Buenos Aires','3989'),
('345','Santiago','1352'),
('456','Ciudad de Mexico','1091'),
('567','Montevideo','1021'),
('678','Brasilia','5870');

//Tabla Address
CREATE TABLE Address(
	addressId int NOT NULL,
	line1 varchar(40) NOT NULL,
	line2 varchar(40) NOT NULL,
	cityId int NOT NULL,
	primary key (addressId),
	FOREIGN KEY(cityId) REFERENCES City(cityId)
);

INSERT INTO Address(addressId,line1,line2,cityId)
VALUES ('1','avenida 9','187-14','123'),
('2','buenavida','237','234'),
('3','Siempre viva','23','345'),
('4','guanajuato','343','456'),
('5','54','saint juarez','567'),
('6','Rua das Pedras','32','678');

//Tabla BranchOffice
CREATE TABLE BranchOffice(
	branchId int NOT NULL,
	nombre varchar(40) NOT NULL,
	addressId int NOT NULL,
	primary key(branchId),
	FOREIGN KEY(addressId) REFERENCES Address(addressId)
);

INSERT INTO BranchOffice(branchId,nombre,addressId)
VALUES ('01','PrimeraNueva','1'),
('02','PrimeraVieja','2'),
('03','SegundaNueva','3'),
('04','SegundaVieja','4'),
('05','TerceraNueva','5'),
('06','TerceraVieja','6');

//Tabla EmployeeId
CREATE TABLE Employee(
	employeeId int NOT NULL,
	fullName varchar(40) NOT NULL,
	branchId int NOT NULL,
	departmentId int NOT NULL,
	positionId int NOT NULL,
	addressId int NOT NULL,
	supervisorId int NOT NULL,
	primary key(employeeId),
	FOREIGN KEY(addressId) REFERENCES Address(addressId),
	FOREIGN KEY(branchId) REFERENCES BranchOffice(branchId),
	FOREIGN KEY(departmentId) REFERENCES Department(departmentId),
	FOREIGN KEY(positionId) REFERENCES Posicion(positionId),
	FOREIGN KEY(supervisorId) REFERENCES Supervisor(supervisorId)
);

INSERT INTO Employee(employeeId,fullName,branchId,departmentId,positionId,addressId,supervisorId)
VALUES ('012','Anita','01','12345','21','1','12'),
('013','Maria','02','23456','22','2','13'),
('014','Claudia','03','34567','23','3','14'),
('015','Daniela','04','45678','24','4','15'),
('016','Manuel','05','56789','25','5','16'),
('017','David','06','90123','26','6','17');

//Tabla Positionid
CREATE TABLE Posicion(
	positionId int NOT NULL,
	nombre varchar(40) NOT NULL,
	primary key(positionId)
);

INSERT INTO Posicion(positionId,nombre)
VALUES ('21','centralizada'),
('22','alejada'),
('23','medianaCerca'),
('24','medianalejana'),
('25','muylejos'),
('26','muycerca');

//Tabla Department
CREATE TABLE Department(
	departmentId int NOT NULL,
	nombre varchar(40) NOT NULL,
	primary key(departmentId)
);

INSERT INTO Department(departmentId,nombre)
VALUES ('12345','centralizada'),
('23456','alejada'),
('34567','medianaCerca'),
('45678','medianalejana'),
('56789','muylejos'),
('90123','muycerca');



//Tabla supervisor
CREATE TABLE Supervisor(
	supervisorId int NOT NULL,
	nombre varchar(40) NOT NULL,
	primary key(supervisorId)
);

INSERT INTO Supervisor(supervisorId,nombre)
VALUES ('12','Carlos'),
('13','Alejandra'),
('14','Camila'),
('15','Daniel'),
('16','Juan'),
('17','Valentina');

//Tabla EmployeeAudit

CREATE TABLE EmployeeAudit(
	employeeId int NOT NULL,
	fullName varchar(40) NOT NULL,
	branchId int NOT NULL,
	departmentId int NOT NULL,
	positionId int NOT NULL,
	addressId int NOT NULL,
	city varchar(40),
	country varchar(40),
	evento varchar(40),
	registeredAt date
);

CREATE OR REPLACE FUNCTION changes()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
 $$
 DECLARE
 city varchar(40);
 cityId int;
 countryId int;
 nombre varchar(40);
 
 BEGIN
 
 	IF NEW.fullName <> OLD.fullName THEN
		
 		 INSERT INTO EmployeeAudit(employeeId, fullName,branchId, departmentId, positionId, addressId,registeredAt)
	 	 VALUES(old.employeeId, old.fullName, old.branchId, old.departmentId, old.positionId,old.addressId,now());

	END IF;

 	RETURN NEW;
END;
$$

CREATE TRIGGER changes_employee
  AFTER INSERT OR DELETE OR UPDATE
  ON employee
  FOR EACH ROW
  EXECUTE PROCEDURE changes();
 
 
 SELECT * FROM employee;
 SELECT * FROM EmployeeAudit;
 
 UPDATE employee
 SET fullname = 'Camila'
 WHERE employeeId = 12;
 

 CREATE MATERIALIZED VIEW RrhhView AS 
	select 
		(Department.nombre) as NameDepartment,
		(Posicion.nombre) as Posicion,
		 BranchOffice.nombre
	from Department,Posicion,BranchOffice,Employee
	where Department.departmentId = Employee.departmentId
	and  Posicion.positionId = Employee.positionId
	and BranchOffice.nombre='SegundaNueva'
	order by (Department.nombre);

select * from RrhhView;


