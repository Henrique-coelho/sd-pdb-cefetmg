#!/bin/bash

usage ()
{
    echo "Usage : $0 <MYSQL_USER> <MYSQL_PASSWORD>";
    exit;
}

if [ "$#" -ne 2 ];
then
    usage;
fi

# MySQL connection details
MYSQL_USER=$1
MYSQL_PASSWORD=$2

# Database creation query and table creation query
TABLE_QUERY="
CREATE TABLE Interactions
  (
    ID         VARCHAR (100) NOT NULL ,
    Protein_ID VARCHAR (100) NOT NULL ,
    Url        VARCHAR (100) NOT NULL ,
    Inter_1    VARCHAR (100) NOT NULL ,
    Inter_2    VARCHAR (100) ,
    Type_ID    VARCHAR (100) NOT NULL ,
    Status     VARCHAR (20) DEFAULT 'PENDING' NOT NULL
  ) ;
ALTER TABLE Interactions ADD CHECK ( Status IN ('DONE', 'ERROR', 'PENDING', 'PROCESSING')) ;
ALTER TABLE Interactions ADD CONSTRAINT Interactions_PK PRIMARY KEY ( ID ) ;


CREATE TABLE Log
  (
    User_ID   VARCHAR (100) NOT NULL ,
    System_ID VARCHAR (100) NOT NULL ,
    "Date"    DATE NOT NULL
  ) ;
ALTER TABLE Log ADD CONSTRAINT Log_PK PRIMARY KEY ( "Date" ) ;


CREATE TABLE Proteins
  (
    ID     VARCHAR (100) NOT NULL ,
    Status VARCHAR (10) DEFAULT 'PENDING' NOT NULL
  ) ;
ALTER TABLE Proteins ADD CHECK ( Status IN ('DONE', 'PENDING', 'PROCESSING')) ;
ALTER TABLE Proteins ADD CONSTRAINT Proteins_PK PRIMARY KEY ( ID ) ;


CREATE TABLE Task
  (
    Interactions_ID   VARCHAR (100) NOT NULL ,
    Status            VARCHAR (20) DEFAULT 'PENDING' NOT NULL ,
    Last_Modification DATE NOT NULL ,
    System_ID         VARCHAR (100) NOT NULL ,
    Name              VARCHAR (50)
  ) ;
ALTER TABLE Task ADD CHECK ( Status IN ('DONE', 'PENDING', 'PROCESSSING')) ;
ALTER TABLE Task ADD CONSTRAINT Task_PK PRIMARY KEY ( Interactions_ID, Last_Modification, System_ID ) ;


CREATE TABLE Type
  (
    ID          VARCHAR (100) NOT NULL ,
    Description VARCHAR (120)
  ) ;
ALTER TABLE Type ADD CONSTRAINT Type_PK PRIMARY KEY ( ID ) ;


CREATE TABLE "User"
  (
    ID       VARCHAR (100) NOT NULL ,
    Password VARCHAR (8) NOT NULL ,
    Type     VARCHAR (20) NOT NULL
  ) ;
ALTER TABLE "User" ADD CONSTRAINT User_PK PRIMARY KEY ( ID ) ;


ALTER TABLE Interactions ADD CONSTRAINT Interactions_Proteins_FK FOREIGN KEY ( Protein_ID ) REFERENCES Proteins ( ID ) ON
DELETE CASCADE ;

ALTER TABLE Interactions ADD CONSTRAINT Interactions_Type_FK FOREIGN KEY ( Type_ID ) REFERENCES Type ( ID ) ON
DELETE CASCADE ;

ALTER TABLE Log ADD CONSTRAINT Log_User_FK FOREIGN KEY ( User_ID ) REFERENCES "User" ( ID ) ;

ALTER TABLE Task ADD CONSTRAINT Task_Interactions_FK FOREIGN KEY ( Interactions_ID ) REFERENCES Interactions ( ID ) ;
"

echo $TABLE_QUERY |  mysql -u "$1" -p"$2" -D "proteinDB"