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

# Database creation query
CREATE_DB="CREATE SCHEMA IF NOT EXISTS `proteins_db` DEFAULT CHARACTER SET utf8 ;

USE `proteins_db` ;
"

# Table creation query
TABLE_QUERY="CREATE TABLE interactions (
    id         NUMBER(50) NOT NULL,
    protein_id NUMBER(50, 10) NOT NULL,
    url        VARCHAR2(100 CHAR),
    inter_1    VARCHAR2(10 CHAR) NOT NULL,
    inter_2    VARCHAR2(10 CHAR) NOT NULL,
    type_id    NUMBER(50) NOT NULL,
    status     VARCHAR2(50 CHAR) DEFAULT 'PENDING' NOT NULL
);

ALTER TABLE interactions
    ADD CHECK ( status IN ( 'DONE', 'ERROR', 'PENDING', 'PROCESSING' ) );

ALTER TABLE interactions ADD CONSTRAINT interactions_pk PRIMARY KEY ( id );

CREATE TABLE log (
    user_id   NUMBER(50) NOT NULL,
    system_id NUMBER(50) NOT NULL,
    data      DATE NOT NULL
);

ALTER TABLE log ADD CONSTRAINT log_pk PRIMARY KEY ( data );

CREATE TABLE proteins (
    proteins_id NUMBER(10)
        CONSTRAINT nnc_proteins_id NOT NULL,
    status      VARCHAR2(10 CHAR) DEFAULT 'PENDING'
        CONSTRAINT nnc_proteins_status NOT NULL
);

ALTER TABLE proteins
    ADD CHECK ( status IN ( 'DONE', 'PENDING', 'PROCESSING' ) );

ALTER TABLE proteins ADD CONSTRAINT proteins_pk PRIMARY KEY ( proteins_id );

CREATE TABLE task (
    iteractions_id    NUMBER(50) NOT NULL,
    task_status       VARCHAR2(10 CHAR) DEFAULT 'PENDING' NOT NULL,
    last_modification VARCHAR2(10 CHAR),
    system_id         NUMBER(50) NOT NULL,
    task_name         VARCHAR2(50 CHAR)
);

ALTER TABLE task
    ADD CHECK ( task_status IN ( '', 'DONE', 'PENDING', 'PROCESSING' ) );

ALTER TABLE task ADD CONSTRAINT task_pk PRIMARY KEY ( iteractions_id );

CREATE TABLE type (
    id          NUMBER(10) NOT NULL,
    description VARCHAR2(50 CHAR)
);

ALTER TABLE type ADD CONSTRAINT type_pk PRIMARY KEY ( id );

CREATE TABLE "user" (
    id       NUMBER(50) NOT NULL,
    password NUMBER(50) NOT NULL,
    type     VARCHAR2(50 CHAR) NOT NULL
);

ALTER TABLE "user" ADD CONSTRAINT user_pk PRIMARY KEY ( id );

ALTER TABLE interactions
    ADD CONSTRAINT interactions_proteins_fk FOREIGN KEY ( protein_id )
        REFERENCES proteins ( proteins_id )
            ON DELETE CASCADE;

ALTER TABLE interactions
    ADD CONSTRAINT interactions_type_fk FOREIGN KEY ( type_id )
        REFERENCES type ( id )
            ON DELETE CASCADE;

ALTER TABLE log
    ADD CONSTRAINT log_user_fk FOREIGN KEY ( user_id )
        REFERENCES "user" ( id )
            ON DELETE CASCADE;

ALTER TABLE task
    ADD CONSTRAINT task_interactions_fk FOREIGN KEY ( iteractions_id )
        REFERENCES interactions ( id )
            ON DELETE CASCADE;"

# Connect to MySQL and execute table creation query
echo mysql -u "$1" -p"$2" "$CREATE_DB" -e "$TABLE_QUERY"
